using Comments;

namespace Posts { 
    
    public class PostDetailsPane : Gtk.Box {

        construct {
            orientation = Gtk.Orientation.VERTICAL;

            var media = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
            media.height_request = 200;
            pack_start(media);

            var description = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
            description.pack_start(new Gtk.Label("adfasfasfasfa"));
            pack_start(description);

            var comments = new CommentList();
            pack_start(comments);
        }
        
    }

}