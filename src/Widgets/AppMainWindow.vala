
using Gtk;

namespace Widgets { 
    
    public class AppMainWindow : Gtk.ApplicationWindow {

        public AppMainWindow(Gtk.Application app){
            Object(
                application: app
            );
        }

        construct {
            title = "Readit";
            window_position = WindowPosition.CENTER;
            set_default_size(800, 450);

            set_titlebar(new AppHeaderBar());
            add(new AppBody());

            show_all();
        }

    }
}