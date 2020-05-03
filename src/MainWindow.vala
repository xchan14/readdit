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
using Gdk;
using Gtk;
using ReaddIt.DataStores;
using ReaddIt.Posts;
using ReaddIt.Users;
using ReaddIt.Posts.PostList;
using ReaddIt.Posts.PostDetails;
using ReaddIt.Screens;
    
public class ReaddIt.MainWindow : Gtk.ApplicationWindow {

    // Global action dispatcher.
    Dispatcher _dispatcher = Dispatcher.INSTANCE;

    public MainWindow(ReaddIt.Application readdit){
        Object(
            application: readdit
        );
    }

    construct {
        title = "ReaddIt";
        window_position = WindowPosition.CENTER;
        set_window_size();
        apply_css();

        //var header_bar = new AppHeaderBar();
        //set_titlebar(header_bar);

        add(new PostScreen(this));        

        // Bind event handlers.
        map.connect(on_map);
        show_all();
    }

    private void set_window_size()
    {
        //set_default_size(1300, 700);
    }

    private void on_map() {
        /* 
        var loop = new MainLoop();
        Timeout.add(1000, () => {
            stdout.printf("Dispatching action LoadPostsAction.\n");
            loop.quit();
            return false;
        });

        loop.quit();
        */
    }

    private void apply_css() 
    {
        CssProvider css_provider = new CssProvider();
        css_provider.load_from_resource("com/github/xchan14/readdit/application.css");
        Gtk.StyleContext.add_provider_for_screen(
            Gdk.Screen.get_default(), 
            css_provider, 
            Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);
    }

}
