
## Helpful commands

Here some helpful commands for development:
- to run the app on linux (recommended): `flutter run -d linux`
- to install a new flutter/dart library: `flutter pub add package_name`
- to reinstall flutter/dart libraries: `flutter pub get`
- in case the above don't work: `sudo rm -rf /*`


## Development environment setup

### Cloud-based development

To access the cloud development environment, visit [gitpod.io](https://gitpod.io/) and create a new account, logging in using GitHub.<br/>
Install the Gitpod browser extension that shows the "Open in Gitpod" green button on GitHub repositories.

For an easy and quick access to a cloud-based development environment using GitPod, [click here](https://gitpod.io/?autostart=true#https://github.com/scanzy/flutterchat).

Note: you may need to edit Gitpod settings to allow you to push your commits from Gitpod to GitHub repositories.<br/>
To do so, visit [this settings page](https://gitpod.io/user/integrations) and add permissions `repo` and/or `public_repo` for GitHub.

Warning 1: Gitpod provides free access to their environment for a **limited amount of hours**, that reset every month. To avoid consuming your free hours, make sure to stop your development server when not using it, clicking the top-right menu icon, then "Gitpod: Stop Workspace".

Warning 2: after 15 days of inactivity, Gitpod deletes automatically unused development servers. To avoid unsaved data loss (e.g. uncommitted changes, or unpushed commits) you can pin your workspace visiting [this page](https://www.gitpod.io/workspaces).


### Local development

You can use your own local environment using docker,

Following the steps below.


1. Build the Docker image\*:
   ```bash
   docker-compose build
   ```

2. Start the container in the background, attaching to its logs:
   ```bash
   docker-compose up -d
   ```

3. Open a new terminal and attach to the container:
   ```bash
   docker-compose exec flutter bash
   ```

4. Make sure Flutter and its packages are up to date\*:
   ```bash
   flutter upgrade && flutter pub get
   ```

Note: steps marked with (\*) perform the initial setup, so they can be skipped when using an existing environment.


### Linux app

Generate the required Linux files for Flutter \*:
```bash
flutter create --platforms linux . && flutter build linux
```

Start the app:
```bash
flutter run -d linux
```

This command compiles and launches your Flutter Linux desktop app. With [Wayland forwarding configured](https://github.com/ruvido/flutterbox), the app will appear in your Sway session.


### Web app

Generate the required Web files for Flutter \*:

```bash
flutter create --platforms web . && flutter build web
```

Test locally using a web server, on your local console:

```bash
cd build/web
python3 -m http.server 8080
```

Then open `http://localhost:8080` in your browser.
