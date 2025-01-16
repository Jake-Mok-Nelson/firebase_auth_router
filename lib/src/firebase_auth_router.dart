import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A router widget that handles Firebase Authentication state changes.
///
/// This widget listens to authentication state changes and automatically routes
/// between a login page and home page based on the user's authentication status.
///
/// Example usage:
/// ```dart
/// FirebaseAuthRouter(
///   firebaseAuth: FirebaseAuth.instance,
///   home: const HomePage(),
///   loginPage: const LoginPage(),
///   loadingWidget: const CircularProgressIndicator(),
///   onLogin: (user) {
///     // Perform post-login operations
///     analytics.logLogin();
///   },
/// )
/// ```
class FirebaseAuthRouter extends StatelessWidget {
  /// Creates a Firebase authentication router.
  ///
  /// The [firebaseAuth] instance is required to listen to authentication states.
  /// The [home] widget is displayed when a user is authenticated.
  /// The [loginPage] widget is displayed when no user is authenticated.
  /// The [loadingWidget] is displayed while the authentication state is being determined.
  const FirebaseAuthRouter({
    required final FirebaseAuth firebaseAuth,
    required this.home,
    required this.loginPage,
    required this.loadingWidget,
    super.key,
    this.onLogin,
  }) : _firebaseAuth = firebaseAuth;
  final FirebaseAuth _firebaseAuth;

  /// The widget to display when the user is logged in.
  final Widget home;

  /// The widget to display when the user is logged out.
  final Widget loginPage;

  /// The widget to display while the auth state is loading.
  ///
  /// This widget is shown during the initial load and while checking
  /// authentication state changes.
  final Widget loadingWidget;

  /// Callback triggered after successful authentication.
  ///
  /// This callback provides the authenticated [User] object and is called
  /// before displaying the [home] widget. It can be used for post-login
  /// operations such as analytics tracking or user data initialization.
  final Function(User)? onLogin;

  @override
  Widget build(final BuildContext context) => StreamBuilder<User?>(
        stream: _firebaseAuth.authStateChanges(),
        builder:
            (final BuildContext context, final AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return loadingWidget;
          }
          if (snapshot.hasData && snapshot.data != null) {
            if (onLogin != null) {
              onLogin!(snapshot.data!);
            }
            return home;
          }
          return loginPage;
        },
      );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);

    properties
        .add(ObjectFlagProperty<Function(User p1)?>.has('onLogin', onLogin));
  }
}
