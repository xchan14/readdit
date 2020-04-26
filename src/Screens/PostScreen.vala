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

using ReaddIt.DataStores;
using ReaddIt.Posts;
using ReaddIt.Posts.PostList;
using ReaddIt.Posts.PostDetails;

public class ReaddIt.Screens.PostScreen : Gtk.Paned {
    PostStore _post_store = PostStore.INSTANCE;

    PostListView _post_list_view;
    PostDetailsView _post_details_view;
    Gtk.Widget _empty_details_view;
    Gtk.ScrolledWindow _details_view_wrapper;

    construct  {
        get_style_context().add_class("post-view");

        this._post_list_view = new PostListView();
        this._post_details_view = new PostDetailsView();
        this._empty_details_view = new EmptyPostDetailsView();

        this._details_view_wrapper = new Gtk.ScrolledWindow(null, null);
        this._details_view_wrapper.hscrollbar_policy = Gtk.PolicyType.AUTOMATIC;
        this._details_view_wrapper.expand = false;
        this._details_view_wrapper.add(this._empty_details_view);

        pack1(this._post_list_view, true, false);
        pack2(this._details_view_wrapper, true, false);
        set_position(2);

        this._post_store.emit_change.connect(on_post_store_emit_change);
    }

    private void on_post_store_emit_change() {
        var viewport = this._details_view_wrapper.get_child() as Gtk.Viewport;

        if(this._post_store.current_viewed_post != null) {
            var post_details = viewport.get_child() as PostDetailsView;
            if(post_details == null) {
                this._details_view_wrapper.remove(this._empty_details_view);
                this._details_view_wrapper.add(this._post_details_view);
            } 
        } else {
            var post_details = viewport.get_child() as PostDetailsView;
            if(post_details != null) {
                this._details_view_wrapper.remove(this._post_details_view);
                this._details_view_wrapper.add(this._empty_details_view);
            }
        }

        /* 
        this._details_view_wrapper.foreach(w => {
            if(this._post_store.current_viewed_post != null 
                && (w != this._post_details_view)
            ) {
                this._details_view_wrapper.remove(w);
                this._details_view_wrapper.add(this._post_details_view);
            } else if (this._post_store.current_viewed_post == null 
                && (w != this._empty_details_view)
            ) {
                this._details_view_wrapper.remove(w);
                this._details_view_wrapper.add(this._empty_details_view);
            }       
        });
        */
    }

}