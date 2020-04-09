using Posts;
using Posts.PostList;
using Posts.PostDetails;
using Backend.DataStores;

public class Screens.PostScreen : Gtk.Paned {

    PostListView _post_list_view;
    PostDetailsView _post_details_view;
    Gtk.Widget _empty_details_view;
    Gtk.ScrolledWindow _details_view_wrapper;

    construct  {
        get_style_context().add_class("post-view");

        this._post_list_view = new PostListView();
        this._details_view_wrapper = new Gtk.ScrolledWindow(null, null);
        this._post_details_view = new PostDetailsView();
        this._empty_details_view = new NoSelectedPostDetailsView();

        this._details_view_wrapper.add(this._empty_details_view);

        pack1(this._post_list_view, true, false);
        add2(this._details_view_wrapper);
        set_position(1);

        PostStore.INSTANCE.viewed_post_changed.connect((post) => {
            foreach(var child in this._details_view_wrapper.get_children()) {
                child.destroy();
            }

            if(post == null) {
                this._post_details_view.unparent();
                this._details_view_wrapper.add(this._empty_details_view);
            } else {
                this._empty_details_view.unparent();
                this._details_view_wrapper.add(this._post_details_view);
                this._post_details_view.update(post);
            }
        });
    }

}