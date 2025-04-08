# flutterchat

Official chat app for Realmen Community.<br/>
Main objective: provide a cross-platform self-hosted working alternative to Telegram or Keet, for a realmen chat experience.


## Code organization

Files are divided into these folders:
- [`doc/`](doc/) for app documentation
- [`lib/user/`](lib/user/) for account related code: login, register, profile, pending account, users list view, user tile widget
- [`lib/room/`](lib/room/) for rooms related code: rooms list, room details & settings, create room page, room tile widget
- [`lib/channel/`](lib/channel/) for channel related code: channels list, channel details & settings, create channel page, channel tile widget
- [`lib/dev/`](lib/dev/) for scouting or interactive examples for devs
- [`lib/util/`](lib/util/) for helpers: styles, navigation, translation, services, and shared widgets 

See [`doc/files.md`](doc/files.md) for a complete list of files and their content.
If you add new code files to the project, make sure to update the list.


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
