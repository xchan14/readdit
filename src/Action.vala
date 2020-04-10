
public interface Action : Object {

    public DateTime created_at  { owned get { return new DateTime.now_local(); } }

}