using ReadIt.Utils;
using ReadIt.Backend.DataStores;

namespace ReadIt.Posts.PostList.PostListItem { 

    public class PostListItemView : Gtk.Grid {
        Dispatcher _dispatcher = Dispatcher.INSTANCE;
        PostStore _post_store = PostStore.INSTANCE;

        Gtk.Label _title;
        Gtk.Label _score;
        Gtk.Label _posted_by;
        Gtk.Label _subreddit;
        Gtk.Label _date_posted;
        
        Gtk.Box _preview_wrapper;
        Gtk.Image _preview;

        public signal void title_pressed(string post_id);

        public PostListItemView(Post post)
        {
            this._post_store.post_preview_loaded.connect(on_post_preview_loaded);

            this.model = post;
            var style = get_style_context();
            style.add_class("post-list-item");
            this.hexpand = true;
            this.column_homogeneous = true;
            this.row_spacing = 1;

            this._title =  new Gtk.Label(null);
            this._title.label = post.title;
            this._title.get_style_context().add_class("h2");
            this._title.xalign = 0.0f;
            this._title.wrap = true;
            this._title.lines = 3;
            this._title.single_line_mode = false;
            this._title.ellipsize = Pango.EllipsizeMode.END;

            this._preview = new Gtk.Image();
            this._preview.get_style_context().add_class("post-preview");
            this._preview_wrapper = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
            this._preview_wrapper.get_style_context().add_class("post-preview-wrapper");
            this._preview_wrapper.pack_start(this._preview);

            this._score = new Gtk.Label(null);
            this._score.label = post.score.to_string();
            this._score.get_style_context().add_class("score");
            this._score.valign = Gtk.Align.END;

            this._subreddit = new Gtk.Label(null);
            this._subreddit.label = post.subreddit;
            this._subreddit.get_style_context().add_class("subreddit");

            this._posted_by = new Gtk.Label(null);
            this._posted_by.label = post.posted_by;
            this._posted_by.get_style_context().add_class("posted-by");

            this._date_posted = new Gtk.Label(null);
            this._date_posted.get_style_context().add_class("date-posted");
            this._date_posted.xalign = 0.0f;
            string date_format = "%B %e, %Y";
            /*  bool is_same_day = new DateTime.now_local().format(date_format) == model.date_created.to_local().format(date_format);
            if(is_same_day) {
                date_format = date_format + "%i %P";
            }  */
            this._date_posted.label = model.date_created.to_local().format(date_format);

            this._title.button_press_event.connect(() => 
            {
                title_pressed(this._model.id);
                return false;
            });

            set_row_baseline_position(2, Gtk.BaselinePosition.TOP);

            if(this.model.preview_url != null) {
                _dispatcher.dispatch(new LoadPostPreviewAction(this.model.id, this.model.preview_url));
            }

            reattach_children();
        }

        public Post model { get; set; } 
        
        private void reattach_children() {
            forall((widget) => {
                widget.destroy();
            });

            var header = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
            header.baseline_position = Gtk.BaselinePosition.BOTTOM;
            header.pack_start(_score, false, false, 0);
            header.pack_start(new Gtk.Label(" "), false, false, 0);
            header.pack_start(_posted_by, false, false, 0);
            header.pack_start(new Gtk.Label(" in "), false, false, 0);
            header.pack_start(_subreddit, false, false, 0);
            header.forall((widget) => {
                ((Gtk.Label)widget).valign = Gtk.Align.END;
            });
            var footer = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
            footer.pack_start(this._date_posted);

            attach(header, 1, 1, 3, 1);
            if(this.model.preview_url != null) {
                attach(this._title, 1, 2, 2, 1);
                attach(this._preview, 3, 2, 1, 1);
            } else {
                attach(this._title, 1, 2, 3, 1);
            }
            attach(footer, 1, 3, 2, 1);

            show_all();
        }

        private void on_post_preview_loaded(string id, string? path) {
            if(id != this.model.id)
                return;

            if(path == null) 
                return;

            try {
                var preview_pixbuf = new Gdk.Pixbuf.from_file(path);
                int height = preview_pixbuf.get_height();
                int width = preview_pixbuf.get_width();

                int new_height = 0;
                int new_width = 0;
                if(height > width) {
                    new_height = 100;
                    double height_multiplier = new_height < height 
                            ? (double) new_height / (double) height  // minimize
                            : (double) height / (double) new_height; // enlarge
                    new_width = (int) ((double)width * height_multiplier);
                } else {
                    new_width = 100;
                    double width_multiplier = new_width < width
                        ? (double) new_width / (double) width // minimize
                        : (double) width / (double) new_width; // enlarge
                    new_height = (int) ((double)height * width_multiplier);
                }
                preview_pixbuf = preview_pixbuf.scale_simple(new_width, new_height, Gdk.InterpType.BILINEAR);
                this._preview = new Gtk.Image.from_pixbuf(preview_pixbuf);

                reattach_children();
            } catch(Error e) {
                stderr.printf(e.message);
            }
        }
    }
    
}