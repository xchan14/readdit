
public class ReadIt.Posts.PostList.LoadMorePostsAction : Object, Action {
    public LoadMorePostsAction(string? subreddit) {
        Object(subreddit: subreddit);
    }
    public string? subreddit { get; construct; }
}