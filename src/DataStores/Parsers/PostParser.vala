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
using ReaddIt.Posts;

namespace ReaddIt.DataStores.Parsers {

    public class PostParser {

        public Collection<Post> parse_from_data(string data) {
            var list = new ArrayList<Post>();
            var parser = new Json.Parser();
            parser.load_from_data(data, -1);
            Json.Object root_object = parser.get_root ().get_object ();
            Json.Array post_items = root_object
                .get_object_member("data")
                .get_array_member("children"); 

            GLib.List<weak Json.Node> items = post_items.get_elements();
            foreach(Json.Node post_node in items) {
                Post post = map_post_from_json(post_node);
                list.add(post);
            }
            return list;
        }


        private Post map_post_from_json(Json.Node post_node) {
            var post_data = post_node.get_object().get_object_member("data");
            string id = post_data.get_string_member("name");
            var post = new Post(id) {
                title = post_data.get_string_member("title"),
                body_text = post_data.get_string_member("selftext"),
                score = (int) post_data.get_int_member("score"),
                subreddit = post_data.get_string_member("subreddit_name_prefixed"),
                posted_by = post_data.get_string_member("author"),
                posted_by_id = post_data.get_string_member("author_fullname"),
                date_created = new DateTime.from_unix_local((long)post_data.get_double_member("created")),
                is_video = post_data.get_boolean_member("is_video")
            }; 

            Json.Object preview_object = post_data.get_object_member("preview");
            if(preview_object != null) {
                Json.Array image_array_object = preview_object.get_array_member("images"); 
                if(image_array_object != null) {
                    Json.Object image_object = image_array_object
                        .get_element(0)
                        .get_object();

                    if(!post.is_video) {
                        post.image_url = image_object.get_object_member("source")
                            .get_string_member("url")
                            .replace("&amp;" ,"&");
                    }

                    Json.Object resolutions_object = image_object
                        .get_array_member("resolutions")
                        .get_element(1).get_object();
                    post.preview_url = resolutions_object
                        .get_string_member("url")
                        .replace("&amp;" ,"&");
                }
            }

            if(post.is_video) {
                post.media_url = post_data.get_object_member("media")
                    .get_object_member("reddit_video")
                    .get_string_member("hls_url");
            }


            post.date_loaded = new DateTime.now_utc();
            return post;
        }       

    }

}
