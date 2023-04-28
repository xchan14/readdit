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

using Gtk;
using Readdit.Utils;
using Readdit.DataStores;
using Readdit.Models.Posts;

namespace Readdit.Views.PostList { 

    public class PostListItemView : Grid {
        Dispatcher _dispatcher = Dispatcher.INSTANCE;
        PostStore _post_store = PostStore.INSTANCE;

        Gtk.Box _header_wrapper;
        Gtk.Box _footer_wrapper;
        Gtk.Label _title;
        Gtk.Label _score;
        Gtk.Label _posted_by;
        Gtk.Label _subreddit;
        Gtk.Label _date_posted;
        
        Gtk.Box _preview_wrapper;
        Gtk.Image _preview;

        private bool _preview_shown;

        public PostListItemView(Post post)
        {
            this.model = post;
            var style = get_style_context();
            style.add_class("post-list-item");
            this.hexpand = true;
            this.column_homogeneous = true;
            this.row_spacing = 2;

            this._title =  new Gtk.Label(null);
            this._title.label = post.title;
            this._title.get_style_context().add_class("post-title");
            this._title.get_style_context().add_class("h3");
            this._title.xalign = 0.0f;
            this._title.wrap = true;
            this._title.single_line_mode = false;
            //this._title.ellipsize = Pango.EllipsizeMode.END;

            this._preview = new Gtk.Image();
            this._preview_wrapper = new Box(Gtk.Orientation.VERTICAL, 0);
            this._preview_wrapper.halign = Align.CENTER;
            this._preview_wrapper.pack_start(this._preview, true, true, 0);

            this._score = new Gtk.Label(null);
            this._score.label = post.score.to_string();
            this._score.get_style_context().add_class("score");
            this._score.valign = Align.END;

            this._subreddit = new Label(null);
            this._subreddit.label = post.subreddit;
            this._subreddit.get_style_context().add_class("subreddit");

            this._posted_by = new Label(null);
            this._posted_by.label = post.posted_by;
            this._posted_by.get_style_context().add_class("posted-by");

            this._date_posted = new Label(null);
            this._date_posted.get_style_context().add_class("date-posted");
            this._date_posted.xalign = 0.0f;
            string date_format = "%B %e, %Y";
            /*  bool is_same_day = new DateTime.now_local().format(date_format) == model.date_created.to_local().format(date_format);
            if(is_same_day) {
                date_format = date_format + "%i %P";
            }  */
            this._date_posted.label = model.date_created.to_local().format(date_format);


            this._header_wrapper = new Box(Orientation.HORIZONTAL, 0);
            this._header_wrapper.baseline_position = BaselinePosition.BOTTOM;
            this._header_wrapper.pack_start(_score, false, false, 0);
            this._header_wrapper.pack_start(new Label(" "), false, false, 0);
            this._header_wrapper.pack_start(_posted_by, false, false, 0);
            this._header_wrapper.pack_start(new Label(" in "), false, false, 0);
            this._header_wrapper.pack_start(_subreddit, false, false, 0);
            this._header_wrapper.forall((widget) => {
                ((Label)widget).valign = Gtk.Align.END;
            });

            this._footer_wrapper = new Box(Orientation.HORIZONTAL, 0);
            this._footer_wrapper.pack_start(this._date_posted);

            attach(this._header_wrapper, 1, 1, 3, 1);
            if(this.model.preview_url != null) {
                attach(this._title, 1, 2, 2, 1);
                attach(this._preview_wrapper, 3, 2, 1, 1);
            } else {
                attach(this._title, 1, 2, 3, 1);
            }
            attach(this._footer_wrapper, 1, 3, 2, 1);

            set_row_baseline_position(2, BaselinePosition.CENTER);

            show_all();
             
            this._post_store.emit_change.connect(on_post_store_emit_changed);

            this.map.connect(() => {
                if(this.model.preview_url != null) {
                    this._dispatcher.dispatch(new LoadPostPreviewAction(this.model.id, this.model.preview_url));
                }
            });
        }

        public Post model { get; set; } 

        private void on_post_store_emit_changed() {
            if(this.model.preview_path != null && !this._preview_shown) {
                load_post_preview();
            }
        }

        private void load_post_preview() {
            if(this.model.preview_path == null)
                return;

            try {
                var preview_pixbuf = new Gdk.Pixbuf.from_file(this.model.preview_path);
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
                this._preview.get_style_context().add_class("thumbnail");
                this._preview_wrapper.foreach(w => w.destroy());
                this._preview_wrapper.pack_start(this._preview, false, false, 0);
                this._preview_wrapper.show_all();
            } catch(Error e) {
                stderr.printf(e.message);
            } finally {
                this._preview_shown = true;
            }
        }
    }
    
}
