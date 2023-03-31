import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/services/database.dart';
import 'package:quiz_app/views/add_question.dart';
import 'package:quiz_app/widget/widget.dart';
import 'package:random_string/random_string.dart';

class CreateQuiz extends StatefulWidget {
  @override
  _CreateQuizState createState() => _CreateQuizState();
}

class _CreateQuizState extends State<CreateQuiz> {
  DatabaseService databaseService = DatabaseService();
  final _formKey = GlobalKey<FormState>();

  late String quizImgUrl, quizTitle, quizDesc, quizId;
  late String numOfQuizz;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: AppBar(
        centerTitle: true,
        leading: BackButton(
          color: Colors.black54,
        ),
        title: AppLogo(),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        //brightness: Brightness.li,
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 5),
              TextFormField(
                validator: (val) =>
                    val!.isEmpty ? "Enter Quiz Image Url" : null,
                decoration: const InputDecoration(
                    hintText: "Quiz Image Url (Optional)"),
                onChanged: (val) {
                  quizImgUrl = val;
                },
              ),
              const SizedBox(height: 5),
              TextFormField(
                validator: (val) => val!.isEmpty ? "Enter Quiz Title" : null,
                decoration: const InputDecoration(hintText: "Quiz Title"),
                onChanged: (val) {
                  quizTitle = val;
                },
              ),
              const SizedBox(height: 5),
              TextFormField(
                validator: (val) =>
                    val!.isEmpty ? "Enter Quiz Description" : null,
                decoration: InputDecoration(hintText: "Quiz Description"),
                onChanged: (val) {
                  quizDesc = val;
                },
              ),
              const SizedBox(height: 5),
              TextFormField(
                validator: (val) =>
                    val!.isEmpty ? "Enter Number of Quizz" : null,
                decoration: InputDecoration(hintText: "Quizz Number"),
                onChanged: (val) {
                  numOfQuizz = val;
                },
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  createQuiz();
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(30)),
                  child: Text(
                    "Create Quiz",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }

  createQuiz() {
    quizId = randomAlphaNumeric(16);
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      Map<String, String> quizData = {
        "id": quizId,
        "quizImgUrl": quizImgUrl,
        "quizTitle": quizTitle,
        "quizDesc": quizDesc,
        "mumOfQuizz": numOfQuizz,
      };

      databaseService.addQuizData(quizData, quizId).then((value) {
        setState(() {
          isLoading = false;
        });
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    AddQuestion(quizId: quizId, numOfQuizz: numOfQuizz)));
      });
    }
  }
}
