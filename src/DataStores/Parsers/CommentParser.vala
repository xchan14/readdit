using Gee;
using ReadIt.Posts.PostDetails.Comments;

namespace ReadIt.DataStores.Parsers {

    /**
     *  Parses a Comment object from comment json data returned by API.
     */ 
    public class CommentParser {
        Json.Parser _parser = new Json.Parser();

        public CommentCollection parse_comments(string data) {
            stdout.printf("Parsing data from response.\n");
            this._parser.load_from_data(data, -1);
            var root_object = this._parser.get_root().get_array();
            GLib.List<weak Json.Node> json_comments = root_object.get_element(1) 
                .get_object() 
                .get_object_member("data") 
                .get_array_member("children")
                .get_elements();
            
            return parse_comments_recursively(json_comments);
        }

        /**
         *  Parses the comments recursively.
         */ 
        private CommentCollection parse_comments_recursively(GLib.List<weak Json.Node> comment_nodes) {
            if(comment_nodes == null)
                return new CommentCollection();
            CommentCollection comment_collection = new CommentCollection();

            foreach(Json.Node comment_node in comment_nodes) {
                Json.Object comment_obj = comment_node.get_object();
                string kind = comment_obj.get_string_member("kind");
                Json.Object data_obj = comment_obj.get_object_member("data");

                if(kind == "t1") {
                    Comment comment = parse_comment_from_json(data_obj);
                    comment_collection.add(comment);
                    // Parse replies from the comment object.
                    GLib.List<weak Json.Node> replies_node = get_replies_nodes(data_obj);
                    // Recursive call to parse inner comments.
                    comment.comment_collection = parse_comments_recursively(replies_node);
                } else if (kind == "more") {
                    // Parse ids if there are more comments.
                    comment_collection.more_comment_ids = parse_more_comment_ids(data_obj);
                } else {
                    continue;
                }
            }
            return comment_collection;
        }

        /*
         * Returns a Comment object parsed from JSON object returned by API.
         */ 
        private Comment parse_comment_from_json(Json.Object comment_obj) {
            var comment = new Comment() {
                id = comment_obj.get_string_member("name"),
                text = comment_obj.get_string_member("body"),
                comment_by = comment_obj.get_string_member("author"),
                score = (int) comment_obj.get_int_member("score")
            };
            return comment;
        }

        private ArrayList<string> parse_more_comment_ids(Json.Object more_comment_obj) {
            GLib.List<weak Json.Node> ids_nodes = more_comment_obj
                .get_array_member("children")
                .get_elements();
            var ids = new ArrayList<string>();
            foreach(Json.Node id_node in ids_nodes) {
                ids.add(id_node.get_string());
            }
            return ids;
        }

        /*
         * Returns the replies(List<Json.Node>) from a given comment(Json.Object). 
         */
        private GLib.List<weak Json.Node> get_replies_nodes(Json.Object parent_obj) {
            var replies = parent_obj.get_object_member("replies");
            if(replies == null)
                return null;

            return replies
                .get_object_member("data") 
                .get_array_member("children") 
                .get_elements();
        }

    }

}