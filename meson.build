project('com.github.xchan14.readit', 'vala', 'c')

# Create excecutable.
executable(
    meson.project_name(),
    'src/Program.vala',
    dependencies: [
        dependency('gtk+-3.0')
    ],
    install: true
)

# Create menu.
install_data(
    join_paths('data', meson.project_name() + '.desktop'),
    install_dir: join_paths(get_option('datadir'), 'applications')
)

# Create for app center.
install_data(
    join_paths('data', meson.project_name() + '.appdata.xml'),
    instlal_dir: join_paths(get_option('datadir'), 'metainfo')
)