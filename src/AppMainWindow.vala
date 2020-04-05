using Gtk;
using Gdk;

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
            set_window_size();
            apply_css();

            var header_bar = new AppHeaderBar();
            //header_bar.get_style_context().add_class(Gtk.STYLE_CLASS_FLAT);
            set_titlebar(header_bar);

            add(new AppBody());

            show_all();
        }

        private void set_window_size()
        {
            set_default_size(1360, 700);
        }

        private void apply_css() 
        {
            CssProvider css_provider = new CssProvider();
            css_provider.load_from_resource("com/github/xchan14/readit/application.css");
            Gtk.StyleContext.add_provider_for_screen(
                Gdk.Screen.get_default(), 
                css_provider, 
                Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);
        }
    }
}