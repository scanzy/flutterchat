# flutterchat

Official chat app for Realmen Community.<br/>
Main objective: provide a cross-platform self-hosted working alternative to Telegram or Keet, for a realmen chat experience.


## Code organization

Documentation:
- `README.md` (this file) with contributing guidelines and code style
- [doc/description.md](doc/description.md) with the description of the app and its functionalities
- [doc/commands.md](doc/commands.md) with useful commands to setup dev env, build and deploy app
- [doc/pocketbase.md](doc/pocketbase.md) with pocketbase database structure description
- [doc/cheatsheet.md](doc/cheatsheet.md) with useful code examples for dart and flutter

User:
- `user/auth.dart` for user authorization and loading screen
- `user/signup.dart` for signup form
- `user/login.dart` for login form
- `user/profile.dart` for user profile page

Rooms:
- `room/list.dart` for all rooms list
- `room/details.dart` for chat room page details

Chat:
- `chat/screen.dart` for chat page with messages list
- `chat/input.dart` for the bottom bar of chat, to send messages
- `chat/msg.dart` for message bubble widget with avatar, and context menu
- `chat/extras.dart` for various widgets like `DateTitle`, `UnreadMessageTitle`, `MessagePreview`

Other:
- `util/constants.dart` for app configuration, like locale and server urls
- `util/style.dart` for app theme colors and style
- `util/pb_service.dart` for pocketbase related functions 
- `util/misc.dart` for other utilities like `navigateToPage`
- `main.dart` for entrypoint and test selection

If you add other files to the project, make sure to update the above list.


## Contributing

To access the development environment, visit [gitpod.io](https://gitpod.io/) and create a new account, logging in using GitHub.<br/>
Install the Gitpod browser extension that shows the "Open in Gitpod" green button on GitHub repositories.

1. **Look at tasks**: visit [this project](https://github.com/users/scanzy/projects/1) to see the board with all issues (development tasks), divided into groups.
2. **Choose priority**: choose one of the issues in the "Next" group (priority) and assign it to yourself.
3. **Investigate** about the task and comment the issue describing how you think to solve the issue.
4. **Create branch** with short but clear name, with issue number at the end (e.g. `action-buttons-9`), separating words with hyphens.
5. **Launch the environment** starting Gitpod on the new branch (this may take some minutes to spin up the cloud-based environment).
6. **Edit code and test it** until the issue is solved, making commits with short but clear description of the edits.
7. **Write updates** for the team into the issue, and push changes to avoid to loose unsaved code.
8. **Close & Pull**: once the new feature is implemented (or the bug solved), close the issue and create a pull request.
9. **Review**: inform the team, so that another developer can review the pull request and accept (or edit) it, merging the branch to main.

Note: you may need to edit Gitpod settings to allow you to push your commits from Gitpod to GitHub repositories.<br/>
To do so, visit [this settings page](https://gitpod.io/user/integrations) and add permissions `repo` and/or `public_repo` for GitHub.

To suggest new features or if you find some bug, visit [this project](https://github.com/users/scanzy/projects/1)
and open an issue using the right template (feature or bug), making sure to include all the relevant information.


## Code style

To keep code readable and easy to mantain, follow this rules:
- comment code blocks frequently, explaining using simple and concise words
- separate code blocks using single blank lines
- separate methods and classes using double blank lines
- use lowerCamelCase for names of variables, fields, methods and functions
- use UpperCamelCase for names of classes and mixins
- use leading _ for private members, avoiding snake_case
- use plural names for collection objects (e.g. lists, maps)
- at the start of every file, describe in a few lines its main content and functionality
- always use english in code, comments, issues, to keep it professional
- if you wish, include funny comments as easter-eggs for other developers

Note: if using AI to generate code, include the above points in the prompt, hoping it will follow them.
