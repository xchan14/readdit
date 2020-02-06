using Comments;

namespace Posts { 
    
    public class PostDetailsView : Gtk.Box {

        construct {
            get_style_context().add_class("post-details");
            orientation = Gtk.Orientation.VERTICAL;

            var media = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
            media.get_style_context().add_class("media");
            pack_start(media);

            var description = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
            description.pack_start(new Gtk.Label("adfasfasfasfa"));
            pack_start(description);

            var comments = new CommentList();
            pack_start(comments);
        }
        
    }

}