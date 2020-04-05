
namespace Posts { 
    public class PostListView : Gtk.ScrolledWindow {

        construct 
        {
            get_style_context().add_class("post-list");
            set_size_request(350, 1);
            set_propagate_natural_width(true);
 
            var listbox = new Gtk.ListBox();
            listbox.get_style_context().add_class("post-list-listbox");

            for(int i = 1; i <= 15; i++) {
                var post = new Post();
                post.Title = "Some very long title alkjdfjalk adfa fjlkadfd lkjjadfsf jklj fjlkjkl adf adfjkl jlk jlk";
                post.Score = 1234;
                post.PostedBy = "user" + i.to_string();
                post.Subreddit = "Subreddit" + i.to_string();
                post.DateCreated = new DateTime.now_local();
                var post_list_item = new PostListItemView(post);
                int row = i - 1;
                listbox.insert(post_list_item, row);
            }

            add(listbox);
        }

    } 
}