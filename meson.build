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