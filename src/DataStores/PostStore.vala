/*
* Copyright (c) 2020 Christian Camilon 
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 2 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*
* Authored by: Christian Camilon <christiancamilon@gmail.com>
*/

using Gee;
using Readdit.DataStores.Parsers;
using Readdit.Models.Posts;
using Readdit.Models.Comments;
using Readdit.Views.PostList;
using Readdit.Views.PostDetails;

namespace Readdit.DataStores {

    public class PostStore : Object {
        private static PostStore _instance;

        public signal void emit_change();

        private ArrayList<Post> _loaded_posts = new ArrayList<Post>();
        private Post _current_viewed_post; 
        private string _current_subreddit;
        private string _current_post_sort;
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

        public static void init() {
            var instance = INSTANCE;
        }

        public Collection<Post> loaded_posts { 
            owned get { 
                return this._loaded_posts;
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
                load_posts(action.sort_by, action.subreddit);
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
            } else if (dispatched_action is LoadMoreCommentsAction) {
                var action = (LoadMoreCommentsAction) dispatched_action;
                load_more_comments(action.parent_id, action.depth);
            } 


        }

        private void load_posts(string sort_by, string? subreddit) {
            this._is_loading_post = true;
            //if(subreddit == null)
            //    subreddit = this._current_subreddit;

            if(this._current_subreddit != subreddit || this._current_post_sort != sort_by) {
                // Clear cached post items if subreddit changes.
                this._loaded_posts.clear();
                this._current_subreddit = subreddit;
                this._current_post_sort = sort_by;
                stdout.printf("Post list cleared in store...\n");
            }
            var session = new Soup.Session();
            string last_loaded_post_id = null;
            if(!this._loaded_posts.is_empty) {
                last_loaded_post_id = this._loaded_posts.last().id;
            }
            
            var endpoint = subreddit == null ? sort_by : subreddit + "/" + sort_by;
            stdout.printf("url endpoint: %s...\n", endpoint);
            var url = Constants.REDDIT_BASE_API + "/" + endpoint + ".json?"
                    + "&limit=10"
                    + "&after=" + last_loaded_post_id;

            stdout.printf("Getting post from api...\nurl: %s\n", url);
            var message = new Soup.Message("GET", url);

            session.queue_message(message, (sess, mess) => {

                stdout.printf("Parsing data from response.\n");
                string data = (string)message.response_body.flatten().data;
                var post_parser = new PostParser();
                this._loaded_posts.add_all(post_parser.parse_from_data(data)); 

                info("Caching posts finished...\n");

                this._is_loading_post = false;
                info("Total posts: %d\n", this._loaded_posts.size);
                this.emit_change();
            });

        }

        private void view_post(string? post_id) {
            this._current_viewed_post = post_id == null ? null
                : this._loaded_posts.first_match(p => p.id == post_id);
            this.emit_change();
        }

        private void load_post_preview(string post_id, string url) {
            // Create cache file.
            Post post = this._loaded_posts.first_match(p => p.id == post_id);
            
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
            Post post = this._loaded_posts.first_match(p => p.id == post_id);
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
            Post post = this._loaded_posts.first_match(p => p.id == post_id);
            if(post.comment_collection != null) {
                stdout.printf("Comments are already downloaded...\n");
                this.emit_change();
                return;
            }
            string url = Constants.REDDIT_BASE_API + "/" + post.subreddit + "/comments/article.json?"
                + "&raw_json=1" 
                + "&article=" + post.id.replace("t3_", "")
                + "&after=" + after;
            
            stdout.printf("url: %s\n", url);

            var message = new Soup.Message("GET", url);
            var session = new Soup.Session();

            session.queue_message(message, (sess, mess) => {
                try {
                    string data = (string)message.response_body.flatten().data;
                    CommentParser parser = new CommentParser(); 
                    CommentCollection comment_collection = parser.parse_comments(null, data);
                    post.comment_collection = comment_collection;
                    this.emit_change();
                } catch(Error e) {
                    error("Error: %s\n", e.message);
                }
            });
        }

        private void load_more_comments(string? parent_id = null, int depth) {
            stdout.printf("Loading more comments of parent %s in post store...\n", parent_id);
            // Get parent comment collection object.
            CommentCollection parent_comment_collection = this.current_viewed_post.comment_collection;

            stdout.printf("Finding parent comment (%s) to load in post store...\n", parent_id);
            parent_comment_collection = parent_comment_collection.find_by_parent_id(parent_id, depth);
            if(parent_comment_collection == null) {
                stdout.printf("Parent %s not found...\n", parent_id);
                return;
            }
            stdout.printf("Parent %s comment collection found...\n", parent_comment_collection.parent_id);
            int item_count = 10;
            if(parent_comment_collection.more_comment_ids.size < item_count) {
                item_count = parent_comment_collection.more_comment_ids.size;
            }
            var children_ids = new Gee.ArrayList<string>();
            for(int i = 1; i <= item_count; i++) {
                string removed_id = parent_comment_collection.more_comment_ids.remove_at(0);
                children_ids.add(removed_id); 
            }

            // Send http request.
            string joined_children = string.joinv(",", children_ids.to_array());
            string url = Constants.REDDIT_BASE_API + "/api/morechildren.json?"
                + "&api_type=json"
                + "&link_id=" + this.current_viewed_post.id
                + "&limit_children=true"
                + "&children=" + joined_children;
            stdout.printf("Loading more comments in %s...\n", url);
            var message = new Soup.Message("GET", url);
            var session = new Soup.Session();
            session.queue_message(message, (sess, mess) => {
                try {
                    string data = (string)message.response_body.flatten().data;
                    CommentParser parser = new CommentParser();
                    stdout.printf("Parsing api result...\n");
                    Collection<Comment> more_comments = parser.parse_more_comments(data);
                    stdout.printf("More comments parsing finished...\n");

                    foreach(Comment comment in more_comments) {
                        bool isPostParent = parent_comment_collection.parent_id == null 
                            && comment.parent_id.contains("t3_");
                        if(comment.parent_id == parent_comment_collection.parent_id
                            || isPostParent) {
                            parent_comment_collection.add(comment);
                            stdout.printf("Added comment %s to parent %s...\n", comment.id, parent_comment_collection.parent_id);
                        } else {
                            stdout.printf("Adding comment %s to a parent...\n", comment.id);
                            CommentCollection parent_comment = parent_comment_collection
                                .find_by_parent_id(comment.parent_id, parent_comment_collection.depth);
                            if(parent_comment != null) {
                                parent_comment.add(comment);
                                stdout.printf("Added comment %s to parent %s...\n", comment.id, parent_comment.parent_id);
                            } else {
                                stdout.printf("No parent(%s) found to add new comment(%s)...\n", comment.parent_id, comment.id);
                            }
                        }
                    }

                    this.emit_change();
                } catch(Error e) {
                    stderr.printf(e.message);
                }
            });
        }

    }

}
