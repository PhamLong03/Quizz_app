import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/services/auth.dart';
import 'package:quiz_app/services/database.dart';
import 'package:quiz_app/views/create_quiz.dart';
import 'package:quiz_app/views/profile_page.dart';
import 'package:quiz_app/views/quiz_play.dart';
import 'package:quiz_app/views/signin.dart';
import 'package:quiz_app/widget/widget.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Stream? quizStream;
  DatabaseService databaseService = DatabaseService();

  @override
  void initState() {
    databaseService.getQuizData().then((value) {
      quizStream = value;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      drawer: Drawer(
        backgroundColor: Colors.blue.shade100,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50),
          children: [
            Icon(
              Icons.account_circle,
              size: 150,
              color: Colors.grey[700],
            ),
            const SizedBox(height: 10),
            Text(
              "${FirebaseAuth.instance.currentUser!.email}",
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Divider(
              height: 3,
              color: Colors.blue,
              thickness: 1,
            ),
            ListTile(
              onTap: () {},
              selectedColor: Theme.of(context).primaryColor,
              selected: true,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              leading: const Icon(Icons.home),
              title: const Text(
                "Home",
                style: TextStyle(color: Colors.black),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ProfilePage(
                      userName: "Phạm Long", email: "phamhoanganhlong2001"),
                ));
              },
              selectedColor: Theme.of(context).primaryColor,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              leading: const Icon(Icons.group),
              title: const Text(
                "Info",
                style: TextStyle(color: Colors.black),
              ),
            ),
            ListTile(
              onTap: () async {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Log Out"),
                      content: const Text("Are you sure you want to log out?"),
                      actions: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.cancel,
                              color: Colors.red,
                            )),
                        IconButton(
                            onPressed: () {
                              AuthService().signOut().whenComplete(
                                () {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      '/signIn', (route) => false);
                                },
                              );
                            },
                            icon: const Icon(
                              Icons.done,
                              color: Colors.green,
                            )),
                      ],
                    );
                  },
                );
              },
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              leading: const Icon(Icons.exit_to_app),
              title: const Text(
                "Log Out",
                style: TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: AppLogo(),
        elevation: 0.0,
        backgroundColor: Colors.blue.shade200,
      ),
      body: quizList(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CreateQuiz()));
        },
      ),
    );
  }

  Widget quizList() {
    return SingleChildScrollView(
      child: Column(
        children: [
          StreamBuilder(
            stream: quizStream,
            builder: (context, snapshot) {
              return snapshot.data == null
                  ? Container()
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        return QuizTile(
                          noOfQuestions: snapshot.data.docs.length,
                          imageUrl:
                              snapshot.data.docs[index].data()['quizImgUrl'],
                          title: snapshot.data.docs[index].data()['quizTitle'],
                          description:
                              snapshot.data.docs[index].data()['quizDesc'],
                          id: snapshot.data.docs[index].data()['id'],
                        );
                      });
            },
          )
        ],
      ),
    );
  }
}

class QuizTile extends StatelessWidget {
  final String imageUrl, title, id, description;
  final int noOfQuestions;

  QuizTile(
      {super.key,
      required this.title,
      required this.imageUrl,
      required this.description,
      required this.id,
      required this.noOfQuestions});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => QuizPlay(id)));
      },
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 5),
          height: 200,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              children: [
                Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                ),
                Container(
                  color: Colors.black26,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          title,
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          description,
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
