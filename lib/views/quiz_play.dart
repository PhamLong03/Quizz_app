import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/models/question_model.dart';
import 'package:quiz_app/services/database.dart';
import 'package:quiz_app/widget/widget.dart';
import 'package:quiz_app/widgets/quiz_play_widgets.dart';

class QuizPlay extends StatefulWidget {
  final String quizId;
  const QuizPlay(this.quizId, {super.key});

  @override
  _QuizPlayState createState() => _QuizPlayState();
}

int _incorrect = 0;
int _notAttempted = 0;
int total = 0;
int _correct = 0;

List<String> answer = [];
List<String> correctAnswer = [];

/// Stream
Stream? infoStream;

class _QuizPlayState extends State<QuizPlay> {
  late QuerySnapshot questionSnaphot;
  DatabaseService databaseService = DatabaseService();
  bool isLoading = true;
  bool isFinished = false;
  @override
  void initState() {
    databaseService.getQuestionData(quizId: widget.quizId).then((value) {
      questionSnaphot = value;
      _notAttempted = questionSnaphot.docs.length;
      _incorrect = 0;
      _correct = 0;
      isLoading = false;
      isFinished = false;
      total = questionSnaphot.docs.length;
      answer = List.generate(
          questionSnaphot.docs.length, (int index) => index.toString(),
          growable: true);
      correctAnswer = List.generate(
          questionSnaphot.docs.length, (int index) => index.toString(),
          growable: true);
      print(answer.toString());
      setState(() {});
      print("init don $total ${widget.quizId} ");
    });

    if (infoStream == null) {
      infoStream =
          Stream<List<int>>.periodic(const Duration(milliseconds: 100), (x) {
        return [_incorrect];
      });
    }

    super.initState();
  }

  QuestionModel getQuestionModelFromDatasnapshot(
      DocumentSnapshot questionSnapshot) {
    QuestionModel questionModel = QuestionModel();

    questionModel.question = questionSnapshot["question"];

    /// shuffling the options
    List<String> options = [
      questionSnapshot["option1"],
      questionSnapshot["option2"],
      questionSnapshot["option3"],
      questionSnapshot["option4"]
    ];
    options.shuffle();

    questionModel.option1 = options[0];
    questionModel.option2 = options[1];
    questionModel.option3 = options[2];
    questionModel.option4 = options[3];
    questionModel.correctOption = questionSnapshot["option1"];
    print(questionModel.correctOption.toLowerCase());
    return questionModel;
  }

  @override
  void dispose() {
    infoStream = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppLogo(),
        centerTitle: true,
        backgroundColor: Colors.blue.shade200,
        elevation: 0.0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    InfoHeader(
                      length: questionSnaphot.docs.length,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    questionSnaphot.docs.isEmpty
                        ? Container(
                            child: const Center(
                              child: Text("No Data"),
                            ),
                          )
                        : ListView.builder(
                            itemCount: questionSnaphot.docs.length,
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            itemBuilder: (context, index) {
                              print(index);
                              return QuizPlayTile(
                                questionModel: getQuestionModelFromDatasnapshot(
                                    questionSnaphot.docs[index]),
                                index: index,
                              );
                            }),
                    const Divider(thickness: 3),
                    ElevatedButton(
                        onPressed: () {
                          _correct = 0;
                          for (int i = 0; i < answer.length; i++) {
                            if (isNumeric(answer[i]) == true) {
                              isFinished = false;
                            } else {
                              isFinished = true;
                            }
                          }
                          if (isFinished == true) {
                            for (int i = 0; i < correctAnswer.length; i++) {
                              if (correctAnswer[i] == answer[i]) {
                                _correct++;
                              }
                            }
                            print("Hoan thanh bai thi");
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Bạn đã thành bài thi"),
                                  actions: [
                                    IconButton(
                                        onPressed: () {
                                          addResult(_correct, total);
                                          Navigator.of(context)
                                              .pushNamedAndRemoveUntil(
                                                  '/home', (route) => false);
                                        },
                                        icon: const Icon(
                                          Icons.done,
                                          color: Colors.green,
                                        )),
                                  ],
                                );
                              },
                            );
                          } else {
                            print("Chua hoan thanh");
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title:
                                      const Text("Bạn chưa hoàn thành bài thi"),
                                  content: const Text(
                                      "Are you sure you want to log out?"),
                                  actions: [
                                    IconButton(
                                        onPressed: () {
                                          print(FirebaseAuth
                                              .instance.currentUser!.uid);
                                          Navigator.pop(context);
                                        },
                                        icon: const Icon(
                                          Icons.cancel,
                                          color: Colors.red,
                                        )),
                                    IconButton(
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.done,
                                          color: Colors.green,
                                        )),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: Text("Submit"))
                  ],
                ),
              ),
            ),
    );
  }

  addResult(int correct, int total) {
    Map<String, String> result = {
      "id": FirebaseAuth.instance.currentUser!.uid,
      "result": "$correct/$total",
    };
    databaseService.addResult(
        result, FirebaseAuth.instance.currentUser!.uid, widget.quizId);
    print(FirebaseAuth.instance.currentUser!.uid);
  }

  RegExp _numeric = RegExp(r'^-?[0-9]+$');

  bool isNumeric(String str) {
    return _numeric.hasMatch(str);
  }
}

class QuizPlayTile extends StatefulWidget {
  final QuestionModel questionModel;
  final int index;

  const QuizPlayTile(
      {super.key, required this.questionModel, required this.index});

  @override
  _QuizPlayTileState createState() => _QuizPlayTileState();
}

class _QuizPlayTileState extends State<QuizPlayTile> {
  String optionSelected = "";
  bool isChecked1 = false,
      isChecked2 = false,
      isChecked3 = false,
      isChecked4 = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(
            thickness: 2,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Question ${widget.index + 1}: ${widget.questionModel.question}",
              style:
                  TextStyle(fontSize: 18, color: Colors.black.withOpacity(0.8)),
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              if (isChecked1 == false) {
                setState(() {
                  optionSelected = widget.questionModel.option1;
                  correctAnswer.removeAt(widget.index);
                  correctAnswer.insert(
                      widget.index, widget.questionModel.correctOption);
                  answer.removeAt(widget.index);
                  answer.insert(widget.index, widget.questionModel.option1);
                  print(widget.index.toString() + "1: " + answer[widget.index]);
                  _notAttempted = _notAttempted - 1;
                  isChecked1 = true;
                  isChecked2 = false;
                  isChecked3 = false;
                  isChecked4 = false;
                });
              }
            },
            child: OptionTile(
              option: "A",
              description: widget.questionModel.option1,
              optionSelected: optionSelected,
            ),
          ),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: () {
              if (isChecked2 == false) {
                setState(() {
                  optionSelected = widget.questionModel.option2;
                  correctAnswer.removeAt(widget.index);
                  correctAnswer.insert(
                      widget.index, widget.questionModel.correctOption);
                  answer.removeAt(widget.index);
                  answer.insert(widget.index, widget.questionModel.option2);
                  print(widget.index.toString() + "2: " + answer[widget.index]);
                  _notAttempted = _notAttempted - 1;
                  isChecked2 = true;
                  isChecked1 = false;
                  isChecked3 = false;
                  isChecked4 = false;
                });
              }
            },
            child: OptionTile(
              option: "B",
              description: widget.questionModel.option2,
              optionSelected: optionSelected,
            ),
          ),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: () {
              if (isChecked3 == false) {
                setState(() {
                  optionSelected = widget.questionModel.option3;
                  correctAnswer.removeAt(widget.index);
                  correctAnswer.insert(
                      widget.index, widget.questionModel.correctOption);
                  answer.removeAt(widget.index);
                  answer.insert(widget.index, widget.questionModel.option3);
                  print(widget.index.toString() + "3: " + answer[widget.index]);
                  _notAttempted = _notAttempted - 1;
                  isChecked3 = true;
                  isChecked2 = false;
                  isChecked1 = false;
                  isChecked4 = false;
                });
              }
            },
            child: OptionTile(
              option: "C",
              description: widget.questionModel.option3,
              optionSelected: optionSelected,
            ),
          ),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: () {
              if (isChecked4 == false) {
                setState(() {
                  optionSelected = widget.questionModel.option4;
                  correctAnswer.removeAt(widget.index);
                  correctAnswer.insert(
                      widget.index, widget.questionModel.correctOption);
                  answer.removeAt(widget.index);
                  answer.insert(widget.index, widget.questionModel.option4);
                  print(widget.index.toString() + "4: " + answer[widget.index]);
                  _notAttempted = _notAttempted - 1;
                  isChecked4 = true;
                  isChecked2 = false;
                  isChecked3 = false;
                  isChecked1 = false;
                });
              }
            },
            child: OptionTile(
              option: "D",
              description: widget.questionModel.option4,
              optionSelected: optionSelected,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}

class InfoHeader extends StatefulWidget {
  final int length;

  const InfoHeader({super.key, required this.length});

  @override
  _InfoHeaderState createState() => _InfoHeaderState();
}

class _InfoHeaderState extends State<InfoHeader> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: infoStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? Container(
                  height: 40,
                  margin: const EdgeInsets.only(left: 14),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    children: <Widget>[
                      NoOfQuestionTile(
                        text: "Total",
                        number: widget.length,
                      ),
                      NoOfQuestionTile(
                        text: "NotAttempted",
                        number: _notAttempted,
                      ),
                    ],
                  ),
                )
              : Container();
        });
  }
}
