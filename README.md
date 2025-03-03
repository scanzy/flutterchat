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
- comment code blocks frequently, explaining using simple and concise words
- separate code blocks using single blank lines
- separate methods and classes using double blank lines
- use UpperCamelCase for names of classes, methods and functions
- use lowerCamelCase for names of variables and fields
- use leading _ for private members, avoiding snake_case
- use plural names for collection objects (e.g. lists, maps)
- at the start of every file, describe in a few lines its main content and functionality
- always use english in code, comments, issues, to keep it professional
- if you wish, include funny comments as easter-eggs for other developers

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

## Docker setup

1. **Build and Start the Docker Container**

   Build the Docker image (do it once):

   ```bash
   docker-compose build
   ```

   Start the container in the background (attaching to its logs):

   ```bash
   docker-compose up -d
   ```

2. **(Optional) Add Linux Desktop Support**

   If the `app` folder does not already include a `linux` directory, add Linux desktop support by running:

   ```bash
   docker-compose run --rm flutter flutter create --platforms linux .
   ```

   This command generates the required `linux` folder and configuration files inside your Flutter project.

3. **Run the Flutter App**

   Open a new terminal window and attach to the running container:

   ```bash
   docker-compose exec flutter bash
   ```

   You should now be inside the container, with your project files available in the `/app` directory.

   Inside the container's shell, run:

   ```bash
   flutter run -d linux
   ```

   This command compiles and launches your Flutter Linux desktop app. With [Wayland forwarding configured](https://github.com/ruvido/flutterbox), the app will appear in your Sway session.



## Dart cheetsheet

```dart
// Entry Point
void main() {
  print('Hello, Dart!');
}

// Variables
var name = 'Alice'; // Inferred as String
final age = 30;     // Runtime constant
const PI = 3.14;    // Compile-time constant
dynamic value = 42; // Can change type

// Null Safety
String? nullableName; // Nullable
print(nullableName?.length); // Safe access
print(nullableName!.length); // Assert non-null (caution)

// Type Casting
dynamic value = 'Hello';
String text = value as String; // Explicit cast
print(text); // Output: Hello


// Collections

// List
var numbers = [1, 2, 3];
numbers.add(4);

// Map
var person = {'name': 'Alice', 'age': 30};

// List comprehension-like
var squares = [for (var x in numbers) x * x];


// Cascade Operator ..
var list = []
  ..add(1)
  ..add(2)
  ..add(3);
print(list); // Output: [1, 2, 3]


// Functions with named parameters
void greet({String name = 'Guest', int? age}) {
  print('Hello $name, age ${age ?? 'unknown'}');
}
greet(name: "Francesco", age: 18);

// Arrow functions
int add(int a, int b) => a + b;
print(multiply(3, 4)); // Output: 12

// Anonymus functions
(String message) { print(message); };

// Async/Await
Future<String> fetchData() async {
  return await Future.delayed(Duration(seconds: 2), () => 'Data');
}

void main() async {
  var data = await fetchData();
  print(data); // Output: Data
}


// Classes
class Person {
  String name;
  int age;

  Person(this.name, this.age); // Constructor

  void greet() => print('Hello, $name');
}

var alice = Person('Alice', 30);
alice.greet();
```

## Flutter cheatsheet
1. **`void main()`**: the starting point of the app.
2. **`StatelessWidget`**: base class for static UI elements.
3. **`StatefulWidget`**: base class for UI elements that change dynamically.
4. **`State`**: base class to hold mutable data and manage UI updates.
5. **`setState()`**: to be called to trigger a rebuild of the UI when the state changes.
6. **`build()`**: defines the UI structure (build widgets into this function).

Example:
```dart
// Entry point of the Flutter app
void main() {

  // Starts the app with the root widget (MyApp)
  runApp(MyApp());
}

// StatefulWidget: Allows the UI to change dynamically
class MyApp extends StatefulWidget {

  // Creates the state for this widget
  @override
  _MyAppState createState() => _MyAppState();
}

// State class for MyApp
class _MyAppState extends State<MyApp> {

  // State variable: Holds data that can change
  int _counter = 0;

  // Method to update the state, called by the button
  void _incrementCounter() {

    // setState: Notifies Flutter to rebuild the UI
    // use an anonymus function without parameters
    setState(() {
      _counter++; // Update the state variable
    });
  }

  // method that builds the UI
  // and rebuilds at every state change (don't worry Flutter is optimized for that)
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Flutter Cheatsheet')), // App bar

        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // Display the counter value
              Text('Counter: $_counter'),

              // Button to increment the counter
              ElevatedButton(
                onPressed: _incrementCounter, // Calls _incrementCounter on press
                child: Text('Increment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```
