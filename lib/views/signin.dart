import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiz_app/services/auth.dart';
import 'package:quiz_app/widget/widget.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _authService = AuthService();

  TextEditingController emailEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();
  @override
  void initState() {
    emailEditingController;
    passwordEditingController;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: AppBar(
        centerTitle: true,
        title: AppLogo(),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Column(
                children: [
                  const SizedBox(height: 120),
                  TextField(
                    decoration: textInputDecoration.copyWith(
                      hintText: "Email",
                    ),
                    controller: emailEditingController,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    decoration: textInputDecoration.copyWith(
                      hintText: "Password",
                    ),
                    controller: passwordEditingController,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        if (emailEditingController.text.isNotEmpty &&
                            passwordEditingController.text.isNotEmpty) {
                          await AuthService()
                              .signInEmailAndPass(emailEditingController.text,
                                  passwordEditingController.text)
                              .whenComplete(() {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/home', (route) => false);
                          });
                        }
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 20),
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(30)),
                      child: const Text(
                        "Sign In",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Don\'t have an account? ',
                          style:
                              TextStyle(color: Colors.black87, fontSize: 17)),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/signUp', (route) => false);
                        },
                        child: const Text('Sign Up',
                            style: TextStyle(
                                color: Colors.black87,
                                decoration: TextDecoration.underline,
                                fontSize: 17)),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
