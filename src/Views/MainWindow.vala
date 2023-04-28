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
using Readdit.Views.Layout;
using Readdit.Views.PostDetails;
using Readdit.Views.PostList;
using Readdit.Models.Posts;

public class Readdit.MainWindow : Hdy.ApplicationWindow {

    private MainContent _mainContent;

    public MainWindow(Readdit.Application readdit){
        Object(
            application: readdit
        );
    }

    static construct {
        Hdy.init();
    }

    construct {
        title = "ReaddIt";
        window_position = WindowPosition.CENTER;
        set_window_size();
        apply_css();

        var postListView = new PostListView();
        var sidebar = new Sidebar(postListView);

        _mainContent = new MainContent();

        // Create a header group that automatically assigns the right decoration controls to the
        // right headerbar automatically
        var header_group = new Hdy.HeaderGroup ();
        header_group.add_header_bar (sidebar.GetHeader());
        header_group.add_header_bar (_mainContent.get_header());

        var paned = new Gtk.Paned (Orientation.HORIZONTAL);
        paned.pack1 (sidebar, false, false);
        paned.pack2 (_mainContent, true, false);

        add(paned);

        show_all();

        postListView.selected_post_changed.connect(on_selected_post_changed);
    }

    private void set_window_size()
    {
        set_default_size(1300, 800);
    }


    private void on_selected_post_changed(Post post) {
        //this._details_view_wrapper.@foreach(w => this._details_view_wrapper.remove(w));
        stdout.printf("Changing post...\n");
        _mainContent.change_content(new PostDetailsView(post));
        stdout.printf("Post changed...\n");
    }

    private void apply_css() 
    {
        CssProvider css_provider = new CssProvider();
        css_provider.load_from_resource("io/github/xchan14/readdit/application.css");
        StyleContext.add_provider_for_screen(
            Gdk.Screen.get_default(), 
            css_provider, 
            Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);
    }
}