
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
