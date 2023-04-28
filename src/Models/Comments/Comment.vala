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

    public class Comment : Object {
        public Comment(string id, int depth) {
            Object(
                id: id, 
                depth: depth
            );
        }

        public string id { get; construct; }
        public int depth { get; construct; }

        public string text { get; set; }
        public string comment_by { get; set; }
        public string comment_by_id { get; set; } 
        public int score { get; set; }
        public DateTime date_created { get; set; }
        public string? parent_id { get; set; }

        public CommentCollection comment_collection { get; set; }
    }

}