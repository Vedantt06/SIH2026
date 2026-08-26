# MahaPashu Suraksha

MahaPashu Suraksha is a Flutter-based prototype for an animal health surveillance and disease-management system. The application provides role-based interfaces for Farmers, Veterinarians/Field Staff, Government users, and Administrators.

> **Current version:** Flutter prototype
> **Status:** Prototype / frontend with mock data
> **Backend:** Not yet integrated in the current prototype

---

## 1. System Roles

The current system contains four login roles:

* **Farmer**
* **Veterinarian / Field Staff**
* **Government**
* **Admin**

Laboratory personnel do not have a separate login in the current system. Laboratory confirmation is represented as part of the overall disease-assessment workflow.

The Government role is designed to support different levels of surveillance and administrative access, including Taluka, District, State, and Disease Surveillance functions.

---

## 2. Technologies Used

* **Flutter:** 3.47.1 (Stable)
* **Dart:** Included with Flutter SDK
* **Android SDK:** 36.0.0
* **Android NDK:** 28.2.13676358
* **Android Studio / Android SDK tools**
* **VS Code** or another Flutter-compatible IDE
* **Git** for version control

The application can also be run using Flutter-supported desktop/web targets where the required development tools are installed.

---

# 3. Prerequisites

Before running the project, install the following:

### Flutter

Install Flutter and make sure the Flutter executable is available in your system PATH.

Verify the installation:

```bash
flutter --version
```

The project was developed and tested using:

```text
Flutter 3.47.1 • stable
```

### Android Development

For running the application on Android, install:

* Android Studio
* Android SDK
* Android SDK Platform 36
* Android SDK Build-Tools
* Android NDK 28.2.13676358
* Android Emulator

Verify your Flutter/Android setup with:

```bash
flutter doctor
```

Resolve any required Android licenses with:

```bash
flutter doctor --android-licenses
```

---

# 4. Clone the Repository

Clone the project from GitHub:

```bash
git clone <REPOSITORY_URL>
```

Move into the Flutter project directory:

```bash
cd MahaPashu-Suraksha
```

> If the repository contains the Flutter project inside another directory, navigate into the directory containing `pubspec.yaml`.

You can verify that you are in the correct directory by checking for:

```text
pubspec.yaml
lib/
android/
ios/
web/
windows/
```

---

# 5. Install Flutter Dependencies

From the project root, run:

```bash
flutter pub get
```

This downloads the dependencies specified in `pubspec.yaml`.

---

# 6. Check Available Devices

Run:

```bash
flutter devices
```

The project can be run on an Android emulator, physical Android device, Chrome, or other supported Flutter targets depending on the installed development environment.

---

# 7. Run the Application

## Android Emulator

Start an Android emulator and verify that it is detected:

```bash
flutter devices
```

Then run:

```bash
flutter run
```

Alternatively, if the Android emulator has a specific device ID:

```bash
flutter run -d emulator-5554
```

The prototype was successfully tested using an Android 15 emulator (API 35).

---

## Chrome

If Chrome is available as a Flutter device:

```bash
flutter run -d chrome
```

---

# 8. Project Structure

The main Flutter application is located inside `lib/`.

```text
lib/
├── core/
│   ├── theme/
│   └── utils/
│
├── data/
│   ├── case_repository.dart
│   ├── mock_animals.dart
│   ├── mock_cases.dart
│   ├── mock_users.dart
│   ├── surveillance_repository.dart
│   └── user_repository.dart
│
├── models/
│   ├── animal.dart
│   ├── health_case.dart
│   └── user.dart
│
├── screens/
│   ├── admin/
│   ├── auth/
│   ├── farmer/
│   ├── gis/
│   ├── government/
│   └── veterinarian/
│
├── widgets/
│
└── main.dart
```

### Important directories

**`lib/models/`**
Contains the core data models such as animals, health cases, and users.

**`lib/data/`**
Contains repositories and mock data currently used by the prototype.

**`lib/screens/`**
Contains the user-interface screens for the different system roles.

**`lib/core/`**
Contains shared application functionality such as theme configuration and utilities.

**`lib/widgets/`**
Contains reusable UI components.

---

# 9. Current Prototype Architecture

The current version primarily uses local/mock data repositories to demonstrate the application's workflows.

Examples include:

```text
mock_animals.dart
mock_cases.dart
mock_users.dart
```

Therefore, a separate production database or backend server is **not required to run the current prototype**.

Backend integration is planned separately.

Refer to:

```text
BACKEND_TODO.md
```

for the current backend-related tasks.

---

# 10. Running After a Fresh Clone

For a new developer, the basic setup is:

```bash
git clone <REPOSITORY_URL>
cd MahaPashu-Suraksha
flutter pub get
flutter devices
flutter run
```

For the Android emulator used during development:

```bash
flutter run -d emulator-5554
```

---

# 11. Troubleshooting

### Flutter command not found

Run:

```bash
flutter --version
```

If the command is not recognized, add the Flutter SDK's `bin` directory to your system PATH.

---

### Check Flutter environment

Run:

```bash
flutter doctor
```

This reports missing Flutter, Android, or development-tool dependencies.

---

### Android license problems

Run:

```bash
flutter doctor --android-licenses
```

Accept the required licenses and then run:

```bash
flutter doctor
```

again.

---

### Dependency problems

Run:

```bash
flutter clean
flutter pub get
```

Then try:

```bash
flutter run
```

---

### No Android device detected

Run:

```bash
flutter devices
```

Start an Android emulator from Android Studio's Device Manager and run the command again.

---

# 12. Development Notes

The current application is a **prototype intended to demonstrate the system workflow and user interfaces**.

The prototype includes role-specific workflows for:

* Animal registration and management
* Health-case reporting
* Veterinary case assessment
* Disease surveillance
* Government dashboards
* GIS-related functionality
* Administrative functionality
* Authentication screens

The system is designed around the principle that AI can provide **decision support**, while veterinarian and laboratory confirmation remains authoritative for diagnosis and treatment decisions.

---

# 13. Future Development

The next stages of development include:

* Backend/API integration
* Persistent database integration
* Production authentication and authorization
* Real-time disease surveillance data
* Laboratory integration
* Production GIS integration
* AI/ML decision-support integration
* Deployment and production configuration

---

## 14. License

This project is currently a prototype developed for the Smart India Hackathon (SIH).

License information can be added when the final project licensing decision is made.
