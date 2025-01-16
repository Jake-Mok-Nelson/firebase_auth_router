# Firebase Auth Router

[![Release Test](https://github.com/Jake-Mok-Nelson/firebase_auth_router/actions/workflows/release-test.yml/badge.svg?branch=main)](https://github.com/Jake-Mok-Nelson/firebase_auth_router/actions/workflows/release-test.yml)

![Pub Points](https://img.shields.io/pub/points/firebase_auth_router)



A Flutter widget that handles routing based on Firebase Authentication state. This package automatically navigates between pages based on the user's authentication status.

Demo: [https://jake-mok-nelson.github.io/firebase_auth_router/](https://jake-mok-nelson.github.io/firebase_auth_router/)

## Features

- Automatic routing between authenticated and unauthenticated states
- Customizable loading widget during authentication state changes
- Simple integration with Firebase Auth

## Installation

Add this dependency to your `pubspec.yaml`:

```yaml
dependencies:
  firebase_auth_router: ^1.0.1
```

## Usage

```dart
FirebaseAuthRouter(
  firebaseAuth: FirebaseAuth.instance,
  home: HomePage(),           // Shown when user is authenticated
  loginPage: LoginPage(),     // Shown when user is not authenticated
  loadingWidget: LoadingPage(), // Shown during authentication state changes
)
```

## Example

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FirebaseAuthRouter(
        firebaseAuth: FirebaseAuth.instance,
        home: HomePage(),
        loginPage: LoginPage(),
        loadingWidget: LoadingPage(),
      ),
    );
  }
}
```

## API Reference

### FirebaseAuthRouter

A widget that manages routing based on Firebase Authentication state.

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| `firebaseAuth` | `FirebaseAuth` | Instance of Firebase Authentication |
| `home` | `Widget` | Widget to display when user is authenticated |
| `loginPage` | `Widget` | Widget to display when user is not authenticated |
| `loadingWidget` | `Widget` | Widget to display during authentication state changes |

## Requirements

- Flutter SDK
- Firebase Core
- Firebase Auth

## License

MIT License
