using Gtk;
using Gdk;
using Backend.DataStores;
using Posts;
using Users;
using Gee;
using Posts.PostList;
using Posts.PostDetails;
using Screens;
    
public class ReadIt.AppMainWindow : Gtk.ApplicationWindow {

    Dispatcher _dispatcher = Dispatcher.INSTANCE;

    UserStore _user_store = new UserStore();

    public AppMainWindow(ReadIt.Main readit){
        Object(
            application: readit
        );
    }

    construct {
        title = "ReadIt";
        window_position = WindowPosition.CENTER;
        set_window_size();
        apply_css();

        var header_bar = new AppHeaderBar();
        set_titlebar(header_bar);

        
        add(new PostScreen());        

        // Bind event handlers.
        show.connect(on_window_showed);
        show_all();
    }

    private void set_window_size()
    {
        set_default_size(1360, 700);
    }

    private void on_window_showed() {
        var loop = new MainLoop();
        Timeout.add(1000, () => {
            stdout.printf("Dispatching action LoadPostsAction.\n");
            _dispatcher.dispatch(new LoadMorePostsAction("best"));
            loop.quit();
            return false;
        });

        loop.quit();
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
