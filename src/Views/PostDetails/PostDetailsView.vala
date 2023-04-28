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
using Gee;
using Granite.Widgets;
using Readdit.Models.Posts;
using Readdit.Models.Comments;
using Readdit.Views.PostDetails;
using Readdit.Views.Comments;
using Readdit.DataStores;

namespace Readdit.Views.PostDetails { 
    
    public class PostDetailsView : Box {
        PostStore _post_store = PostStore.INSTANCE;
        Dispatcher _dispatcher = Dispatcher.INSTANCE;

        PostDetailsContentView _post_details_content_view;
        CommentCollectionView _comments_view;
        
        construct {
            set_size_request(400, -1);
            get_style_context().add_class("post-details");
            orientation = Orientation.VERTICAL;
        }

        public PostDetailsView(Post post) {
            Object(model: post);
            
            this._post_details_content_view = new PostDetailsContentView(this.model);
            pack_start(this._post_details_content_view, false, true);
            show_all();

            this.size_allocate.connect((allocation) => {
                this.queue_draw();
            });
            this.map.connect(() => {
                this._dispatcher.dispatch(new LoadPostCommentsAction(this.model.id, null));
            });
            this._post_store.emit_change.connect(on_post_store_emit_change);
        }

        public Post model { get; construct; }

        /*
         * Handles changes in Post Store.
         */ 
        private void on_post_store_emit_change() {
            if(this._comments_view == null && this.model.comment_collection != null) {
                stdout.printf("Rendering comments...\n");
                this._comments_view = new CommentCollectionView(this.model.comment_collection);
                //this._comments_view.get_style_context().add_class("card");
                pack_start(this._comments_view, false, true);
                this._comments_view.show_all();
                stdout.printf("Comments rendered....\n");
            }
        }
          
    }

}
