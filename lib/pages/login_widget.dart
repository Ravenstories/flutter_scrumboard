import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_scrumboard/pages/signup_widget.dart';
import 'package:flutter_scrumboard/shared/shared.dart';

///This class if for signing in the user
///It uses the firebase_auth package
class LoginWidget extends StatelessWidget {
  LoginWidget({Key? key}) : super(key: key);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Login',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              cursorColor: Colors.black,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              cursorColor: Colors.black,
              textInputAction: TextInputAction.done,
              obscureText: true,
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(88, 36),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(2)),
                ),
              ),
              icon: const Icon(Icons.login),
              label: const Text('Login'),
              onPressed: (() => {login(), Navigator.pop(context)}),
            ),
            const SizedBox(height: 30),
            RichText(
              text: TextSpan(
                text: 'Don\'t have an account? ',
                style: const TextStyle(color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Sign up',
                    style: const TextStyle(color: Colors.blue),
                    recognizer: TapGestureRecognizer()
                      ..onTap = (() => signUpDialog(context)),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  ///This function is for signing in the user
  ///It uses: the firebase_auth package, the email and password from the text fields.
  ///It shows a toast if there was and unsuccessful login
  Future login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        // ignore: avoid_print
        print('User couldn\'t be logged in.');
        Utilities.showToast('We couldn\'t log you in. Please try again.');
      } else {
        // ignore: avoid_print
        print('Error: $e');
      }
    }
  }

  ///Displays a dialog for signing up
  ///It uses: the signup_widget.dart
  signUpDialog(BuildContext context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            content: Scaffold(
              body: SignUpWidget(),
            ),
          ));
}
