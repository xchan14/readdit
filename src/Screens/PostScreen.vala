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
    Dispatcher _dispatcher = Dispatcher.INSTANCE;

    // Headerbar widgets
    PostScreenHeaderBar _header_bar;

    PostListView _post_list_view;
    PostDetailsView _post_details_view;
    Gtk.Widget _empty_details_view;
    Gtk.ScrolledWindow _scrolled_details_view;
    Gtk.Box _details_view_wrapper;

    construct  {
        get_style_context().add_class("post-view");

        this._post_list_view = new PostListView("best", null);
        this._empty_details_view = new EmptyPostDetailsView();

        this._details_view_wrapper = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
        this._scrolled_details_view = new Gtk.ScrolledWindow(null, null) {
            hscrollbar_policy = Gtk.PolicyType.NEVER,
            expand = false
        };
        this._scrolled_details_view.add(this._details_view_wrapper);

        this._details_view_wrapper.pack_start(this._empty_details_view, false, false, 0);
        this._details_view_wrapper.get_style_context().add_class("post-details-wrapper");

        this._post_list_view.set_size_request(350, -1);
        this._scrolled_details_view.set_size_request(600, -1);

        pack1(this._post_list_view, false, false);
        pack2(this._scrolled_details_view, true, false);

        set_position(2);

        this.size_allocate.connect((allocation) => { 
            @foreach(w => w.queue_draw());
        });

        this._post_list_view.selected_post_changed.connect(on_selected_post_changed);
    }

    public PostScreen(MainWindow main_window) {
        this._header_bar = new PostScreenHeaderBar();
        this._header_bar.post_sort_by_changed.connect((sort_by) => {
            stdout.printf("Sort by %s...\n", sort_by);
            this.remove(this._post_list_view);
            this._post_list_view = null;
            this._post_list_view = new PostListView(sort_by, null);
            this._post_list_view.selected_post_changed.connect(on_selected_post_changed);
            pack1(this._post_list_view, false, false);
        });
        main_window.set_titlebar(this._header_bar);
    }

    private void on_selected_post_changed(Post post) {
        this._details_view_wrapper.@foreach(w => this._details_view_wrapper.remove(w));
        this._post_details_view = null;
        this._post_details_view = new PostDetailsView(post);
        this._details_view_wrapper.pack_start(this._post_details_view, false, false, 0);
    }

    private class PostScreenHeaderBar :  Gtk.HeaderBar {

        public signal void post_sort_by_changed(string id);

        Gtk.ComboBoxText post_sort_by;

        construct {
            show_close_button = true;
            has_subtitle = false;
            get_style_context().add_class("app-header-bar");
            set_size_request(-1, 55);

            var custom_header = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 1) {
                hexpand = true
            };
            custom_header.get_style_context().add_class("custom-header");

            var search_text = new Gtk.Entry();
            search_text.get_style_context().add_class("search-text"); 
            search_text.set_alignment(0.5f);
            custom_header.set_center_widget(search_text);

            post_sort_by = new Gtk.ComboBoxText() {
                has_frame = true
            };
            post_sort_by.get_style_context().add_class("post_sort_by");
            post_sort_by.set_size_request(-1, 50);
            post_sort_by.append("best", "Best");
            post_sort_by.append("hot", "Hot");
            post_sort_by.append("top", "Top");
            post_sort_by.append("new", "New");
            post_sort_by.append("rising", "Rising");
            post_sort_by.set_active(0);
            custom_header.pack_start(post_sort_by, false);
            post_sort_by.changed.connect(() => post_sort_by_changed(post_sort_by.active_id));
            post_sort_by.show();

            var mode_switch = new Granite.ModeSwitch.from_icon_name (
                "display-brightness-symbolic",
                "weather-clear-night-symbolic"
            );
            mode_switch.primary_icon_tooltip_text = ("Light background");
            mode_switch.secondary_icon_tooltip_text = ("Dark background");
            mode_switch.valign = Gtk.Align.CENTER;
            var gtk_settings = Gtk.Settings.get_default ();
            mode_switch.bind_property ("active", gtk_settings, "gtk_application_prefer_dark_theme");
            custom_header.pack_end(mode_switch, false, false, 0);

            this.custom_title = custom_header;
        }

        public string post_sort_by_id { 
            get {
                return this.post_sort_by.active_id;
            }
        }
    }

}
