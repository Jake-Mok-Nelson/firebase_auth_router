import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final FirebaseAuth firebaseAuth;
  const LoginPage({super.key, required this.firebaseAuth});

  @override
  LoginPageState createState() => LoginPageState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty<FirebaseAuth>('firebaseAuth', firebaseAuth));
  }
}

class LoginPageState extends State<LoginPage> {
  late String email = 'testuser@test.com';
  late String password = 'testuser';

  @override
  Widget build(final BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: Center(
          child: Form(
            autovalidateMode: AutovalidateMode.onUnfocus,
            child: Column(
              children: <Widget>[
                TextFormField(
                  key: const Key('email'),
                  initialValue: email,
                  onChanged: (final String value) {
                    email = value;
                  },
                  validator: (final String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                ),
                TextFormField(
                  key: const Key('password'),
                  initialValue: password,
                  obscureText: true,
                  validator: (final String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                  onChanged: (final String value) {
                    password = value;
                  },
                ),
                ElevatedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: email,
                      password: password,
                    );
                  },
                  child: const Text('Login'),
                ),
              ],
            ),
          ),
        ),
      );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('email', email))
      ..add(StringProperty('password', password));
  }
}
