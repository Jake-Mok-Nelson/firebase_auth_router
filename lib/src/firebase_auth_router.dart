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
  /// The [errorBuilder] is called when an error occurs during authentication.
  const FirebaseAuthRouter({
    required final FirebaseAuth firebaseAuth,
    required this.home,
    required this.loginPage,
    super.key,
    this.loadingWidget = const Center(child: CircularProgressIndicator()),
    this.onLogin,
    this.onError,
    this.errorBuilder,
  }) : _firebaseAuth = firebaseAuth;

  final FirebaseAuth _firebaseAuth;
  final Widget home;
  final Widget loginPage;
  final Widget loadingWidget;
  final Function(User)? onLogin;

  /// Callback triggered when an error occurs during authentication.
  final Function(Object error)? onError;

  /// Builder function to create a custom error widget.
  ///
  /// If not provided, a default error widget will be shown with a retry button.
  final Widget Function(BuildContext context, Object error)? errorBuilder;

  @override
  Widget build(final BuildContext context) => StreamBuilder<User?>(
        stream: _firebaseAuth.authStateChanges(),
        builder:
            (final BuildContext context, final AsyncSnapshot<User?> snapshot) {
          if (snapshot.hasError) {
            if (onError != null) {
              onError!(snapshot.error!);
            }
            return errorBuilder?.call(context, snapshot.error!) ??
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Authentication Error'),
                      ElevatedButton(
                        onPressed: () {
                          _firebaseAuth.signOut();
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
          }

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
    properties.add(ObjectFlagProperty<Function(User)?>.has('onLogin', onLogin));
    properties
        .add(ObjectFlagProperty<Function(Object)?>.has('onError', onError));
    properties.add(
      ObjectFlagProperty<
          Widget Function(BuildContext context, Object error)?>.has(
        'errorBuilder',
        errorBuilder,
      ),
    );
  }
}
