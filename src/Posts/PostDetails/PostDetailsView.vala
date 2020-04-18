
using Gee;
using ReadIt.Posts.PostDetails.Comments;
using ReadIt.Posts.PostDetails;
using ReadIt.DataStores;

namespace ReadIt.Posts.PostDetails { 
    
    public class PostDetailsView : Gtk.Box {
        PostStore _post_store = PostStore.INSTANCE;
        Dispatcher _dispatcher = Dispatcher.INSTANCE;

        Gtk.Label _title_widget;
        Gtk.Box _media_wrapper;
        Gtk.Label _text_widget;
        Gtk.Image _image;
        CommentCollectionView _comments_view;

        bool _image_loaded = false;

        public PostDetailsView() {
            orientation = Gtk.Orientation.VERTICAL;
            baseline_position = Gtk.BaselinePosition.TOP;
            spacing = 0;
            expand = false;
            get_style_context().add_class("post-details");

            this._title_widget = new Gtk.Label("Loading...") {
                xalign = 0.0f,
                wrap = true,
                selectable = true,
                use_markup = true
            };
            this._title_widget.get_style_context().add_class("h1");
            this._title_widget.get_style_context().add_class("post-details-title");

            this._media_wrapper = new Gtk.Box(Gtk.Orientation.VERTICAL, 0) {
                halign = Gtk.Align.CENTER
            };
            this._media_wrapper.get_style_context().add_class("media");

            this._text_widget = new Gtk.Label("Loading...") {
                xalign = 0.0f,
                wrap = true,
                selectable = true
            };
            this._text_widget.get_style_context().add_class("post-text");
            this._comments_view = new CommentCollectionView();

            map.connect(on_map);
            this._post_store.emit_change.connect(on_post_store_emit_change);
        }

        private Post model { get; set; }

        private void on_map() {
            if(this.model.image_url != null) {
                this._dispatcher.dispatch(new LoadPostDetailsImageAction(this.model.id, this.model.image_url));
            } 

        }

        // Handles changes in Post Store.
        private void on_post_store_emit_change() {
            if(this._post_store.current_viewed_post == null)
                return;

            if(this.model != this._post_store.current_viewed_post) {
                this.model = this._post_store.current_viewed_post;
                this._image_loaded = false;
                update_viewed_post(); 
                this._dispatcher.dispatch(new LoadPostCommentsAction(this.model.id, null));
            } 

            if(!this._image_loaded) {
                this._media_wrapper.foreach(w => w.destroy());
                if(this.model.image_path != null) {
                    load_image();
                } else if(this.model.image_url != null) {
                    this._dispatcher.dispatch(new LoadPostDetailsImageAction(this.model.id, this.model.image_url));
                } 
            }

            if(this.model.comment_collection != null) {
                this._comments_view.update_model(this.model.comment_collection);
            }
        }

        public void update_viewed_post() {
            @foreach(w => remove(w));

            this._title_widget.label = this.model.title;
            this._text_widget.label = this.model.body_text;
            pack_start(this._title_widget, false, false, 0);
            if(this.model.image_url != null || this.model.media_url != null) {
                pack_start(this._media_wrapper, false, false, 0);
                this._media_wrapper.show_all();
            }
            if(this.model.body_text != null && this.model.body_text.length > 0) {
                stdout.printf("text: %s\n", this.model.body_text);
                pack_start(this._text_widget, false, false, 0);
            }

            this._comments_view.unparent();
            this._comments_view.@foreach(w => this._comments_view.remove(w));
            pack_start(this._comments_view, false, false, 0);


            show_all();
        }
           
        private void load_image() {
            Gdk.Pixbuf pixbuf = new Gdk.Pixbuf.from_file(this.model.image_path); 
            this._image.unparent();
            this._image = new Gtk.Image.from_pixbuf(pixbuf);
            this._image.get_style_context().add_class("post-image");
            this._media_wrapper.foreach((w) => w.destroy());
            this._media_wrapper.pack_start(this._image, false, false, 0);
            this._image.show();
            this._image_loaded = true;
        }


    }

}