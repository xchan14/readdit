using ReadIt.Backend.DataStores;
using ReadIt.Posts;
using ReadIt.Posts.PostList;
using ReadIt.Posts.PostDetails;

public class ReadIt.Screens.PostScreen : Gtk.Paned {
    PostStore _post_store = PostStore.INSTANCE;

    PostListView _post_list_view;
    PostDetailsView _post_details_view;
    Gtk.Widget _empty_details_view;
    Gtk.ScrolledWindow _details_view_wrapper;

    construct  {
        get_style_context().add_class("post-view");

        this._post_list_view = new PostListView();
        this._post_details_view = new PostDetailsView();
        this._empty_details_view = new EmptyPostDetailsView();

        this._details_view_wrapper = new Gtk.ScrolledWindow(null, null);
        //this._details_view_wrapper.hscrollbar_policy = Gtk.PolicyType.NEVER;
        this._details_view_wrapper.expand = false;
        this._details_view_wrapper.add(this._empty_details_view);

        pack1(this._post_list_view, true, false);
        pack2(this._details_view_wrapper, true, false);
        set_position(2);

        this._post_store.emit_change.connect(on_post_store_emit_change);
    }

    private void on_post_store_emit_change() {
        this._details_view_wrapper.foreach(w => {
            if(this._post_store.current_viewed_post != null 
                && (w != this._post_details_view)
            ) {
                this._details_view_wrapper.remove(w);
                this._details_view_wrapper.add(this._post_details_view);
            } else if (this._post_store.current_viewed_post == null 
                && (w != this._empty_details_view)
            ) {
                this._details_view_wrapper.remove(w);
                this._details_view_wrapper.add(this._empty_details_view);
            }       
        });
    }

}