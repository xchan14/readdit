using Comments;
using Posts.PostDetails;
using Backend.DataStores;

namespace Posts.PostDetails { 
    
    public class PostDetailsView : Gtk.Box {

        Gtk.Box _wrapper;
        Gtk.Label _title_widget;
        Gtk.Box _media_widget;
        Gtk.Label _text_widget;

        public PostDetailsView() {
            orientation = Gtk.Orientation.VERTICAL;
            get_style_context().add_class("post-details");

            this._title_widget = new Gtk.Label(null);

            this._media_widget = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
            this._media_widget.get_style_context().add_class("media");

            this._text_widget = new Gtk.Label(null);
            this._text_widget.use_markup = true;

            var comments = new CommentList();

            pack_start(this._title_widget);
            pack_start(this._media_widget);
            pack_start(this._text_widget);
            pack_start(comments);

            show_all();
        }

        public void update(Post post) { 
            this._title_widget.label = post.title;
            this._text_widget.label = post.body_text;
        }
    }

}