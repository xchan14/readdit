
namespace Posts { 
    public class PostListView : Gtk.ListBox {

        construct 
        {
            get_style_context().add_class("post-list");
 
            var post = new Post();
            post.Title = "Some very long title alkjdfjalk adfa fjlkadfd lkjjadfsf jklj fjlkjkl adf adfjkl jlk jlk";
            post.Score = 1234;
            var post_list_item = new PostListItemView(post);

            insert(post_list_item, 0);

            var post2 = new Post();
            post2.Title = "Some very long title alkjdfjalk adfa fjlkadfd lkjjadfsf jklj fjlkjkl adf adfjkl jlk jlk";
            post2.Score = 1232344;
            var post_list_item2 = new PostListItemView(post2);

            insert(post_list_item2, 1);

        }

    } 
}