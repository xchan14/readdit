/*
* Copyright (c) 2020 Christian Camilon 
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 2 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*
* Authored by: Christian Camilon <christiancamilon@gmail.com>
*/

using Gee;
using ReaddIt.Posts.PostDetails.Comments;
using ReaddIt.Posts.PostDetails;
using ReaddIt.DataStores;

namespace ReaddIt.Posts.PostDetails { 
    
    public class PostDetailsView : Gtk.Box {
        PostStore _post_store = PostStore.INSTANCE;
        Dispatcher _dispatcher = Dispatcher.INSTANCE;

        Gtk.Label _title_widget;
        Gtk.Box _media_wrapper;
        Gtk.Label _text_widget;
        Gtk.Image _image;
        Gdk.Pixbuf _image_pixbuf;
        CommentCollectionView _comments_view;

        bool _image_loaded = false;
        
        construct {
            set_size_request(400, -1);
        }

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
            var title_style = this._title_widget.get_style_context();
            title_style.add_class("post-details-title");
            title_style.add_class("h1");
            title_style.add_class("card");

            this._media_wrapper = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0) {
                halign = Gtk.Align.CENTER,
                expand = true
            };
            this._media_wrapper.get_style_context().add_class("media");
            this._media_wrapper.get_style_context().add_class("card");

            this._text_widget = new Gtk.Label("Loading...") {
                xalign = 0.0f,
                wrap = true,
                selectable = true
            };
            var text_style = this._text_widget.get_style_context();
            text_style.add_class("post-text");
            text_style.add_class("card");

            this.map.connect(on_map);
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
                this._media_wrapper.foreach(w => w.destroy());
                this.model = this._post_store.current_viewed_post;
                this._image_loaded = false;
                update_viewed_post(); 
                this._dispatcher.dispatch(new LoadPostCommentsAction(this.model.id, null));
            } 

            if(!this._image_loaded) {
                if(this.model.image_path != null) {
                    load_image();
                    this._image_loaded = true;
                } else if(this.model.image_url != null) {
                    this._dispatcher.dispatch(new LoadPostDetailsImageAction(this.model.id, this.model.image_url));
                } 
            }

            if(this._comments_view == null && this.model.comment_collection != null) {
                this._comments_view = new CommentCollectionView(this.model.comment_collection);
                pack_start(this._comments_view, false, false, 0);
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

            this._comments_view = null;

            show_all();
        }
           
        private void load_image() {
            stdout.printf("Reloading image...\n");
            Gtk.Allocation allocation;
            this.get_allocation(out allocation);
            stdout.printf("Post details allocated size %dx%d...\n", allocation.width, allocation.height);

            if(!this._image_loaded) {
                try {
                    this._image_pixbuf = new Gdk.Pixbuf.from_file(this.model.image_path); 
                } catch(Gdk.PixbufError e) {
                    stderr.printf("File error: %s\n", e.message);
                }
            
            } else {
                this._media_wrapper.@foreach(w => this._media_wrapper.remove(w));
            }

            int height = this._image_pixbuf.get_height();
            int width = this._image_pixbuf.get_width();
            int new_height = 0;
            int new_width = 0;
            /* 
            if(height < width) {
                stdout.printf("Crosswise...\n");
                // new_width will be 75% of media wrapper.
                new_width = (int)((double) allocation.width * 0.75);  
                double width_multiplier = (double) new_width / (double) width;
                new_height = (int) ((double)height * width_multiplier);
                stdout.printf("%dx%d -> %dx%d (%f%%)\n", width, height, new_width, new_height, width_multiplier);
            } else {
            */
            stdout.printf("Lengthwise...\n");
            new_height = 500;
            double height_multiplier = (double) new_height / (double) height; 
            new_width = (int) ((double)width * height_multiplier);
            //}
            stdout.printf("Scaling image to %dx%d...\n", new_width, new_height);
            this._image_pixbuf = this._image_pixbuf.scale_simple(new_width, new_height, Gdk.InterpType.BILINEAR);
            this._image = new Gtk.Image.from_pixbuf(this._image_pixbuf);
            this._image.get_style_context().add_class("post-image");
            this._media_wrapper.set_center_widget(this._image);
            this._media_wrapper.show_all();
            this._image.show();
        }

    }

}