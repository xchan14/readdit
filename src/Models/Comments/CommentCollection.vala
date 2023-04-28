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

namespace Readdit.Models.Comments {
    public class CommentCollection : ArrayList<Comment> {
        
        public CommentCollection(string? parent_id = null, int depth) {
            Object(
                parent_id: parent_id,
                depth: depth
            );
            more_comment_ids = new ArrayList<string>();
        }

        // Contains the id of parent comment. If null, it means that
        // it is the top level comment collection which is the post comments.
        public string? parent_id { get; construct; }
        public int depth { get; construct; }
        public ArrayList<string> more_comment_ids { get; private set; }

        /*
         * Find comment collection recursively by parent id.
         */
        public CommentCollection find_by_parent_id(string? parent_id = null, int depth = 0) {
            if(parent_id == null)
                return this;

            foreach(Comment comment in this) {
                if(comment.id == parent_id) {
                    stdout.printf("Parent %s found...\n", parent_id);
                    return comment.comment_collection;
                } else if(comment.comment_collection != null && comment.comment_collection.depth <= depth) {
                    var found_comment_collection = comment.comment_collection.find_by_parent_id(parent_id, depth);
                    if(found_comment_collection != null) {
                        return found_comment_collection;
                    }
                }
            }

            return null;
        }
    }
}