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

    'src/Action.vala',
    'src/AppHeaderBar.vala',
    'src/AppMainWindow.vala',
    'src/Dispatcher.vala',
    'src/Main.vala',

    'src/Backend/DataStores/PostStore.vala',
    'src/Backend/DataStores/UserStore.vala',

    'src/Comments/CommentItem.vala',
    'src/Comments/CommentList.vala',


    'src/Posts/Post.vala',
    'src/Posts/PostDetails/NoSelectedPostDetailsView.vala',
    'src/Posts/PostDetails/PostDetailsView.vala',
    'src/Posts/PostDetails/PostDetailsViewModel.vala',
    'src/Posts/PostList/LoadMorePostsAction.vala',
    'src/Posts/PostList/PostListView.vala',
    'src/Posts/PostList/ViewPostAction.vala',
    'src/Posts/PostList/PostListItem/PostListItemView.vala',
    'src/Posts/PostList/PostListItem/PostListItemViewModel.vala',

    'src/Screens/PostScreen.vala',

    'src/Users/User.vala',
    
    dependencies: [
        dependency('gtk+-3.0'),
        dependency('granite'),
        dependency('gee-0.8'),
        dependency('libsoup-2.4'),
        dependency('json-glib-1.0'),
        dependency('gio-2.0')
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