sources = files (
    'Main.vala',
    'MainWindow.vala',
)

dependencies = [
    dependency ('gtk4'),
    dependency ('gobject-2.0'),
    dependency ('glib-2.0'),
]

executable (
    meson.project_name (),
    sources: [sources, resources],
    dependencies: dependencies,
    install: true,
)
