
namespace ReadIt.Posts.PostDetails.Comments {
    public class CommentCollectionView : Gtk.Box {

        public CommentCollectionView() {
            orientation = Gtk.Orientation.VERTICAL;
            expand = false;
        }

        public void update_model(CommentCollection comment_collection) {
            @foreach(child => remove(child));

            foreach(Comment comment in comment_collection) {
                pack_start(new CommentItemView(comment));
            }

            if(comment_collection.more_comment_ids != null) {
                int count = comment_collection.more_comment_ids.size;
                var more_comments_label = new Gtk.Label(null) {
                    label = "Load more comments ".concat(count.to_string(), " more..."),
                    xalign = 0.0f
                };
                more_comments_label.get_style_context().add_class("comments-more");
                pack_start(more_comments_label, false, false, 0);
            }

            show_all();
        }

    }
}