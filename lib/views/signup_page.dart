import 'package:blog_app/viewmodels/auth_viewmodel.dart';
import 'package:blog_app/views/home_page.dart';
import 'package:blog_app/views/signin_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  SignUpPage({super.key});
  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: "Email")),
            const SizedBox(
              height: 10,
            ),
            TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: "Password"),
                obscureText: true),
            const SizedBox(
              height: 10,
            ),
            TextField(
                controller: confirmPasswordController,
                decoration: InputDecoration(labelText: "Confirm Password"),
                obscureText: true),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an Account?",
                    style: TextStyle(color: Colors.grey)),
                TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignInPage()));
                  },
                  child: const Text(
                    'Sign In',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () async {
                await authViewModel.signUp(
                    emailController.text, passwordController.text);
                if (passwordController.text != confirmPasswordController.text) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Please enter your password correctly'),
                    backgroundColor: Colors.red,
                  ));
                  emailController.clear();
                  passwordController.clear();
                  confirmPasswordController.clear();
                  return;
                }
                if (authViewModel.currentUser != null) {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                } else {
                  // Show an error message if login fails
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content:
                        Text('Sign Up failed. Please check your credentials.'),
                    backgroundColor: Colors.red,
                  ));
                  emailController.clear();
                  passwordController.clear();
                  confirmPasswordController.clear();
                  return;
                }
              },
              child: authViewModel.isLoading
                  ? CircularProgressIndicator()
                  : Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}
