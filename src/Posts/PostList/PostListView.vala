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
using ReaddIt.DataStores;
using ReaddIt.Posts.PostList.PostListItem;
using ReaddIt.Users;

namespace ReaddIt.Posts.PostList { 

    public class PostListView : Gtk.ScrolledWindow {
        // Reference to post store.
        private PostStore _post_store = PostStore.INSTANCE;
        // Reference to global dispatcher.
        private ReaddIt.Dispatcher _dispatcher = ReaddIt.Dispatcher.INSTANCE;
        // Listbox widget for the list of posts.
        private Gtk.ListBox _listbox;
        // Data store behind the posts listbox.
        private PostListModel _posts_list_model;
        // Current rendered posts
        private Collection<Post> _posts;

        construct 
        {
            this._posts_list_model = new PostListModel();

            get_style_context().add_class("post-list");
            set_size_request(400, 1);
            set_propagate_natural_width(true);
            hscrollbar_policy = Gtk.PolicyType.NEVER;

            this._listbox = new Gtk.ListBox();
            this._listbox.activate_on_single_click = true;
            this._listbox.selection_mode = Gtk.SelectionMode.BROWSE;
            this._listbox.get_style_context().add_class("post-list-listbox");
            this._listbox.bind_model(this._posts_list_model, create_list_item_widget);
            add(_listbox);

            bind_event_handlers();

            show_all();
        }

        // Bind event handlers.
        private void bind_event_handlers() {
            this._post_store.emit_change.connect(on_post_store_emit_change);
            this.edge_reached.connect(on_edge_reached);
            this._listbox.row_selected.connect(on_listbox_row_selected);
        }

        private void on_edge_reached(Gtk.PositionType pos) {
            if(pos == Gtk.PositionType.BOTTOM) {
                // Infinite scroll implementation.
                if(!this._post_store.is_loading_new_posts) {
                    this._dispatcher.dispatch(new LoadMorePostsAction(null));
                }
            }
        }

        // Handles changes from Post Store.
        private void on_post_store_emit_change() {
            // Update list when new posts are loaded.
            update_list();
        }

        // Creates the widget to be displayed on post listbox widget.
        private Gtk.Widget create_list_item_widget(Object item) {
            var post = (Post) item;
            var view = new PostListItemView(post);
            view.show_all();
            return view;
        }

        private void on_show() {
            this._listbox.bind_model(this._posts_list_model, create_list_item_widget);
        }

        // Handles row selected event of listbox.
        private void on_listbox_row_selected(Gtk.ListBoxRow? row) {
            string id = null;
            if(row != null) {
                Post post = ((Post) this._posts_list_model.get_item(row.get_index()));
                id = post.id;
                stdout.printf("id: %s\n", id);
                _dispatcher.dispatch(new ViewPostAction(id));
            } 
        }

        private void update_list() {
            foreach(var post in this._post_store.loaded_posts) {
                if(!this._posts_list_model.any_match((p) => p == post)) {
                    this._posts_list_model.add(post);
                }
            }  
        }

        /*
         *  Custom implementation of ListModel 
         *  which binds on ListBox object. 
         */
        public class PostListModel : ArrayList<Post>, ListModel {

            public Object? get_item (uint position) {
                if((int) position > base.size)
                    return null;
                return base.get((int)position);
            }

            public Type get_item_type () {
                return typeof(Post);     
            }

            public uint get_n_items () {
                return (uint) base.size;
            }

            public void add(Post post) {
                base.add(post);
                uint pos = get_n_items() - 1;
                items_changed(pos, 0, 1);
            }
             
            public void remove(Post post) {
                var index = index_of(post);
                remove_at(index);
                items_changed(index, 1, 0);
            }
        }
    }
}