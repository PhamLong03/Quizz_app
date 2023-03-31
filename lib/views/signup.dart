import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiz_app/helper/constants.dart';
import 'package:quiz_app/services/auth.dart';
import 'package:quiz_app/services/database.dart';
import 'package:quiz_app/views/home.dart';
import 'package:quiz_app/widget/widget.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  AuthService authService = AuthService();
  DatabaseService databaseService = DatabaseService();
  final _formKey = GlobalKey<FormState>();

  // text feild
  bool _loading = false;
  String email = '', password = '', name = "";

  getInfoAndSignUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loading = true;
      });
      await authService
          .signUpWithEmailAndPassword(email, password)
          .then((value) {
        Map<String, String> userInfo = {
          "id": FirebaseAuth.instance.currentUser!.uid,
          "userName": name,
          "email": email,
        };

        databaseService.addData(
            userInfo, FirebaseAuth.instance.currentUser!.uid);

        Constants.saveUserLoggedInSharedPreference(true);

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home()));
      });
    }
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
        //brightness: Brightness.li,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.only(top: 120),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (val) =>
                            val!.isEmpty ? "Enter an Name" : null,
                        decoration:
                            textInputDecoration.copyWith(hintText: "Name"),
                        onChanged: (val) {
                          name = val;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        validator: (val) =>
                            validateEmail(email) ? null : "Enter correct email",
                        decoration:
                            textInputDecoration.copyWith(hintText: "Email"),
                        onChanged: (val) {
                          email = val;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        obscureText: true,
                        validator: (val) => val!.length < 6
                            ? "Password must be 6+ characters"
                            : null,
                        decoration:
                            textInputDecoration.copyWith(hintText: "Password"),
                        onChanged: (val) {
                          password = val;
                        },
                      ),
                      const SizedBox(height: 24),
                      GestureDetector(
                        onTap: () {
                          getInfoAndSignUp();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 20),
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(5)),
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Already have and account? ',
                              style: TextStyle(
                                  color: Colors.black87, fontSize: 17)),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/signIn', (route) => false);
                            },
                            child: const Text('Sign In',
                                style: TextStyle(
                                    color: Colors.black87,
                                    decoration: TextDecoration.underline,
                                    fontSize: 17)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

bool validateEmail(String value) {
  RegExp regex = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  return (!regex.hasMatch(value)) ? false : true;
}
