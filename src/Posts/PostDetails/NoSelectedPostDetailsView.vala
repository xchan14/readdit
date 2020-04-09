
namespace Posts.PostDetails {

    public class EmptyPostDetailsView : Gtk.Box {

        construct {
            orientation = Gtk.Orientation.VERTICAL;
            pack_start(new Gtk.Label("No selected post"));

            show_all();
        }
    }

}