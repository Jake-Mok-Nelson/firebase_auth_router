import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A widget that listens to user auth changes.
/// When the stream emits a valid user, it displays `home`.
/// When there is no user, it displays `loginPage`.
class FirebaseAuthRouter extends StatelessWidget {
  /// Route between pages based on the user's authentication state.
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
  final Widget loadingWidget;

  /// A callback to run when the user has logged in but before the `home` widget
  /// is displayed.
  /// This is useful for analytics, any app initialization, etc.
  /// You can decide if you want to wait for the callback to complete
  /// before showing the `home` widget.
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
