
using Subreddits;
using Posts;

namespace Widgets { 

    public class AppBody : Gtk.Paned {
        
        construct {
            orientation = Gtk.Orientation.HORIZONTAL;

            // Add subreddits pane
            var subreddits = new SubredditPane();
            subreddits.width_request = 175;
            add1(subreddits);

            var leftPane = new Gtk.Paned(Gtk.Orientation.HORIZONTAL);
            var postPane = new PostPane();
            postPane.width_request = 100;
            leftPane.add1(postPane);
            leftPane.add2(new PostDetailsPane());

            add2(leftPane);
        }

    }

}