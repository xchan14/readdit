

namespace ReadIt.Posts.PostDetails.Comments  {

    public class LoadPostCommentsAction : Object, Action {
        public LoadPostCommentsAction(string post_id, string? after = null) {
            Object(
                post_id: post_id,
                after: after
            );
        }

        public string post_id { get; construct; }
        public string after { get; construct; }
    }
}