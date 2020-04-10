
public class ReadIt.Posts.PostList.LoadPostPreviewAction : Object, Action {
    public LoadPostPreviewAction(string post_id, string url) {
        Object(
            post_id: post_id,
            url: url
        );
    }

    public string post_id { get; construct; }
    public string url { get; construct; }
}