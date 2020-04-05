project('com.github.xchan14.readit', 'vala', 'c')

i18n = import('i18n')
gnome = import('gnome')

# Set our translation domain
add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format (meson.project_name()), language:'c')

asresources = gnome.compile_resources(
    'as-resources', 'data/' + meson.project_name() + '.gresource.xml',
    source_dir: 'data',
    c_name: 'as'
)

# Create excecutable.
executable(
    meson.project_name(),
    asresources,

    'src/Main.vala',

    'src/AppBody.vala',
    'src/AppHeaderBar.vala',
    'src/AppMainWindow.vala',

    'src/Comments/CommentItem.vala',
    'src/Comments/CommentList.vala',

    'src/Posts/Post.vala',
    'src/Posts/PostDetailsView.vala',
    'src/Posts/PostListView.vala',
    'src/Posts/PostListItemView.vala',
    
    dependencies: [
        dependency('gtk+-3.0'),
        dependency('granite')
    ],
    install: true
)

#Translate and install our .desktop file
i18n.merge_file(
    input: join_paths('data', meson.project_name() + '.desktop.in'),
    output: meson.project_name() + '.desktop',
    po_dir: join_paths(meson.source_root(), 'po'),
    type: 'desktop',
    install: true,
    install_dir: join_paths(get_option('datadir'), 'applications')
)

#Translate and install our .appdata file
i18n.merge_file(
    input: join_paths('data', meson.project_name() + '.appdata.xml.in'),
    output: meson.project_name() + '.appdata.xml',
    po_dir: join_paths(meson.source_root(), 'po'),
    install: true,
    install_dir: join_paths(get_option('datadir'), 'metainfo')
)



subdir('po')