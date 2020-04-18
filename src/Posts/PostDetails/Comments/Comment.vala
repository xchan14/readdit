using Gee;

namespace ReadIt.Posts.PostDetails.Comments {

    public class Comment : Object {
        public Comment() {
            Object(comment_collection: new CommentCollection());
        }

        public string id { get; set; }
        public string text { get; set; }
        public string comment_by { get; set; }
        public string comment_by_id { get; set; } 
        public int score { get; set; }

        public CommentCollection comment_collection { get; set; }
    }

}