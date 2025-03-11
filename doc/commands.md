
## Helpful commands

Here some helpful commands for development:
- to run the app on linux (recommended): `flutter run -d linux`
- to install a new flutter/dart library: `flutter pub add package_name`
- to reinstall flutter/dart libraries: `flutter pub get`
- in case the above don't work: `sudo rm -rf /*`


## Development environment setup

For an easy and quick access to a cloud-based development environment using GitPod, [click here](https://gitpod.io/?autostart=true#https://github.com/scanzy/flutterchat).
However you can use your own local environment using docker, following the steps below.


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

---

### Deployment

Built files are in `build/web/` - deploy this directory to any static hosting service:
- GitHub Pages
- Firebase Hosting
- Netlify
- Vercel
