using Gee;
using ReadIt.Posts;
using ReadIt.Posts.PostList;
using ReadIt.Posts.PostDetails;
using ReadIt.Posts.PostDetails.Comments;

namespace ReadIt.Backend.DataStores {

    public class PostStore : Object {
        private static PostStore _instance;
        private static string REDDIT_API = "http://reddit.com";

        public signal void emit_change();

        private TreeMap<string, Post> _loaded_posts = new TreeMap<string, Post>();
        private Post _current_viewed_post; 
        private string _last_post_id_loaded;
        private string _current_subreddit;
        private bool _is_loading_post;

        private PostStore() { 
            Dispatcher.INSTANCE.action_dispatched.connect(handle_dispatched_actions);
        }

        public static PostStore INSTANCE {
            get {
                if(_instance == null) {
                    _instance = new PostStore();
                }
                return _instance;
            }
        }

        public Collection<Post> loaded_posts { 
            owned get { 
                return _loaded_posts.values;
                /*  var values = new ArrayList<Post>.wrap(_loaded_posts.values.to_array(), null);
                values.sort((a, b) => {
                    if(a.date_loaded.to_unix() < b.date_loaded.to_unix())
                        return -1;
                    else if(a.date_loaded.to_unix() > b.date_loaded.to_unix())
                        return 1;
                    else return 0;
                }); 
                return values; */            
            } 
        } 

        public Post current_viewed_post {
            owned get {
                return this._current_viewed_post;
            }
        }

        public bool is_loading_new_posts {
            get {
                return this._is_loading_post;
            }
        }
        
        private void handle_dispatched_actions(Action dispatched_action) {
            if(dispatched_action is LoadMorePostsAction) {
                var action = (LoadMorePostsAction) dispatched_action;
                load_posts(action.subreddit);
            } else if (dispatched_action is ViewPostAction) {
                var action = (ViewPostAction) dispatched_action;
                view_post(action.post_id);
            } else if (dispatched_action is LoadPostPreviewAction) {
                var action = (LoadPostPreviewAction) dispatched_action;
                load_post_preview(action.post_id, action.url);
            } else if (dispatched_action is LoadPostDetailsImageAction) {
                var action = (LoadPostDetailsImageAction) dispatched_action;
                load_post_details_image_action(action.post_id, action.image_url);
            } else if (dispatched_action is LoadPostCommentsAction) {
                var action = (LoadPostCommentsAction) dispatched_action;
                load_comments(action.post_id, action.after);
            }
        }

        private void load_posts(string? subreddit) {
            this._is_loading_post = true;
            if(subreddit == null)
                subreddit = this._current_subreddit;

            if(this._current_subreddit != subreddit) {
                // Clear cached post items if subreddit changes.
                this._loaded_posts.clear();
            }
            var session = new Soup.Session();
            var url = REDDIT_API + "/" + subreddit + ".json?"
                    + "&limit=20"
                    + "&after=" + _last_post_id_loaded;

            stdout.printf("Getting post from api...\nurl: %s\n", url);
            var message = new Soup.Message("GET", url);

            session.queue_message(message, (sess, mess) => {
                var parser = new Json.Parser();

                try {
                    stdout.printf("Parsing data from response.\n");
                    string data = (string)message.response_body.flatten().data;
                    parser.load_from_data(data, -1);
                    Json.Object root_object = parser.get_root ().get_object ();
                    Json.Array post_items = root_object
                        .get_object_member("data")
                        .get_array_member("children"); 

                    GLib.List<weak Json.Node> items = post_items.get_elements();
                    foreach(Json.Node post_node in items) {
                        Post post = map_post_from_json(post_node);
                        this._loaded_posts.set(post.id, post);
                        this._last_post_id_loaded = post.id;
                    }
                } catch(Error e) {
                    stderr.printf("Error: %s\n", e.message);
                }

                stdout.printf("Caching posts finished...\n");

                this._is_loading_post = false;
                this._current_subreddit = subreddit;
                stdout.printf("Total posts: %d\n", this._loaded_posts.size);
                this.emit_change();
            });

        }

        private Post map_post_from_json(Json.Node post_node) {
            var post_data = post_node.get_object().get_object_member("data");
            var post = new Post(); 
            post.id = post_data.get_string_member("name");
            post.title = post_data.get_string_member("title");
            post.body_text = post_data.get_string_member("selftext");
            post.score = (int) post_data.get_int_member("score");
            post.subreddit = post_data.get_string_member("subreddit_name_prefixed");
            post.posted_by = post_data.get_string_member("author");
            post.posted_by_id = post_data.get_string_member("author_fullname");
            post.date_created = new DateTime.from_unix_local((long)post_data.get_double_member("created_utc"));
            post.is_video = post_data.get_boolean_member("is_video");

            if(!post.is_video) {
                // Cache preview image file.
                Json.Object preview_object = post_data.get_object_member("preview");
                if(preview_object != null) {
                    // If preview is not null and is not a video, post's url is an image. 
                    Json.Array image_array_object = preview_object.get_array_member("images"); 
                    if(image_array_object != null) {
                        Json.Object image_object = image_array_object
                            .get_element(0)
                            .get_object();

                        post.image_url = image_object.get_object_member("source")
                            .get_string_member("url")
                            .replace("&amp;" ,"&");

                        Json.Object resolutions_object = image_object
                            .get_array_member("resolutions")
                            .get_element(1).get_object();
                        post.preview_url = resolutions_object
                            .get_string_member("url")
                            .replace("&amp;" ,"&");
                    }
                }
            }


            post.date_loaded = new DateTime.now_utc();
            return post;
        }

        private void view_post(string? post_id) {
            this._current_viewed_post = post_id != null ? this._loaded_posts[post_id] : null;
            this.emit_change();
        }

        private void load_post_preview(string post_id, string url) {
            // Create cache file.
            Post post = this._loaded_posts[post_id];
            
            try {
                string preview_dir = Environment.get_user_cache_dir() 
                    + "/" + Environment.get_application_name() 
                    + "/posts/previews";
                File file_preview_dir  = File.new_for_path(preview_dir);
                if(!file_preview_dir.query_exists(null)) {
                    file_preview_dir.make_directory_with_parents(null); 
                }

                post.preview_path = preview_dir + "/" + post.id + ".png";
                File file_preview_path = File.new_for_path(post.preview_path);

                if(!file_preview_path.query_exists(null)) {
                    var loop = new MainLoop();
                    var file_preview_url = File.new_for_uri(post.preview_url);
                    file_preview_url.copy_async.begin(file_preview_path, FileCopyFlags.OVERWRITE, Priority.DEFAULT, null, null,
                        () => {
                            stdout.printf("File downloaded...\n");
                            loop.quit();
                            this.emit_change();
                        });
                    loop.run();
                } else {
                    this.emit_change();
                }
            } catch(Error e) {
                post.preview_path = null;
                this.emit_change();
            } 
        }

        private void load_post_details_image_action(string post_id, string url) {
            // Create cache file.
            Post post = _loaded_posts[post_id];
            try {
                string image_dir = Environment.get_user_cache_dir() 
                    + "/" + Environment.get_application_name() 
                    + "/posts/images";
                File file_image_dir  = File.new_for_path(image_dir);
                if(!file_image_dir.query_exists(null)) {
                    file_image_dir.make_directory_with_parents(null); 
                }

                post.image_path = image_dir + "/" + post.id + ".jpg";
                File file_image_path = File.new_for_path(post.image_path);
                if(!file_image_path.query_exists(null)) {
                    file_image_path.create(FileCreateFlags.REPLACE_DESTINATION, null);
                    var file_image_url = File.new_for_uri(post.image_url);
                    var loop = new MainLoop();
                    file_image_url.copy_async.begin(file_image_path, FileCopyFlags.OVERWRITE, Priority.DEFAULT, null, null, 
                        () => { 
                            loop.quit();
                            stdout.printf("File copied\n"); 
                            this.emit_change();
                        });
                    loop.run();
                } 
            } catch(Error e) {
                post.image_path = null;
                stderr.printf("%s\n", e.message);
            } 
        }

        private void load_comments(string post_id, string? after) {
            string url = REDDIT_API + "/" + this._current_viewed_post.subreddit + "/comments/article.json?"
                + "article=" + this._current_viewed_post.id.replace("t3_", "")
                + "&after=" + after;

            var message = new Soup.Message("GET", url);
            var session = new Soup.Session();

            session.queue_message(message, (sess, mess) => {
                var parser = new Json.Parser();

                try {
                    stdout.printf("Parsing data from response.\n");
                    string data = (string)message.response_body.flatten().data;
                    parser.load_from_data(data, -1);
                    var root_object = parser.get_root().get_array();
                    GLib.List<weak Json.Node> json_comments = root_object.get_element(1) 
                        .get_object() 
                        .get_object_member("data") 
                        .get_array_member("children")
                        .get_elements();

                    var comments = new ArrayList<Comment>();
                    foreach(Json.Node item in json_comments) {
                        if(item.get_object().get_string_member("kind") != "t1")
                            continue;

                        Json.Object data_obj = item.get_object()
                            .get_object_member("data");
                        var comment = new Comment() {
                            id = data_obj.get_string_member("name"),
                            text = data_obj.get_string_member("body"),
                            comment_by = data_obj.get_string_member("author")
                        };
                        comments.add(comment);
                    }
                    this._current_viewed_post.comments = comments;

                    this.emit_change();
                    
                }catch(Error e) {
                    stderr.printf("Error: %s\n", e.message);
                }
            });
        }
    }

}