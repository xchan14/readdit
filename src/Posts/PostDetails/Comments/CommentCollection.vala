using Gee;

namespace ReadIt.Posts.PostDetails.Comments {
    public class CommentCollection : ArrayList<Comment> {

        public ArrayList<string> more_comment_ids { get; set; }

    }
}