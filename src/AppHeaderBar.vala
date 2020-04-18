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
*//

using Gtk;


public class ReadIt.AppHeaderBar : HeaderBar {

    construct {
        show_close_button = true;
        get_style_context().add_class("app-header-bar");

        var custom_header = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 1);
        custom_header.get_style_context().add_class("custom-header");

        var search_text = new Gtk.Entry();
        search_text.get_style_context().add_class("search-text"); 
        search_text.set_size_request(300, 1);
        search_text.set_alignment(0.5f);
        custom_header.pack_start(search_text);

        this.custom_title = custom_header;
    }

}
