
namespace Posts { 
    public class PostPane : Gtk.ListBox {
        construct {
            insert(new Gtk.Label("Post 1"), 0);
            insert(new Gtk.Label("Post 1"), 1);
        }
    } 
}