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

using Gtk;
using Readdit.DataStores;
using Readdit.Models.Comments;

namespace Readdit.Views.Comments {

    public class CommentCollectionView : Gtk.Box {
        Readdit.Dispatcher _dispatcher = Readdit.Dispatcher.INSTANCE; 
        PostStore _post_store = PostStore.INSTANCE;

        public signal void load_more_click(string comment_id, string[] children);

        ListBox _list_box;
        Label _more_comments_label;

        public CommentCollectionView(CommentCollection? comment_collection) {

            this.model = comment_collection;
            orientation = Orientation.VERTICAL;
            expand = false;
            resize_mode = ResizeMode.PARENT;

            this._list_box = new ListBox(){
                selection_mode = SelectionMode.NONE
            };
            var list_box_style = this._list_box.get_style_context();
            list_box_style.add_class("comment-list-box");
            if(this.model.depth > 0) {
                list_box_style.add_class("comment-list-box-indent");
            }

            this._more_comments_label = new Label(null) {
                xalign = 0.0f,
                use_markup = true
            };
            this._more_comments_label.get_style_context().add_class("comment-more");

            foreach(Comment comment in this.model) {
                this._list_box.insert(new CommentItemView(comment), -1);
            }

            pack_start(this._list_box);

            show_all();

            map.connect(on_map);
            this._post_store.emit_change.connect(on_post_store_emit_change);
        }

        ~CommentCollectionView() {
            //this._post_store.emit_change.disconnect(on_post_store_emit_change);
            //map.disconnect(on_map);
        }

        public bool is_empty() {
            return this._list_box.get_children().length() == 0;
        }

        public CommentCollection model { get; set; }

        private bool on_load_more_click(Gtk.Widget w, Gdk.EventButton eb) {
            try {
                stdout.printf("Loading more comments from parent %s at depth %d...\n", model.parent_id, model.depth);
                this._dispatcher.dispatch(new LoadMoreCommentsAction(model.parent_id, model.depth));
            } catch(Error e) {
                stderr.printf("Error: %s\n", e.message);
            }
            return true;
        }

        private void on_map() {
            if(this.model.more_comment_ids.size > 0) {
                int more_count = this.model.more_comment_ids.size;
                this._more_comments_label.label = update_more_comments_label_text(more_count);
                this._more_comments_label.button_press_event.connect(on_load_more_click);
                pack_start(this._more_comments_label, false, false, 0);
            }
        }

        private void on_post_store_emit_change() {
            try {
                foreach(Comment comment in model) {
                    CommentItemView comment_item_view = null;
                    foreach(Gtk.Widget child in this._list_box.get_children()) {
                        var list_box_row = child as Gtk.ListBoxRow;
                        var row_comment_item_view = list_box_row.get_child() as CommentItemView;
                        if(row_comment_item_view == null) {
                            stdout.printf("Not a comment item view...\n");
                            continue;
                        }
                        if(row_comment_item_view.model.id == comment.id) {
                            comment_item_view = row_comment_item_view;
                            break;
                        }
                    }

                    if(comment_item_view == null) {
                        comment_item_view = new CommentItemView(comment);
                        this._list_box.insert(comment_item_view, -1);
                        stdout.printf("Added new comment %s...\n", comment.id);
                    }
                } 

                string new_label = update_more_comments_label_text(this.model.more_comment_ids.size);
                if (this.model.more_comment_ids.size <= 0) {
                    remove(this._more_comments_label);
                    this._more_comments_label.button_press_event.disconnect(on_load_more_click);
                } else  if(this._more_comments_label.label != new_label) {
                    this._more_comments_label.label = new_label;
                }
            } catch(Error e) {
                stderr.printf("Error: %s\n", e.message);
            }

        }

        private string update_more_comments_label_text(int count) {
            return "<a href=\"\">Load more comments (".concat(count.to_string(), ")...</a>");
        }

    }
}
