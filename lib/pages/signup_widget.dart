import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_scrumboard/shared/shared.dart';

///Sign up widget
///Allows the user to create an account
///Uses the firebase_auth package
///Uses the email_validator package
class SignUpWidget extends StatelessWidget {
  SignUpWidget({Key? key}) : super(key: key);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Sign Up',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                cursorColor: Colors.black,
                textInputAction: TextInputAction.next,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (email) =>
                    email!.isNotEmpty && EmailValidator.validate(email)
                        ? null
                        : 'Please enter a valid email',
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                cursorColor: Colors.black,
                textInputAction: TextInputAction.done,
                obscureText: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (password) =>
                    password!.isNotEmpty && password.length >= 6
                        ? null
                        : 'Please enter a valid password',
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
                label: const Text('Submit'),
                onPressed: (() => {submitSignUp(context)}),
              ),
            ],
          ),
        ),
      );

  ///Checks if the form is valid
  ///If it is, it creates a new user
  ///If it isn't, it shows an error message in form of a toast
  Future submitSignUp(BuildContext context) async {
    try {
      final isValid = formKey.currentState!.validate();
      if (!isValid) return;
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        // ignore: avoid_print
        print('The password provided is too weak.');
        Utilities.showToast('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        // ignore: avoid_print
        print('An account already exists for that email.');
        Utilities.showToast('An account already exists for that email.');
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }
}
