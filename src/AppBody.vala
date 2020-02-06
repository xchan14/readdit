
using Posts;

namespace Widgets { 

    public class AppBody : Gtk.Paned {
        
        construct {
            get_style_context().add_class("app-body");

            var post_list = new PostListView();
            this.pack1(post_list, true, false);

            var post_details = new PostDetailsView();

            var pack2_container = new Gtk.ScrolledWindow(null, null);
            pack2_container.set_size_request(500, 1);
            this.pack2(pack2_container, true, false);

            set_position(1);
        }

    }

}