gnome = import ('gnome')

gresource_file = files (
    'github.aeldemery.testheaderbar.gresource.xml',
)

resources = gnome.compile_resources (
    'res-resources',
    gresource_file,
    source_dir: '.',
    c_name: 'res',
)