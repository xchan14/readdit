
namespace ReadIt.Posts.PostDetails {
    public class LoadPostDetailsImageAction : Object, Action {
        public LoadPostDetailsImageAction(string post_id, string image_url) {
            Object(
                post_id: post_id,
                image_url: image_url
            );
        }
        public string post_id { get; construct; }
        public string image_url { get; construct; }
    }
}