
namespace Posts { 

    public class PostListItemView : Gtk.Grid {

        Gtk.Label _title;
        Gtk.Label _score;
        Gtk.Label _posted_by;
        Gtk.Label _subreddit;
        Gtk.Label _date_posted;

        public PostListItemView(Post post)
        {
            var style = get_style_context();
            style.add_class("post-list-item");

            _title =  new Gtk.Label(null);
            _title.get_style_context().add_class("post-title");
            _title.justify = Gtk.Justification.FILL;
            _title.wrap = true;
 
            _score = new Gtk.Label(null);
            _score.get_style_context().add_class("score");

            _subreddit = new Gtk.Label(null);
            _subreddit.get_style_context().add_class("subreddit");
            _subreddit.xalign = 1.0f;

            _posted_by = new Gtk.Label(null);
            _posted_by.get_style_context().add_class("posted-by");
            _posted_by.xalign = 1.0f;

            _date_posted = new Gtk.Label(null);
            _date_posted.get_style_context().add_class("date-posted");
            _date_posted.xalign = 0.0f;


            var header = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
            header.baseline_position = Gtk.BaselinePosition.BOTTOM;
            header.pack_start(_score, false, false, 0);
            header.pack_start(new Gtk.Label(" "), false, false, 0);
            header.pack_start(_posted_by, false, false, 0);
            header.pack_start(new Gtk.Label(" in "), false, false, 0);
            header.pack_start(_subreddit, false, false, 0);

            attach(header, 1, 1);

            attach(_title, 1, 2, 3, 1);

            attach(_date_posted, 1, 3, 3, 1);
           
            assign_data(post);
        }

        private void assign_data(Post data) {
            _title.label = data.Title;
            _score.label = data.Score.to_string();
            _posted_by.label = data.PostedBy;
            _subreddit.label = data.Subreddit;
            _date_posted.label = data.DateCreated.format("%x");
        }

    }
    
}