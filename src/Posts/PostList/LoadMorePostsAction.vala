
public class Posts.PostList.LoadMorePostsAction : Object, Action {

    public LoadMorePostsAction(string? subreddit) {
        this.subreddit = subreddit;
    }

    public override string name { get {  return "load_more_posts_action"; } }
    public string? subreddit { get; private set; }
}