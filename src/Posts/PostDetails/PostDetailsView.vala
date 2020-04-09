using Comments;
using Posts.PostDetails;
using Backend.DataStores;

namespace Posts.PostDetails { 
    
    public class PostDetailsView : Gtk.Box {

        Gtk.Label _title_widget;
        Gtk.Box _media_widget;
        Gtk.Label _text_widget;

        public PostDetailsView() {
            orientation = Gtk.Orientation.VERTICAL;
            baseline_position = Gtk.BaselinePosition.TOP;
            spacing = 0;
            get_style_context().add_class("post-details");

            this._title_widget = new Gtk.Label(null);
            this._title_widget.get_style_context().add_class("h1");
            this._title_widget.xalign = 0.0f;
            this._title_widget.wrap = true;
            this._title_widget.selectable = true;

            this._media_widget = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
            this._media_widget.get_style_context().add_class("media");

            this._text_widget = new Gtk.Label(null);
            this._text_widget.xalign = 0.0f;
            this._text_widget.wrap = true;
            this._text_widget.use_markup = true;
            this._text_widget.selectable = true;

            var comments = new CommentList();

            pack_start(this._title_widget, false, false, 0);
            pack_start(this._media_widget, false, false, 0);
            pack_start(this._text_widget, false, false, 0);
            pack_start(comments, false, false, 0);

            show_all();
        }

        public void update(Post post) { 
            this._title_widget.label = post.title;
            this._text_widget.label = post.body_text;
        }
    }

}