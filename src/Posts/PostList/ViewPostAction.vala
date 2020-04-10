
public class ReadIt.Posts.PostList.ViewPostAction : Object, Action {
    public ViewPostAction(string post_id) { 
        Object(post_id: post_id);
    }
    public string post_id { get; construct; }
}