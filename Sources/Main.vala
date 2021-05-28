int main(string[] args) {
    var app = new Gtk4Demo.App ();
    return app.run (args);
}

public class Gtk4Demo.App : Gtk.Application {
    public App () {
        Object (
            application_id: "github.aeldemery.testheaderbar", 
            flags: GLib.ApplicationFlags.FLAGS_NONE
        );
    }

    protected override void activate () {
        var win = this.active_window;
        if (win == null) {
            win = new Gtk4Demo.MainWindow (this);
        }
        win.present ();
    }
}