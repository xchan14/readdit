using Gee;
using ReadIt.Backend.DataStores;
using ReadIt.Posts.PostList.PostListItem;
using ReadIt.Users;

namespace ReadIt.Posts.PostList { 

    public class PostListView : Gtk.ScrolledWindow {
        // Reference to post store.
        PostStore _post_store = PostStore.INSTANCE;
        // Reference to global dispatcher.
        ReadIt.Dispatcher _dispatcher = ReadIt.Dispatcher.INSTANCE;
        // Listbox widget for the list of posts.
        Gtk.ListBox _listbox = new Gtk.ListBox();
        // Data store behind the posts listbox.
        ListStore _posts_list_store;

        construct 
        {
            get_style_context().add_class("post-list");
            set_size_request(400, 1);
            set_propagate_natural_width(true);
            hscrollbar_policy = Gtk.PolicyType.NEVER;

            this._posts_list_store = new ListStore(typeof(Post));

            this._listbox.activate_on_single_click = true;
            this._listbox.selection_mode = Gtk.SelectionMode.BROWSE;
            this._listbox.get_style_context().add_class("post-list-listbox");
            this._listbox.bind_model(_posts_list_store, create_list_item_widget);

            add(_listbox);

            bind_event_handlers();
        }

        // Bind event handlers.
        private void bind_event_handlers() {
            this.edge_reached.connect(on_edge_reached);
            this._listbox.row_selected.connect(on_listbox_row_selected);
            this._post_store.posts_loaded.connect(on_posts_loaded);
        }

        private void on_edge_reached(Gtk.PositionType pos) {
            if(pos == Gtk.PositionType.BOTTOM) {
                // Infinite scroll implementation.
                this._dispatcher.dispatch(new LoadMorePostsAction(null));
            }
        }

        // Creates the widget to be displayed on post listbox widget.
        private Gtk.Widget create_list_item_widget(Object item) {
            var post = (Post) item;
            var view = new PostListItemView(post);
            view.title_pressed.connect(on_item_title_pressed);
            return view;
        }

        // Handles row selected event of listbox.
        private void on_listbox_row_selected(Gtk.ListBoxRow? row) {
            string id = null;
            if(row != null) {
                var post_list_view = (PostListItemView) row.get_children().first().data;
                id = post_list_view.model.id;
                stdout.printf("selected post %s\n", id);
            }
            _dispatcher.dispatch(new ViewPostAction(id));
        }

        // Handles button pressed of title in child widget.
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

        // Handles new posts loaded event.
        private void on_posts_loaded(Iterable<Post> posts) {
            this._posts_list_store.remove_all();
            foreach(Post post in posts) {
                this._posts_list_store.append(post);
            }
        }

    }
}