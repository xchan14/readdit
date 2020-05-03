using Granite.Widgets;
using ReaddIt;
using ReaddIt.DataStores;

namespace ReaddIt.Posts.PostDetails {


    public class PostDetailsContentView : Gtk.Grid {
        Dispatcher _dispatcher = Dispatcher.INSTANCE;
        PostStore _post_store = PostStore.INSTANCE;

        Gtk.Grid _details_header;
        Gtk.Label _post_title;

        Gtk.Box _details_content;
        Gtk.Box _media_wrapper;
        Gtk.Image _image;
        Gdk.Pixbuf _image_pixbuf;
        VideoPlayer _video_player;
        Gtk.Label _body_text;

        ~PostDetailsContentView() {
            this._details_header = null;
            this._post_title = null;

            this._details_content = null;
            this._image_pixbuf = null;
            this._image = null;
            this._video_player = null;
            this._body_text = null;
        }

        public PostDetailsContentView(Post post) {
            Object(model: post);
            init_gui();
            bind_events();
        }

        public Post model { get; construct; }

        private void init_gui() {
            var style = get_style_context();
            style.add_class("card"); 
            style.add_class("post-details-content");

            /*
             * Header Details contains title, post, user, score, subreddit.
             */
            this._details_header = new Gtk.Grid();
            this._details_header.get_style_context().add_class("post-details-content-header");
            this._details_header.row_homogeneous = true;
            this._post_title = new Gtk.Label(null) {
                label = this.model.title,
                wrap = true,
                xalign = 0.0f
            };
            this._post_title.get_style_context().add_class("h4");
            this._details_header.attach(this._post_title, 1, 1);

            /*
             * Content Details includes image, viedeos, or text content.
             */
            this._details_content = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
            if(this.model.image_url != null || this.model.media_url != null) {
                this._media_wrapper = new Gtk.Box(Gtk.Orientation.VERTICAL, 0){
                    hexpand = true
                };
                this._media_wrapper.get_style_context().add_class("post-details-content-media");
                this._details_content.pack_start(
                    this._media_wrapper,
                    false, 
                    false,
                    0
                );
            }

            if (this.model.image_url != null) {
                this._dispatcher.dispatch(new LoadPostDetailsImageAction(this.model.id, this.model.image_url));
            } 

            if(this.model.media_url != null) {
                stdout.printf("Video link: %s\n", this.model.media_url);
                load_video_player();
            }

            if(this.model.body_text != null && this.model.body_text.length > 0) {
                this._body_text = new Gtk.Label(null) {
                    label = this.model.body_text,
                    xalign = 0.0f,
                    selectable = true,
                    wrap = true,
                    use_markup = true
                };
                this._body_text.get_style_context().add_class("post-details-content-body-text");
                this._body_text.get_style_context().add_class("h3");
                this._details_content.pack_start(
                    this._body_text,
                    false, 
                    false,
                    0
                );


            }

            attach(this._details_header, 1, 1);
            attach(this._details_content, 1, 2);

        }

        private void bind_events() {
            this._post_store.emit_change.connect(on_post_store_emit_change); 
        }

        private void on_post_store_emit_change() {
            if(this._image == null && this.model.image_path != null) {
                load_image();
            } 
        }

        private void load_image() {
            if(this._image_pixbuf == null) {
                try {
                    this._image_pixbuf = new Gdk.Pixbuf.from_file(this.model.image_path); 
                } catch(Error e) {
                    stderr.printf("File error: %s\n", e.message);
                }
            } 
            if(this._image_pixbuf == null) {
                stderr.printf("Error loading image file...\n");
                return;
            }
            int height = this._image_pixbuf.get_height();
            int width = this._image_pixbuf.get_width();
            int new_height = 500;
            int new_width = 0;
            double height_multiplier = (double) new_height / (double) height; 
            new_width = (int) ((double)width * height_multiplier);
            this._image_pixbuf = this._image_pixbuf.scale_simple(new_width, new_height, Gdk.InterpType.BILINEAR);
            this._image = new Gtk.Image.from_pixbuf(this._image_pixbuf);
            var image_box_wrapper = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
            this._media_wrapper.set_center_widget(image_box_wrapper);
            image_box_wrapper.set_center_widget(this._image);
            image_box_wrapper.show_all();
        }

        private void load_video_player() {
            try {
                this._video_player = null;
                this._video_player = new VideoPlayer() {
                    width_request = 720,
                    height_request = 480
                };
                this._video_player.video_uri = this.model.media_url;
                this._media_wrapper.set_center_widget(this._video_player);

                /* 
                this._video_web = new WebKit.WebView();
                this._video_web.set_size_request(720, 480);
                this._video_web.load_uri(this.model.media_url);
                this._media_wrapper.set_center_widget(this._video_web);
                */

            } catch(Error e) {
                stderr.printf("Error setting up this._video_player: %s\n", e.message);
            }
        }

    }

}
