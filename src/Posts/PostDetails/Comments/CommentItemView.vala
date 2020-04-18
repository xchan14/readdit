
namespace ReadIt.Posts.PostDetails.Comments  {

    public class CommentItemView : Gtk.Box  {

        Gtk.Label _comment_by;
        Gtk.Label _score;
        Gtk.Label _text;
        CommentCollectionView _replies;

        Gtk.Box _header;

        public CommentItemView(Comment comment) {
            Object(model: comment);
            orientation = Gtk.Orientation.VERTICAL;
            margin_start = 8;
            expand = false;
            get_style_context().add_class("comment-wrapper");

            this._comment_by = new Gtk.Label(null) {
                label = comment.comment_by,
                xalign = 0.0f
            };
            this._comment_by.get_style_context().add_class("comment-by");
            this._score = new Gtk.Label(null) {
                label = " ".concat(comment.score.to_string()) ,
                xalign = 0.0f
            };
            
            this._text = new Gtk.Label(null) {
                label = comment.text,
                xalign = 0.0f,
                selectable = true,
                wrap = true,
                use_markup = true
            };
            this._text.get_style_context().add_class("comment-text");

            this._replies = new CommentCollectionView();
            this._replies.get_style_context().add_class("comment-children");
            this._replies.update_model(this.model.comment_collection);

            this._header = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
            this._header.pack_start(this._comment_by, false, false, 0);
            this._header.pack_start(this._score, false, false, 0);

            pack_start(this._header, false, false, 0);
            pack_start(this._text, false, false, 0);
            pack_start(this._replies);

            show_all();
        }

        public Comment model { get; construct; }
        public int level { get; construct; }
    }

}