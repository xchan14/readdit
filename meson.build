project('io.github.xchan14.readdit', 'vala', 'c')

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

    'src/Action.vala',
    'src/Application.vala',
    'src/AppHeaderBar.vala',
    'src/Dispatcher.vala',
    'src/Contants.vala',
    'src/Views/MainWindow.vala',

    'src/Views/Layout/Sidebar.vala',
    'src/Views/Layout/MainContent.vala',

    'src/DataStores/Parsers/CommentParser.vala',
    'src/DataStores/Parsers/PostParser.vala',
    'src/DataStores/PostStore.vala',
    'src/DataStores/UserStore.vala',

    'src/Models/Comments/Comment.vala',
    'src/Models/Comments/CommentCollection.vala',
    'src/Models/Comments/LoadMoreCommentsAction.vala',
    'src/Models/Comments/LoadPostCommentsAction.vala',

    'src/Views/Comments/CommentItemView.vala',
    'src/Views/Comments/CommentCollectionView.vala',

    'src/Models/Posts/Post.vala',
    'src/Models/Posts/LoadPostDetailsImageAction.vala',
    'src/Models/Posts/LoadMorePostsAction.vala',
    'src/Models/Posts/LoadPostPreviewAction.vala',
    'src/Models/Posts/ViewPostAction.vala',

    'src/Views/PostList/PostListView.vala',
    'src/Views/PostList/PostListItemView.vala',

    'src/Views/PostDetails/PostDetailsContentView.vala',
    'src/Views/PostDetails/PostDetailsView.vala',
    'src/Views/PostDetails/EmptyPostDetailsView.vala',

    'src/Screens/PostScreen.vala',

    'src/Models/Users/User.vala',
    'src/Views/Widgets/VideoPlayer.vala',

    'src/Utils/ImageUtils.vala',
    
    dependencies: [
        dependency('gtk+-3.0'),
        dependency('granite'),
        dependency('gee-0.8'),
        dependency('libsoup-2.4'),
        dependency('json-glib-1.0'),
        dependency('gio-2.0'),
        dependency('clutter-1.0'),
        dependency('clutter-gst-3.0'),
        dependency('clutter-gtk-1.0'),
        dependency('webkit2gtk-4.0'),
        dependency('libhandy-1', version: '>=0.90.0')
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
