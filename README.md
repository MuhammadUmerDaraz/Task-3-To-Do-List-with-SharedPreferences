# Task-3-To-Do-List-with-SharedPreferences
#  To-Do List App

A simple yet enhanced To-Do List app built with Flutter, utilizing `SharedPreferences` to store tasks persistently on the device. This app allows users to add, edit, delete, categorize, prioritize, and set due dates for tasks. Completed tasks can be marked and unmarked easily.

## Features
- **Add Tasks**: Add tasks with a name, category, priority level, and optional due date.
- **Edit Tasks**: Update task names via an edit dialog.
- **Delete Tasks**: Remove tasks from the list with a delete button.
- **Mark as Complete**: Toggle tasks as completed or incomplete using a checkbox.
- **Persistent Storage**: Tasks are saved locally with `SharedPreferences` and remain available even after restarting the app.

## Getting Started

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) installed on your machine.
- A compatible IDE such as [Visual Studio Code](https://code.visualstudio.com/) or [Android Studio](https://developer.android.com/studio).

### Installing Dependencies
This project requires `shared_preferences` for local storage and `intl` for date formatting. Add these packages in `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  shared_preferences: ^2.0.15
  intl: ^0.17.0
Then, run:

bash
Copy code
flutter pub get
Running the App
Clone the Repository:

bash
Copy code
git clone <repository_url>
cd <repository_directory>
Run the App:

To run on an Android emulator or iOS simulator:
bash
Copy code
flutter run
To run on a connected device:
bash
Copy code
flutter devices
flutter run -d <device_id>
App Features and Functionality
Persistent Storage
Save Tasks: Each task, including its completion status, category, priority, and optional due date, is saved in SharedPreferences using JSON encoding.
Load Tasks: Upon app launch, tasks are retrieved from SharedPreferences to restore the previous session.
Task Management
Adding Tasks: Use the add button to open a dialog with fields for task name, category, priority, and due date.
Editing Tasks: Tap on a task to open an edit dialog and modify the task name.
Deleting Tasks: Tap the delete icon to remove a task from the list.
Marking as Complete: Tap the checkbox to mark tasks as complete or incomplete.
UI and User Experience
Checkbox for Completion: Each task includes a checkbox to toggle completion status.
Priority and Category Selection: Choose task priority and category for better organization.
Set Due Dates: Option to set a due date for tasks to manage deadlines.
Dependencies
shared_preferences: Stores data locally in a key-value format.
intl: Formats dates in a user-friendly manner.
