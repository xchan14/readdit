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

    public class PostListItemView : Box {
        Dispatcher _dispatcher = Dispatcher.INSTANCE;
        PostStore _post_store = PostStore.INSTANCE;

        Label _title;
        Label _score;
        Label _posted_by;
        Label _subreddit;
        Label _date_posted;
        
        Box _preview_wrapper;
        Image _preview;

        private bool _preview_shown;

        construct {
            orientation = Orientation.VERTICAL;
            hexpand = true;
            var style = get_style_context();
            style.add_class("post-list-item");
        }

        public PostListItemView(Post post)
        {
            this.model = post;

            AddHeader();
            AddContent();
            AddFooter();

            show_all();
             
            this._post_store.emit_change.connect(on_post_store_emit_changed);

            this.map.connect(() => {
                if(this.model.preview_url != null) {
                    this._dispatcher.dispatch(new LoadPostPreviewAction(this.model.id, this.model.preview_url));
                }
            });
        }

        private void AddHeader() {
            // Score
            var scoreText = FormatUtils.FormatScore(model.score);
            this._score = new Gtk.Label(scoreText);
            this._score.get_style_context().add_class("score");
            this._score.valign = Align.BASELINE;   

            // Posted By
            _posted_by = new Label(model.posted_by);
            _posted_by.get_style_context().add_class("posted-by");
            _posted_by.valign = Align.BASELINE;


            // Subreddit
            this._subreddit = new Label(null);
            this._subreddit.label = _model.subreddit;
            this._subreddit.get_style_context().add_class("subreddit");
            this._subreddit.valign = Align.BASELINE;

            var container = new Box(Orientation.HORIZONTAL, 9);
            container.pack_start(_score, false, true, 0);
            container.pack_start(_posted_by, false, true, 0);
            container.pack_end(_subreddit, false, false, 0);

            pack_start(container, false, false, 0);
        }

        private void AddContent() {
            // Title
            _title = new Label( model.title);
            _title.get_style_context().add_class("post-title");
            _title.get_style_context().add_class("h3");
            _title.xalign = 0.0f;
            _title.valign = Align.START;
            _title.wrap = true;
            _title.single_line_mode = false;

            // Preview
            _preview = new Gtk.Image();
            _preview_wrapper = new Box(Orientation.HORIZONTAL, 0);
            _preview_wrapper.valign = Align.START;
            _preview_wrapper.pack_start(this._preview, true, true, 0);

            var container = new Box(Orientation.HORIZONTAL, 12);
            container.pack_start(_title);
            if(_model.preview_url != null) {
                container.pack_start(_preview_wrapper, false, false, 0);
            } 

            pack_start(container, false ,false, 0);
        }

        private void AddFooter() {
            // Date Posted
            var diff = DateUtils.ToDateDifference(model.date_created);
             _date_posted = new Label(diff);
            _date_posted.get_style_context().add_class("date-posted");
            _date_posted.xalign = 0;
            _date_posted.valign = Align.BASELINE;

            var container = new Box(Orientation.HORIZONTAL, 0);
            container.get_style_context().add_class("post-list-item-footer");
            container.pack_end(_date_posted, false, false, 0);

            pack_start(container);
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
                preview_pixbuf = ImageUtils.CropToSquare(preview_pixbuf, 80);

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
