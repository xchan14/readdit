
namespace Posts { 

    public class PostListItemView : Gtk.Grid {

        public PostListItemView(Post post)
        {
            get_style_context().add_class("post-list-item");

            var title_part =  new Gtk.Label(post.Title);
            title_part.get_style_context().add_class("post-list-item-title");
            title_part.wrap = true;
            attach(title_part, 1, 1);
 
            var score_part = new Gtk.Label(post.Score.to_string());
            attach(score_part, 1, 2);
           
        }

    }
    
}