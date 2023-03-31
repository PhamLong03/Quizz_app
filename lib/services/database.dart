import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  DatabaseService();

  Future<void> addData(userData, String userUid) async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(userUid)
        .set(userData as Map<String, dynamic>)
        .catchError((e) {
      print(e);
    });
  }

  getData() async {
    return await FirebaseFirestore.instance.collection("users").snapshots();
  }

  Future<void> addQuizData(Map quizData, String quizId) async {
    await FirebaseFirestore.instance
        .collection("Quiz")
        .doc(quizId)
        .set(quizData as Map<String, dynamic>)
        .catchError((e) {
      print(e);
    });
  }

  Future<void> addQuestionData(quizData, String quizId) async {
    await FirebaseFirestore.instance
        .collection("Quiz")
        .doc(quizId)
        .collection("QNA")
        .add(quizData)
        .catchError((e) {
      print(e);
    });
  }

  Future<void> addResult(result, String userUid, String quizId) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(userUid)
        .collection("result")
        .doc(quizId)
        .set(result as Map<String, dynamic>)
        .catchError((e) {
      print(e);
    });
  }

  getQuizData() async {
    return FirebaseFirestore.instance.collection("Quiz").snapshots();
  }

  getUserData() async {
    return FirebaseFirestore.instance.collection("users").snapshots();
  }

  getSingleUserData(String userUid) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(userUid)
        .collection("result")
        .snapshots();
  }

  getQuestionData({required String quizId}) async {
    return await FirebaseFirestore.instance
        .collection("Quiz")
        .doc(quizId)
        .collection("QNA")
        .get();
  }
}
