import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_router/src/firebase_auth_router.dart';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'firebase_auth_router_test.mocks.dart';

import 'widgets/home_page.dart';
import 'widgets/loading_widget.dart';
import 'widgets/login_page.dart';

@GenerateMocks([FirebaseAuth, User])
void main() {
  late MockFirebaseAuth firebaseAuth;
  late Widget app;
  late Widget home;
  late Widget login;
  late Widget loading;

  setUpAll(() async {
    firebaseAuth = MockFirebaseAuth();

    home = HomePage(firebaseAuth: firebaseAuth);
    login = LoginPage(firebaseAuth: firebaseAuth);
    loading = const LoadingPage();

    app = MaterialApp(
      home: FirebaseAuthRouter(
        firebaseAuth: firebaseAuth,
        home: home,
        loginPage: login,
        loadingWidget: loading,
      ),
    );
  });

  testWidgets('attempts to load at start', (final WidgetTester tester) async {
    when(firebaseAuth.authStateChanges()).thenAnswer(
      (_) => Stream<User?>.value(null),
    );
    await tester.pumpWidget(app);
    expectLater(find.byWidget(loading), findsOneWidget);
  });

  testWidgets('shows login page when no user',
      (final WidgetTester tester) async {
    when(firebaseAuth.authStateChanges()).thenAnswer(
      (_) => Stream<User?>.value(null),
    );
    await tester.pumpWidget(app);
    await tester.pump();
    expect(find.byWidget(login), findsOneWidget);
  });

  testWidgets('shows home page when user is logged in',
      (final WidgetTester tester) async {
    when(firebaseAuth.authStateChanges()).thenAnswer(
      (_) {
        final User user = MockUser();
        when(user.uid).thenReturn('123');
        return Stream<User?>.value(user);
      },
    );
    await tester.pumpWidget(app);
    await tester.pump();
    expect(find.byWidget(home), findsOneWidget);
  });

  testWidgets('runs onLogin syncronously when user is logged in',
      (final WidgetTester tester) async {
    final User user = MockUser();
    when(user.uid).thenReturn('123');
    when(firebaseAuth.authStateChanges()).thenAnswer(
      (_) => Stream<User?>.value(user),
    );
    void onLogin(final User user) {
      expect(user.uid, '123');
    }

    app = MaterialApp(
      home: FirebaseAuthRouter(
        firebaseAuth: firebaseAuth,
        home: home,
        loginPage: login,
        loadingWidget: loading,
        onLogin: onLogin,
      ),
    );
    await tester.pumpWidget(app);
    await tester.pump();
  });

  testWidgets('runs onLogin asyncronously when user is logged in',
      (final WidgetTester tester) async {
    bool callbackCompleted = false;
    final User user = MockUser();
    when(user.uid).thenReturn('123');
    when(firebaseAuth.authStateChanges()).thenAnswer(
      (_) => Stream<User?>.value(user),
    );
    Future<void> onLogin(final User user) async {
      await Future<void>.delayed(const Duration(milliseconds: 100)).then(
        (_) => {
          callbackCompleted = true,
          expectLater(user.uid, '123'),
        },
      );
    }

    app = MaterialApp(
      home: FirebaseAuthRouter(
        firebaseAuth: firebaseAuth,
        home: home,
        loginPage: login,
        loadingWidget: loading,
        onLogin: onLogin,
      ),
    );
    await tester.pumpWidget(app);
    await tester.pump();

    // Wait for the onLogin function to complete
    await tester.pumpAndSettle(const Duration(milliseconds: 200));
    expect(callbackCompleted, true);
    expect(find.byWidget(home), findsOneWidget);
  });

  testWidgets('does not run onLogin when user is not logged in',
      (final WidgetTester tester) async {
    when(firebaseAuth.authStateChanges()).thenAnswer(
      (_) => Stream<User?>.value(null),
    );
    void onLogin(final User user) {
      fail('onLogin should not be called');
    }

    app = MaterialApp(
      home: FirebaseAuthRouter(
        firebaseAuth: firebaseAuth,
        home: home,
        loginPage: login,
        loadingWidget: loading,
        onLogin: onLogin,
      ),
    );
    await tester.pumpWidget(app);
    await tester.pump();
  });
}
