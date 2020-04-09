
namespace Posts.PostList.PostListItem { 

    public class PostListItemView : Gtk.Grid {

        Gtk.Label _title;
        Gtk.Label _score;
        Gtk.Label _posted_by;
        Gtk.Label _subreddit;
        Gtk.Label _date_posted;

        private PostListItemViewModel _model;

        public signal void title_pressed(string post_id);

        public PostListItemView(PostListItemViewModel model)
        {
            var style = get_style_context();
            style.add_class("post-list-item");

            _title =  new Gtk.Label(null);
            _title.get_style_context().add_class("post-title");
            _title.selectable = true;
            _title.xalign = 0.0f;
            _title.wrap = true;
 
            _score = new Gtk.Label(null);
            _score.get_style_context().add_class("score");

            _subreddit = new Gtk.Label(null);
            _subreddit.get_style_context().add_class("subreddit");

            _posted_by = new Gtk.Label(null);
            _posted_by.get_style_context().add_class("posted-by");

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
           
            show_all();

            update_values(model);
            this._title.button_press_event.connect(() => {
                title_pressed(this._model.id);
                return false;
            });
        }

        public PostListItemViewModel model { get { return _model; } } 

        private void update_values(PostListItemViewModel model) {
            this._model = model;
            _title.label = model.title;
            _score.label = model.score.to_string();
            _subreddit.label = model.subreddit;
            _posted_by.label = model.posted_by;

            string date_format = "%B %e, %Y";
            /*  bool is_same_day = new DateTime.now_local().format(date_format) == model.date_created.to_local().format(date_format);
            if(is_same_day) {
                date_format = date_format + "%i %P";
            }  */
            _date_posted.label = model.date_created.to_local().format(date_format);

        }

    }
    
}