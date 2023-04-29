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
using Readdit.Views.PostList;

public class Readdit.Views.Layout.Sidebar : Grid {

    private Hdy.HeaderBar _header;
    private ActionBar _actionBar;
    private ScrolledWindow _content;
    private Widget _contentView;

    public Sidebar(Widget contentView) {
        _contentView = contentView;
        width_request = 400;

        createHeaderBar();
        attach (_header, 0, 0);

        createContent();
        attach (_content, 0, 1);

        //createActionBar();
        //attach (_actionBar, 0, 2);

        unowned StyleContext sidebar_style_context = get_style_context ();
        sidebar_style_context.add_class (Gtk.STYLE_CLASS_SIDEBAR);
    }

    public Hdy.HeaderBar GetHeader() {
        return _header;
    }

    private void createHeaderBar() {
        _header = new Hdy.HeaderBar () {
            has_subtitle = false,
            show_close_button = true
        };

        unowned Gtk.StyleContext sidebar_header_context = _header.get_style_context ();
        sidebar_header_context.add_class ("default-decoration");
        sidebar_header_context.add_class (Gtk.STYLE_CLASS_FLAT);
    }

    private void createContent() {
        var listbox = new Gtk.ListBox ();
        var scheduled_row = new Gtk.Label("Test");
        listbox.add (scheduled_row);

        _content = new Gtk.ScrolledWindow (null, null) {
            expand = true,
            hscrollbar_policy = Gtk.PolicyType.NEVER
        };

        //var postList = new PostList();
        //_content.add (postList);
        _content.add(_contentView);

        var postListView = new PostListView();
        _content.add(postListView);
    }

    private void createActionBar() {
        _actionBar = new Gtk.ActionBar ();
        unowned Gtk.StyleContext actionbar_style_context = _actionBar.get_style_context ();
        actionbar_style_context.add_class (Gtk.STYLE_CLASS_FLAT);

        var online_accounts_button = new Gtk.ModelButton () {
            text = _("Online Accounts Settings…")
        };

        var add_tasklist_grid = new Gtk.Grid () {
            margin_top = 3,
            margin_bottom = 3,
            row_spacing = 3
        };

        var add_tasklist_buttonbox = new Gtk.ButtonBox (Gtk.Orientation.VERTICAL) {
            layout_style = Gtk.ButtonBoxStyle.EXPAND
        };


        add_tasklist_grid.attach (add_tasklist_buttonbox, 0, 0);
        add_tasklist_grid.attach (new Gtk.Separator (Gtk.Orientation.HORIZONTAL), 0, 1);
        add_tasklist_grid.attach (online_accounts_button, 0, 2);
        add_tasklist_grid.show_all ();

        var add_tasklist_popover = new Gtk.Popover (null);
        add_tasklist_popover.add (add_tasklist_grid);

        var add_tasklist_button = new Gtk.MenuButton () {
            label = _("Add Task List…"),
            image = new Gtk.Image.from_icon_name ("list-add-symbolic", Gtk.IconSize.SMALL_TOOLBAR),
            always_show_image = true,
            popover = add_tasklist_popover
        };

        _actionBar.add (add_tasklist_button);
    }
}