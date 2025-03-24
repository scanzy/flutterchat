# flutterchat

Official chat app for Realmen Community.<br/>
Main objective: provide a cross-platform self-hosted working alternative to Telegram or Keet, for a realmen chat experience.


## Code organization

Documentation:
- `README.md` (this file) with contributing guidelines and code style
- [`doc/description.md`](doc/description.md) with the description of the app and its functionalities
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

If you add other files to the project, make sure to update the above list.


## Contributing

To contribute to the project, follow the steps below:


1. **Look at tasks**: visit [this project](https://github.com/users/scanzy/projects/1) to see the board with all issues (development tasks), divided into groups.
2. **Choose priority**: choose one of the issues in the "Next" group (priority) assign it to yourself, and move it in the "In progress" group.
3. **Investigate** about the task and comment the issue describing how you think to solve the issue, including helpful links, resources and code snippets.
4. **Launch the environment** starting Gitpod or Docker. This may take some minutes, especially on the first time. For more info on dev env setup, visit [this page](doc/commands.md).
5. **Create branch** with short but clear name, with issue number at the end (e.g. `action-buttons-9` for issue #9), separating words with hyphens. Make sure to link the branch to the issue, clicking on "Development" title, at the bottom right of issue page.
6. **Update app version** in [`pubspec.yaml`](pubspec.yaml), replacing the last number with issue number (e.g. `1.0.9` for issue #9).
7. **Edit code and test it** until the issue is solved, making one or more commits with short but clear description of the edits. Push changes to avoid to loose unsaved code.
8. **Write updates** for the team into the issue, including screenshots of the new feature, if applicable.
9. **Close & Pull**: once the new feature is implemented (or the bug solved), close the issue and create a pull request for the branch. Make sure to link the pull request to the issue, as on step 5.
10. **Ask for review**: inform the team, so that another developer can review the pull request and accept it (or edit it), merging the branch to main.

To suggest new features or if you find some bug, visit [this project](https://github.com/users/scanzy/projects/1) and open an issue using the right template (feature or bug), making sure to include all the relevant information.


## Code style

To keep code readable and easy to mantain, follow this rules:
- comment code blocks frequently, explaining using simple and concise words
- separate code blocks using single blank lines
- separate methods and classes using double blank lines
- include at least one line of comment for every class, method and function
- use lowerCamelCase for names of variables, fields, methods and functions
- use UpperCamelCase for names of classes and mixins
- use leading _ for private members, avoiding snake_case
- use plural names for collection objects (e.g. lists, maps)
- at the start of every file, describe in a few lines its main content and functionality
- always use english in code, comments, issues, to keep it professional
- if you wish, include funny comments as easter-eggs for other developers

Note: if using AI to generate code, include the above points in the prompt, hoping it will follow them.
