# Code files

Here is a complete list of all code files of the project.<br>
**If you add other files to the project, make sure to update the list!**

Documentation:
- [`README.md`](README.md) with contributing guidelines and code style
- [`doc/description.md`](doc/description.md) with the description of the app and its functionalities
- [`doc/files.md`](doc/files.md) with a complete list of all files and their content
- [`doc/commands.md`](doc/commands.md) with useful commands to setup dev env, build and deploy app
- [`doc/styles.md`](doc/styles.md) with a short guide to use app styles in dart code
- [`doc/pocketbase.md`](doc/pocketbase.md) with pocketbase database structure description
- [`doc/cheatsheet.md`](doc/cheatsheet.md) with useful code examples for dart and flutter

User:
- [`lib/user/auth.dart`](lib/user/auth.dart) for user authorization and loading screen
- [`lib/user/signup.dart`](lib/user/signup.dart) for signup form
- [`lib/user/login.dart`](lib/user/login.dart) for login form
- [`lib/user/profile.dart`](lib/user/profile.dart) for user profile page

Rooms:
- [`lib/room/list.dart`](lib/room/list.dart) for all rooms list
- [`lib/room/details.dart`](lib/room/details.dart) for chat room page details

Chat:
- [`lib/chat/screen.dart`](lib/chat/screen.dart) for chat page with messages list
- [`lib/chat/input.dart`](lib/chat/input.dart) for the bottom bar of chat, to send messages
- [`lib/chat/msg.dart`](lib/chat/msg.dart) for message bubble widget with avatar, and context menu
- [`lib/chat/preview.dart`](lib/chat/preview.dart) for clickable message tile, used in replies, edit, pinned messages
- [`lib/chat/extras.dart`](lib/chat/extras.dart) for various widgets like `DateTitle`, `UnreadMessageTitle`

Development:
- [`lib/dev/styles.dart`](lib/dev/styles.dart) with an example page that showcases app colors and styles
- [`lib/dev/localize.dart`](lib/dev/localize.dart) with an example page that showcases text localization features
- other debug pages (shown as fake rooms), for scouting or interactive examples for devs

Other:
- [`lib/util/style.dart`](lib/util/style.dart) for app theme colors and style
- [`lib/util/localize.dart`](lib/util/localize.dart) for app localization functions
- [`lib/util/form.dart`](lib/util/form.dart) with reusable form widget (used for login/signup)
- [`lib/util/pb_service.dart`](lib/util/pb_service.dart) for pocketbase related functions 
- [`lib/util/constants.dart`](lib/util/constants.dart) for app configuration, like locale and server urls
- [`lib/util/misc.dart`](lib/util/misc.dart) for other utilities like `navigateToPage`
- [`lib/main.dart`](lib/main.dart) for app entrypoint and debug pages registration
