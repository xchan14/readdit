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

using ReadIt.DataStores;

namespace ReadIt.Posts.PostDetails.Comments {
    public class CommentCollectionView : Gtk.Box {
        ReadIt.Dispatcher _dispatcher = ReadIt.Dispatcher.INSTANCE; 
        PostStore _post_store = PostStore.INSTANCE;

        public CommentCollectionView() {
            orientation = Gtk.Orientation.VERTICAL;
            expand = false;
        }

        public void update_model(CommentCollection comment_collection) {
            @foreach(child => remove(child));

            foreach(Comment comment in comment_collection) {
                pack_start(new CommentItemView(comment));
            }

            if(comment_collection.more_comment_ids != null) {
                int count = comment_collection.more_comment_ids.size;
                string label = "<a href=\"\">Load more comments (".concat(count.to_string(), ")...</a>");
                var more_comments_label = new Gtk.Label(null) {
                    label = label,
                    xalign = 0.0f,
                    use_markup = true
                };
                more_comments_label.get_style_context().add_class("comment-more");
                pack_start(more_comments_label, false, false, 0);
            }

            show_all();
        }

        private void on_load_more_click() {
        }

    }
}