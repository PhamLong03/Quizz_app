import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/services/database.dart';
import 'package:quiz_app/widget/widget.dart';

class AddQuestion extends StatefulWidget {
  final String quizId;
  final String numOfQuizz;
  const AddQuestion(
      {super.key, required this.quizId, required this.numOfQuizz});

  @override
  _AddQuestionState createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
  DatabaseService databaseService = DatabaseService();
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;
  int num = 1;

  String question = "", option1 = "", option2 = "", option3 = "", option4 = "";

  uploadQuizData() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        num++;
        isLoading = true;
      });

      Map<String, String> questionMap = {
        "question": question,
        "option1": option1,
        "option2": option2,
        "option3": option3,
        "option4": option4
      };

      print("${widget.quizId}");
      databaseService.addQuestionData(questionMap, widget.quizId).then((value) {
        question = "";
        option1 = "";
        option2 = "";
        option3 = "";
        option4 = "";
        setState(() {
          isLoading = false;
        });
      }).catchError((e) {
        print(e);
      });
    } else {
      print("error is happening ");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.black54,
        ),
        title: AppLogo(),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        //brightness: Brightness.li,
      ),
      body: isLoading
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            )
          : Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Text("$num/${widget.numOfQuizz.toString()}"),
                    SizedBox(height: 24),
                    TextFormField(
                      validator: (val) =>
                          val!.isEmpty ? "Enter Question" : null,
                      decoration: InputDecoration(
                        hintText: "Question",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (val) {
                        question = val;
                      },
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      validator: (val) => val!.isEmpty ? "Option1 " : null,
                      decoration: InputDecoration(
                        hintText: "Option1 (Correct Answer)",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (val) {
                        option1 = val;
                      },
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      validator: (val) => val!.isEmpty ? "Option2 " : null,
                      decoration: InputDecoration(
                        hintText: "Option2",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (val) {
                        option2 = val;
                      },
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      validator: (val) => val!.isEmpty ? "Option3 " : null,
                      decoration: InputDecoration(
                        hintText: "Option3",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (val) {
                        option3 = val;
                      },
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      validator: (val) => val!.isEmpty ? "Option4 " : null,
                      decoration: InputDecoration(
                        hintText: "Option4",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (val) {
                        option4 = val;
                      },
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Spacer(),
                    num == int.parse(widget.numOfQuizz)
                        ? GestureDetector(
                            onTap: () async {
                              await uploadQuizData();
                              Navigator.pop(context);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width / 2 - 20,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 20),
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(30)),
                              child: Text(
                                "Submit",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              uploadQuizData();
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width / 2 - 40,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 20),
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(30)),
                              child: Text(
                                "Add Question",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ),
                    SizedBox(
                      height: 60,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
