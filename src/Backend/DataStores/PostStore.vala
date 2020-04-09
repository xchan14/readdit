using Posts;
using Gee;
using ReadIt;
using Posts.PostList;

namespace Backend.DataStores {

    public class PostStore : Object {
        private static PostStore _instance;

        public signal void posts_loaded(Iterable<Post> posts);
        public signal void viewed_post_changed(Post post);

        private HashMap<string, Post> _loaded_posts = new HashMap<string, Post>();
        private Post _current_viewed_post; 
        private string _last_post_id_loaded;
        private string _current_subreddit;
        private bool _is_loading_post;

        public Iterable<Post> loaded_posts { 
            owned get { 
                var values = new ArrayList<Post>.wrap(_loaded_posts.values.to_array(), null);
                values.sort((a, b) => {
                    if(a.date_loaded.to_unix() < b.date_loaded.to_unix())
                        return -1;
                    else if(a.date_loaded.to_unix() > b.date_loaded.to_unix())
                        return 1;
                    else return 0;
                }); 
                return values;
            } 
        } 

        public Post current_viewed_post {
            get {
                return _current_viewed_post;
            }
        }

        public static PostStore INSTANCE {
            get {
                if(_instance == null) {
                    _instance = new PostStore();
                }
                return _instance;
            }
        }

        private PostStore() { 
            Dispatcher.INSTANCE.action_dispatched.connect((action) => {
                switch(action.name) {
                    case "load_more_posts_action":
                        var load_posts_action = (LoadMorePostsAction) action;
                        load_posts(load_posts_action.subreddit);
                        break;
                    case "view_post_action":
                        var view_post_action = (ViewPostAction) action;
                        view_post(view_post_action.post_id);
                        break;
                }
            });
        }

        private void load_posts(string? subreddit) {
            _is_loading_post = true;
            if(subreddit == null)
                subreddit = _current_subreddit;

            stdout.printf("Loading new posts for %s.\n", subreddit);
            if(_current_subreddit != subreddit) {
                // Clear cached post items if subreddit changes.
                _loaded_posts.clear();
            }
            var session = new Soup.Session();
            var url = "https://reddit.com/" + subreddit + ".json?"
                    + "&limit=10"
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

                _is_loading_post = false;
                _current_subreddit = subreddit;
                posts_loaded(loaded_posts);
            });

        }

        private Post map_post_from_json(Json.Node post_node) {
            var post_data = post_node.get_object()
                            .get_object_member("data");
            var post = new Post(); 
            post.id = post_data.get_string_member("name");
            post.title = post_data.get_string_member("title");
            post.body_text = post_data.get_string_member("selftext_html");
            post.score = (int) post_data.get_int_member("score");
            post.subreddit = post_data.get_string_member("subreddit_name_prefixed");
            post.posted_by = post_data.get_string_member("author");
            post.posted_by_id = post_data.get_string_member("author_fullname");
            post.date_created = new DateTime.from_unix_local((long)post_data.get_double_member("created_utc"));
            post.date_loaded = new DateTime.now_utc();
            return post;
        }

        private void view_post(string post_id) {
            _current_viewed_post = _loaded_posts[post_id];
            viewed_post_changed(_current_viewed_post);
        }

    }

}