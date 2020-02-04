

using Gtk;

namespace Widgets { 

    public class AppHeaderBar : HeaderBar {

        construct {
            show_close_button = true;

            add(new Gtk.Label("ReadIt"));
        }

    }

}