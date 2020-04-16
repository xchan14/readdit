using Gee; 
using ReadIt.Posts.PostDetails.Comments;

namespace ReadIt.Posts { 

    public class Post : Object {  

        public string id { get; set; }
        public string title { get; set; }
        public int score { get; set; }
        public string posted_by { get; set; }
        public string posted_by_id { get ;set; }
        public string subreddit { get; set; }
        public DateTime date_created { get ;set; }
        public string body_text { get; set; }
        public string? image_url { get; set; }
        public string? image_path { get; set; }
        public string? preview_url { get; set; }
        public string? preview_path { get; set; }
        public bool is_video { get; set; }
        public string media_url { get; set; }

        public DateTime date_loaded { get; set; }

        public Collection<Comment> comments { get; set; }
    }
    
}