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
using ReaddIt.Posts.PostDetails.Comments;

namespace ReaddIt.DataStores.Parsers {

    /**
     *  Parses a Comment object from comment json data returned by API.
     */ 
    public class CommentParser {
        Json.Parser _parser = new Json.Parser();

        public CommentCollection parse_comments(string? parent_id, string data) {
            this._parser.load_from_data(data, -1);
            var root_object = this._parser.get_root().get_array();
            GLib.List<weak Json.Node> json_comments = root_object.get_element(1) 
                .get_object() 
                .get_object_member("data") 
                .get_array_member("children")
                .get_elements();
            
            return parse_comments_recursively(parent_id, 0, json_comments);
        }

        public Collection<Comment> parse_more_comments(string data) {
            this._parser.load_from_data(data, -1);
            var root_object = this._parser.get_root().get_object();

            GLib.List<weak Json.Node> things_nodes = root_object 
                .get_object_member("json")
                .get_object_member("data")
                .get_array_member("things")
                .get_elements();
            
            var comments = new ArrayList<Comment>();
            foreach(Json.Node comment_node in things_nodes) {
                Json.Object comment_obj = comment_node.get_object();
                string kind = comment_obj.get_string_member("kind");
                Json.Object data_obj = comment_obj.get_object_member("data");
                
                if(kind == "t1") {
                    Comment comment = parse_comment_from_json(data_obj);
                    comments.add(comment);
                } else {
                    stdout.printf("Kind is %s...\n", kind);
                }
            }

            return comments;
        }

        /**
         *  Parses the comments recursively.
         */ 
        private CommentCollection parse_comments_recursively(string? parent_id = null, int depth = 0, GLib.List<weak Json.Node>? comment_nodes = null) {
            if(comment_nodes == null)
                return new CommentCollection(null, depth);

            CommentCollection comment_collection = new CommentCollection(parent_id, depth);
            
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
                    int children_depth = comment.depth + 1;
                    comment.comment_collection = parse_comments_recursively(comment.id, children_depth, replies_node);
                } else if (kind == "more") {
                    // Parse ids if there are more comments.
                    var more_ids = parse_more_comment_ids(data_obj);
                    comment_collection.more_comment_ids.add_all(more_ids);
                } 
            }

            return comment_collection;
        }

        /*
         * Returns a Comment object parsed from JSON object returned by API.
         */ 
        public Comment parse_comment_from_json(Json.Object comment_obj) {
            string id = comment_obj.get_string_member("name");
            int depth = (int) comment_obj.get_int_member("depth");
            var comment = new Comment(id, depth) {
                text = comment_obj.get_string_member("body"),
                comment_by = comment_obj.get_string_member("author"),
                score = (int) comment_obj.get_int_member("score"),
                date_created = new DateTime.from_unix_local(comment_obj.get_int_member("created")),
                parent_id = comment_obj.get_string_member("parent_id"),
                comment_collection = new CommentCollection(null, depth)
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
            Json.Node replies_node = parent_obj.get_member("replies");
            if(replies_node.get_node_type() != Json.NodeType.OBJECT)
                return new GLib.List<weak Json.Node>();

            Json.Object replies_obj = replies_node.get_object();
            return replies_obj
                .get_object_member("data") 
                .get_array_member("children") 
                .get_elements();
        }

    }

}