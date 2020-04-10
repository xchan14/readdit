
namespace ReadIt.Comments { 
    
    public class CommentList : Gtk.ListBox {
        construct{
            insert(new CommentItem("Comment 1"), 0);
            insert(new CommentItem("Comment 2"), 1);
            insert(new CommentItem("Comment 3"), 2);
            insert(new CommentItem("Comment 4"), 3);
            insert(new CommentItem("Comment 5"), 4);
            insert(new CommentItem("Comment 6"), 5);
            insert(new CommentItem("Comment 7"), 6);
        }
    }
}