# Test Headerbar

## Table of Contents

- [About](#about)
- [Screenshot](#screenshot)

## About <a name = "about"></a>

I was checking the current status of [Nim](https://nim-lang.org/) binding for [Gtk](https://www.gtk.org/) in the [gintro repo](https://github.com/StefanSalewski/gintro) exploring the supplied examples. I came across the following [headerbar example](https://github.com/StefanSalewski/gintro/blob/master/examples/gtk4/headerbar.nim) form the gtk4 branch. Dissatisfied with the code structure I thought I could rewrite it in my favorite language [Vala](https://wiki.gnome.org/Projects/Vala).

This is how the code looks like in Nim:

```nim
# https://github.com/GNOME/gtk/blob/mainline/tests/testheaderbar.c
# this is still based on the original testheaderbar.c, which was recently replaced by testheaderbar2.c
# and testheaderbar.c is not a very good Nim GTK4 example unfortunately -- too comlicated and strange code.
# nim c headerbar.nim
import gintro/[gtk4, glib, gobject]

const
  Css = """
 .main.background {
 background-image: linear-gradient(to bottom, red, blue);
 border-width: 0px;
 }
 .titlebar.backdrop {
 background-image: none;
 background-color: @bg_color;
 border-radius: 10px 10px 0px 0px;
 }
 .titlebar {
 background-image: linear-gradient(to bottom, white, @bg_color);
 border-radius: 10px 10px 0px 0px;
 }
"""

# we try to avoid use of global header variable as done in C code
type
  MyWindow = ref object of gtk4.Window
    header: gtk4.Widget

proc response(d: gtk4.FileChooserDialog; responseID: int) = gtk4.destroy(d)

proc onBookmarkClicked(button: Button; data: MyWindow) =
  let window = gtk4.Window(data)
  let chooser = newFileChooserDialog("File Chooser Test", window,
      FileChooserAction.open)
  discard chooser.addButton("_Close", gtk4.ResponseType.close.ord)
  chooser.connect("response", response)
  chooser.show

#proc changeSubtitle(button: Button; w: MyWindow) =
#  if w.header.subtitle == "":
#    w.header.setSubtitle("(subtle subtitle)")
#  else:
#    w.header.setSubtitle("") # can we pass nil?

proc toggleFullscreen(button: Button; window: MyWindow) =
  var fullscreen {.global.}: bool
  if fullscreen:
    window.unfullscreen
    fullscreen = false
  else:
    window.fullscreen
    fullscreen = true

proc toIntVal(i: int): Value =
  let gtype = typeFromName("gint")
  discard init(result, gtype)
  setInt(result, i)

var done = false

proc quit_cb(b: Button) = # we can not pass a var parameter
 #gtk4.mainQuit()
 done = true
 wakeup(defaultMainContext()) # g_main_context_wakeup (NULL);

proc changeHeader(button: ToggleButton; window: MyWindow) =
  if button != nil and button.getActive:
    window.header = (newBox(gtk4.Orientation.horizontal,
        10))
    addCssClass(window.header, "titlebar")
    addCssClass(window.header, "header-bar")
    #window.header.setProperty("margin_start", toIntVal(10))
    #window.header.setProperty("margin_end", toIntVal(10))
    #window.header.setProperty("margin_top", toIntVal(10))
    #window.header.setProperty("margin_bottom", toIntVal(10))
    window.header.setMarginStart(10)
    window.header.setMarginEnd(10)
    window.header.setMarginTop(10)
    window.header.setMarginBottom(10)
    let label = newLabel("Label")
    gtk4.Box(window.header).append(label)
    let levelBar = newLevelBar()
    levelBar.setValue(0.4)
    levelBar.setHexpand
    gtk4.Box(window.header).append(levelBar)
  else:
    window.header = newHeaderBar()
    #addClass(getStyleContext(window.header), "titlebar")
    addCssClass(window.header, "titlebar")
    #window.header.setTitle("Example header")
    var button = newButton("_Close")
    button.setUseUnderline
    addCssClass(button, "suggested-action")
    button.connect("clicked", quit_cb)
    gtk4.HeaderBar(window.header).packEnd(button)
    button = newButton()
    let image = newImageFromIconName("bookmark-new-symbolic")
    button.connect("clicked", onBookmarkClicked, window)
    button.setChild(image)
    gtk4.HeaderBar(window.header).packStart(button)
  window.setTitlebar(window.header)

proc main =
  gtk4.init()
  #var window: MyWindow
  let window = newWindow(MyWindow)
  addCssClass(window, "main") # gtk_widget_add_css_class (window, "main");
  let provider = newCssProvider()
  provider.loadFromData(Css)
  addProviderForDisplay(getDisplay(window), provider, STYLE_PROVIDER_PRIORITY_USER)
  changeHeader(nil, window)
  let box = newBox(Orientation.vertical, 0)
  window.setChild(box) # gtk_window_set_child (GTK_WINDOW (window), box);
  #window.add(box)
  let content = newImageFromIconName("start-here-symbolic")
  content.setPixelSize(512)
  content.setVexpand
  box.append(content)
  let footer = newActionBar()
  footer.setCenterWidget(newCheckButton("Middle"))
  let button = newToggleButton("Custom")
  button.connect("clicked", changeHeader, window)
  footer.packStart(button)
  #var button1 = newButton("Subtitle")
  #button1.connect("clicked", changeSubtitle, window)
  #footer.packEnd(button1)
  var button1 = newButton("Fullscreen")
  footer.packEnd(button1)
  button1.connect("clicked", toggleFullscreen, window)
  box.append(footer)
  window.show
  #gtk4.main()
  while not done:
    discard iteration(defaultMainContext(), true) # g_main_context_iteration (NULL, TRUE);
  destroy(window) # this is special for this example, see  https://discourse.gnome.org/t/tests-testgaction-c/2232/6

main() # 137 lines
```

Howerver this the way of `Vala`

```vala
public class Gtk4Demo.MainWindow : Gtk.ApplicationWindow {

    public MainWindow (Gtk.Application app) {
        Object (application: app);

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
```

## Screenshot <a name = "screenshot"></a>

![Screenshot](https://github.com/aeldemery/testheaderbar/blob/main/screenshot1.png)
