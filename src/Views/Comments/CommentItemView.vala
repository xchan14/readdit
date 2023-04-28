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
using Readdit.Models.Comments;

namespace Readdit.Views.Comments  {

    public class CommentItemView : Gtk.Box  {

        Label _comment_by;
        Label _score;
        Label _text;
        CommentCollectionView _replies;

        Gtk.Box _header;

        public CommentItemView(Comment comment) {
            Object(model: comment);
            orientation = Orientation.VERTICAL;
            resize_mode = ResizeMode.PARENT;

            //margin_start = 8;
            expand = false;
            get_style_context().add_class("comment-wrapper");
            get_style_context().add_class("h3");

            this._comment_by = new Label(null) {
                label = comment.comment_by,
                xalign = 0.0f
            };
            this._comment_by.get_style_context().add_class("comment-by");
            this._score = new Label(null) {
                label = " ".concat(comment.score.to_string()) ,
                xalign = 0.0f
            };
            
            this._text = new Label(null) {
                label = comment.text,
                xalign = 0.0f,
                selectable = true,
                wrap = true,
                wrap_mode = Pango.WrapMode.WORD_CHAR
            };
            this._text.set_line_wrap(true);
            this._text.get_style_context().add_class("comment-text");

            this._header = new Box(Gtk.Orientation.HORIZONTAL, 0) {
                baseline_position = Gtk.BaselinePosition.BOTTOM   
            };
            this._header.pack_start(this._comment_by, false, false, 0);
            create_score_buttons();
            //this._header.pack_start(this._score, false, false, 0);


            pack_start(this._header, false, false, 0);
            pack_start(this._text, false, false, 0);

            if(this.model.comment_collection != null) {
                this._replies = new CommentCollectionView(this.model.comment_collection);
                this._replies.get_style_context().add_class("comment-children");
                pack_start(this._replies);
            }

            show_all();
        }

        public Comment model { get; construct; }

        private void create_score_buttons() {
            var toggle_score = new Button.with_label (_model.score.to_string());
            var toggle_up = new ToggleButton.with_label (">");
            var toggle_down = new ToggleButton.with_label ("<");
            var toggles = new Box(Orientation.HORIZONTAL, 0);

            toggles.get_style_context ().add_class (STYLE_CLASS_LINKED);
            toggles.get_style_context ().add_class ("comment-score-buttons");
            toggles.pack_start (toggle_down, false, false);
            toggles.pack_start (toggle_score, false, false);
            toggles.pack_start (toggle_up, false, false);
            _header.pack_start (toggles, false,false);
        }
    }

}
