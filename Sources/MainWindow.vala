public class Gtk4Demo.MainWindow : Gtk.ApplicationWindow {

    public MainWindow (Gtk.Application app) {
        Object (application: app, title: "Headerbar Example");

        var provider = new Gtk.CssProvider ();
        provider.load_from_resource ("/github/aeldemery/testheaderbar/Styles/Headerbar.css");
        Gtk.StyleContext.add_provider_for_display (this.display, provider, 800);
        this.add_css_class ("main");

        var header_bar = new Gtk.HeaderBar ();
        header_bar.add_css_class ("titlebar");
        this.set_titlebar(header_bar);

        var file_chooser_btn = new Gtk.Button.from_icon_name ("bookmark-new-symbolic");
        header_bar.pack_start (file_chooser_btn);
        file_chooser_btn.clicked.connect (() => {
            var chooser = new Gtk.FileChooserDialog ("Open Chooser Test", this, Gtk.FileChooserAction.OPEN, "Choose", "Discard");
            chooser.response.connect ((response_id) => {
                chooser.close ();
            });
            chooser.show ();
        });

        var close_btn = new Gtk.Button.with_label ("Close...");
        header_bar.pack_end (close_btn);
        close_btn.add_css_class ("suggested-action");
        close_btn.clicked.connect (() => {
            this.close ();
        });

        var header_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        header_box.add_css_class ("titlebar");
        header_box.add_css_class ("header-bar");
        with (header_box) {
            margin_bottom = margin_end = margin_start = margin_top = 10;
        }
        
        var label = new Gtk.Label ("Label");
        header_box.append (label);

        var level_bar = new Gtk.LevelBar ();
        level_bar.value = 0.4;
        level_bar.hexpand = true;
        header_box.append (level_bar);        

        var vbox = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);

        var content_img = new Gtk.Image.from_icon_name ("start-here-symbolic");
        content_img.pixel_size = 512;
        content_img.vexpand = true;
        vbox.append (content_img);

        var footer = new Gtk.ActionBar ();
        var custom_btn = new Gtk.ToggleButton.with_label ("Custom");
        custom_btn.clicked.connect (() => {
            if (custom_btn.active) {
                this.set_titlebar (header_box);
            } else {
                this.set_titlebar (header_bar);
            }
        });
        footer.pack_start (custom_btn);

        var fullscreen_btn = new Gtk.Button.with_label ("Fullscreen");
        fullscreen_btn.clicked.connect (() => {
            if (this.fullscreened) {
                this.unfullscreen ();
            } else {
                this.fullscreen ();
            }
        });
        footer.pack_end (fullscreen_btn);
        vbox.append (footer);

        this.child = vbox;
    }
}