
public class Posts.PostList.ViewPostAction : Object, Action {

    private string _id;

    public ViewPostAction(string id) {
        _id = id;
    }

    public override string name { get {  return "view_post_action"; } }
    public string post_id { get { return _id; } }
}