
namespace Subreddits { 
        
    public class SubredditPane : Gtk.ListBox {

        construct {
            insert(new Gtk.Label("Subreddit 1"), 0);
            insert(new Gtk.Label("Subreddit 2"), 1);
        }

    }
}