
using Gtk;
using Granite;
using Readdit.Views.PostDetails;

public class Readdit.Views.Layout.MainContent : Box {

    private Hdy.HeaderBar _header;
    private ScrolledWindow _contentContainer;
    private Widget _contentView;

    construct {
        orientation = Orientation.VERTICAL;
        resize_mode = ResizeMode.PARENT;
        get_style_context ().add_class (Gtk.STYLE_CLASS_BACKGROUND);

        insert_header();
        insert_content_container();
    }

    public Hdy.HeaderBar get_header() {
        return _header;
    }

    private void insert_header() {
        _header = new Hdy.HeaderBar () {
            has_subtitle = false,
            show_close_button = true,
        };

        _header.pack_end(create_theme_mode_switch());

        unowned StyleContext _header_context = _header.get_style_context ();
        _header_context.add_class ("default-decoration");
        _header_context.add_class (Gtk.STYLE_CLASS_FLAT);

        pack_start(_header, false, false, 0);
    }

    private ModeSwitch create_theme_mode_switch() {
        var mode_switch = new Granite.ModeSwitch.from_icon_name (
            "display-brightness-symbolic",
            "weather-clear-night-symbolic"
        );
        mode_switch.primary_icon_tooltip_text = ("Light background");
        mode_switch.secondary_icon_tooltip_text = ("Dark background");
        mode_switch.valign = Gtk.Align.CENTER;
        var gtk_settings = Gtk.Settings.get_default ();
        mode_switch.bind_property ("active", gtk_settings, "gtk_application_prefer_dark_theme");
        return mode_switch;
    } 

    private void insert_content_container() {
        _contentContainer = new Gtk.ScrolledWindow(null, null) {
            hscrollbar_policy = PolicyType.NEVER,
            expand = false
        };
        pack_start(_contentContainer, true, true);
    }

    public void change_content(owned Widget contentView) {
        if(contentView == null) {
            contentView = new EmptyPostDetailsView();
            stdout.printf("Empty content view set...\n");
        }
        // Remove content from container
        _contentContainer.remove(_contentView);

        // Reassing new content 
        _contentView = contentView;
        _contentContainer.get_style_context().add_class("content");

        // Attach new content to container
        _contentContainer.add(contentView);
        stdout.printf("Content changed...\n");
    }
}