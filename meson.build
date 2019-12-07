project('com.github.xchan14.readit', 'vala', 'c')

i18n = import('i18n')

# Set our translation domain
add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format (meson.project_name()), language:'c')

# Create excecutable.
executable(
    meson.project_name(),

    'src/Main.vala',
    'src/Comments/CommentItem.vala',
    'src/Comments/CommentList.vala',
    'src/Posts/PostDetailsPane.vala',
    'src/Posts/PostPane.vala',
    'src/Subreddits/SubredditPane.vala',
    'src/Widgets/AppBody.vala',
    'src/Widgets/AppHeaderBar.vala',
    'src/Widgets/AppMainWindow.vala',

    dependencies: [
        dependency('gtk+-3.0'),
        dependency('unity')
    ],
    install: true
)

#Install our .desktop file so the Applications Menu will see it
install_data(
    join_paths('data', meson.project_name() + '.desktop'),
    install_dir: join_paths(get_option('datadir'), 'applications')
)

#Install our .appdata.xml file so AppCenter will see it
install_data(
    join_paths('data', meson.project_name() + '.appdata.xml'),
    install_dir: join_paths(get_option('datadir'), 'metainfo')
)
