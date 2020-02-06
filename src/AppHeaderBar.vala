

using Gtk;

namespace Widgets { 

    public class AppHeaderBar : HeaderBar {

        construct {
            show_close_button = true;
            get_style_context().add_class("app-header-bar");

            var custom_title_container = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 1);
            custom_title_container.get_style_context().add_class("custom-title");

            var search_text = new Gtk.Entry();
            search_text.get_style_context().add_class("search-text");
            search_text.set_size_request(300, 1);
            search_text.set_alignment(0.5f);
            custom_title_container.pack_start(search_text);

            this.custom_title = custom_title_container;

        }

    }

}