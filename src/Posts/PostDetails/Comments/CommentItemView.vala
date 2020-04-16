
namespace ReadIt.Posts.PostDetails.Comments  {

    public class CommentItemView : Gtk.Box  {

        Gtk.Label _comment_by;
        Gtk.Label _text;
        Gtk.Box _comments;

        public CommentItemView(Comment comment, int level) {
            Object(model: comment);
            orientation = Gtk.Orientation.VERTICAL;
            margin_start = level * 20;
            get_style_context().add_class("comment-wrapper");

            this._comment_by = new Gtk.Label(null) {
                label = comment.comment_by,
                xalign = 0.0f,
                wrap = true,
                single_line_mode = false
            };
            
            this._text = new Gtk.Label(null) {
                label = comment.text,
                xalign = 0.0f,
                selectable = true
            };
            this._text.get_style_context().add_class("comment-text");

            this._comments = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
            foreach(Comment item in this.model.comments) {
                int sublevel = level + 1;
                this._comments.pack_start(new CommentItemView(item, sublevel));    
            }
            this._comments.show_all();

            pack_start(this._comment_by, false, false, 0);
            pack_start(this._text, false, false, 0);
            pack_start(this._comments);

            show_all();
        }

        public Comment model { get; construct; }
        public int level { get; construct; }
    }

}