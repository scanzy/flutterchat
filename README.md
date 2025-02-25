# flutterchat

Official chat app for Realmen Branco.<br>
Main objective: provide a cross-platform self-hosted working alternative to Telegram or Keet, for a realmen chat experience.


## Contributing

To access the development environment, visit [gitpod.io](https://gitpod.io/) and create a new account, logging in using GitHub.<br>
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

Note: you may need to edit Gitpod settings to allow you to push your commits from Gitpod to GitHub repositories.<br>
To do so, visit [this settings page](https://gitpod.io/user/integrations) and add permissions `repo` and/or `public_repo` for GitHub.


## Code style

To keep code readable and easy to mantain, follow this rules:
- comment code blocks frequently, explaining
- separate code blocks with single blank lines
- separate methods and classes using double blank lines
- use UpperCamelCase for names of classes, methods and functions
- use lowerCamelCase for names of variables and fields
- use leading _ for private members, avoiding snake_case
- use plural names for collection objects (e.g. lists, maps)
- at the start of every file, describe in a few lines its main content and functionality

Note: if using AI to generate code, include the above points in the prompt, hoping it will follow them.


## Flutter basics

Flutter allows to write Dart code and compile it to different platforms (web, android, ios, linux, windows).

In the repo you can find:
- `lib` directory, where all `.dart` files are located. This is the only important folder to look at.
- platform-specific directories (e.g. `web`, `android`), with automatically generated code.
- `pubspec.yaml` and `pubspec.lock` files, holding information about dart dependencies.
- other misterious files, that I would not edit or delete to avoid breaking something.

Note: when installing new dependencies, make sure to commit changes automatically made by flutter to platform-specific files.

Helpful commands:
- to run the app: `flutter run`, then choose the target for development (recommended: linux)
- to install a new dart dependency: `dart pub add package_name`
- in case the above don't work: `sudo rm -rf /*`


## Dart cheetsheet

TODO
