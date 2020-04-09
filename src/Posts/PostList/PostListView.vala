using Backend.DataStores;
using Users;
using Gee;
using Posts.PostList.PostListItem;

namespace Posts.PostList { 

    public class PostListView : Gtk.ScrolledWindow {
        ReadIt.Dispatcher _dispatcher = ReadIt.Dispatcher.INSTANCE;
        Gtk.ListBox _listbox = new Gtk.ListBox();
        ArrayList<string> _added_ids; 

        construct 
        {
            _added_ids = new ArrayList<string>();
            _listbox.activate_on_single_click = true;
            _listbox.selection_mode = Gtk.SelectionMode.BROWSE;
            _listbox.get_style_context().add_class("post-list-listbox");

            get_style_context().add_class("post-list");
            set_size_request(400, 1);
            set_propagate_natural_width(true);

            bind_event_handlers();
            add(_listbox);
        }

        private void bind_event_handlers() {
            edge_reached.connect(on_edge_reached);
            _listbox.row_selected.connect(on_listbox_row_selected);
            PostStore.INSTANCE.posts_loaded.connect(on_posts_loaded);
        }

        private void on_edge_reached(Gtk.PositionType pos) {
            if(pos == Gtk.PositionType.BOTTOM) {
                _dispatcher.dispatch(new LoadMorePostsAction(null));
            }
        }

        private void on_listbox_row_selected(Gtk.ListBoxRow? row) {
            string id = null;
            if(row != null) {
                var post_list_view = (PostListItemView) row.get_children().first().data;
                id = post_list_view.model.id;
                stdout.printf("selected post %s\n", id);
            }
            _dispatcher.dispatch(new ViewPostAction(id));
        }

        private void add_post(PostListItemViewModel model) {
            var post_list_item_view = new PostListItemView(model);
            post_list_item_view.title_pressed.connect(on_item_title_pressed);
            this._listbox.add(post_list_item_view);
            _added_ids.add(model.id);
        }

        private void on_item_title_pressed(string id) {
            foreach(var child in this._listbox.get_children()) {
                var row = (Gtk.ListBoxRow) child;
                var item_view = (PostListItemView) row.get_children().first().data;
                if(item_view.model.id == id) {
                    this._listbox.select_row(row);
                    break;
                }
            }
        }

        private void on_posts_loaded(Iterable<Post> posts) {
            foreach(Post post in posts) {
                if(_added_ids.contains(post.id))
                    continue;
                var model = new PostListItemViewModel();
                model.id = post.id;
                model.title = post.title;
                model.subreddit = post.subreddit;
                model.score = post.score;
                model.date_created = post.date_created;
                model.date_loaded = post.date_loaded;
                add_post(model);
            }
        }

    }
}