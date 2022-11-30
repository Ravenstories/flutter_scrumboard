import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_scrumboard/shared/shared.dart';

class LoginWidget extends StatelessWidget {
  LoginWidget({super.key});
  //User login page

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
              onPressed: login,
            ),
          ],
        ),
      );

  Future login() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );
  }
}
