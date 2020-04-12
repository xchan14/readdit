using ReadIt.Comments;
using ReadIt.Posts.PostDetails;
using ReadIt.Backend.DataStores;

namespace ReadIt.Posts.PostDetails { 
    
    public class PostDetailsView : Gtk.Box {
        PostStore _post_store = PostStore.INSTANCE;
        Dispatcher _dispatcher = Dispatcher.INSTANCE;

        Gtk.Label _title_widget;
        Gtk.Box _media_wrapper;
        Gtk.Label _text_widget;

        Gtk.Image _image;

        bool _image_loaded = false;

        public PostDetailsView() {
            orientation = Gtk.Orientation.VERTICAL;
            baseline_position = Gtk.BaselinePosition.TOP;
            spacing = 0;
            get_style_context().add_class("post-details");

            this._title_widget = new Gtk.Label("Loading...");
            this._title_widget.get_style_context().add_class("h1");
            this._title_widget.xalign = 0.0f;
            this._title_widget.wrap = true;
            this._title_widget.selectable = true;

            this._media_wrapper = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
            this._media_wrapper.get_style_context().add_class("media");
            this._media_wrapper.halign = Gtk.Align.CENTER;

            this._text_widget = new Gtk.Label("Loading...");
            this._text_widget.xalign = 0.0f;
            this._text_widget.wrap = true;
            this._text_widget.selectable = true;


            if(this.model.image_url != null) {
                this._dispatcher.dispatch(new LoadPostDetailsImageAction(this.model.id, this.model.image_url));
            }

            pack_start(this._media_wrapper, false, false, 0);
            pack_start(this._title_widget, false, false, 0);
            pack_start(this._text_widget, false, false, 0);

            show_all();

            this.map.connect(on_map);
            this._post_store.emit_change.connect(on_post_store_emit_change);
        }

        private Post model { get; set; }

        private void on_map() {
              
        }

        // Handles chanes in Post Store.
        private void on_post_store_emit_change() {
            if(this._post_store.current_viewed_post == null)
                return;

            if(this.model != this._post_store.current_viewed_post) {
                this.model = this._post_store.current_viewed_post;
                this._image_loaded = false;
                update_viewed_post(); 
            } 
        }

        public void update_viewed_post() {
            this._title_widget.label = this.model.title;
            this._text_widget.label = this.model.body_text;

            if(this.model.image_path != null) {
                load_image();
            } else if(this.model.image_url != null) {
                this._dispatcher.dispatch(new LoadPostDetailsImageAction(this.model.id, this.model.image_url));
            } else {
                this._media_wrapper.foreach(w => w.destroy());
            }
        }
           
        private void load_image() {
            stdout.printf("image path: %s\n", this.model.image_path); 
            Gdk.Pixbuf pixbuf = new Gdk.Pixbuf.from_file(this.model.image_path); 
            this._image = new Gtk.Image.from_pixbuf(pixbuf);
            this._image.get_style_context().add_class("post-image");
            this._media_wrapper.foreach((w) => w.destroy());
            this._media_wrapper.pack_start(this._image, false, false, 0);
            this._image.show();
            this._image_loaded = true;
        }


    }

}