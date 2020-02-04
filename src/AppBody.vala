
using Posts;

namespace Widgets { 

    public class AppBody : Gtk.Grid {
        
        construct {
            get_style_context().add_class("app-body");

            var post_list = new PostListView();
            this.attach(post_list, 1, 1);

            var post_details = new PostDetailsView();
            this.attach(post_details, 2, 1);

        }

    }

}