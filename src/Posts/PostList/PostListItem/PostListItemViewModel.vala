
namespace  Posts.PostList.PostListItem {

    public class PostListItemViewModel {  
        public string id { get; set; }
        public string title { get; set; }
        public int score { get; set; }
        public string subreddit { get; set; }
        public DateTime date_created { get ;set; }
        public string posted_by { get; set; }
        public DateTime date_loaded { get; set; }
    }
}
    