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
using Readdit;
using Readdit.DataStores;

public class Readdit.Application : Gtk.Application {

    public Application(){
        Object(
            application_id: "io.github.xchan14.readdit",
            flags: ApplicationFlags.FLAGS_NONE
        );
    }

    public static int main (string[] args){
        var err = GtkClutter.init (ref args);
        if (err != Clutter.InitError.SUCCESS) {
            error ("Could not initalize clutter: %s ", err.to_string ());
        }
        Gst.init (ref args);
        PostStore.init();

        var app = new Application();
        return app.run(args);
    }

    protected override void activate(){
        var main_window = new MainWindow(this);
        add_window (main_window);
        main_window.destroy.connect( s =>  {
            Gst.deinit();
            Gtk.main_quit();
        });
    }
}
