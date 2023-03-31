import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/services/auth.dart';
import 'package:quiz_app/services/database.dart';

class ProfilePage extends StatefulWidget {
  String userName;
  String email;
  ProfilePage({Key? key, required this.userName, required this.email})
      : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Stream? userStream;
  @override
  void initState() {
    DatabaseService().getUserData().then((value) {
      userStream = value;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue.shade200,
        title: const Text(
          "Profile",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 27),
        ),
      ),
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
              widget.userName,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Divider(
              height: 3,
              color: Colors.white,
              thickness: 1,
            ),
            ListTile(
              onTap: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/home', (route) => false);
              },
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              leading: const Icon(Icons.group),
              title: const Text(
                "Groups",
                style: TextStyle(color: Colors.black),
              ),
            ),
            ListTile(
              onTap: () {},
              selectedColor: Theme.of(context).primaryColor,
              selected: true,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              leading: const Icon(Icons.person),
              title: const Text(
                "Profile",
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
                              AuthService().signOut().whenComplete(() {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    '/signIn', (route) => false);
                              });
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
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 120),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.account_circle,
              size: 200,
              color: Colors.grey[700],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Full name",
                  style: TextStyle(fontSize: 17),
                ),
                Text(
                  widget.userName,
                  style: const TextStyle(fontSize: 17),
                ),
              ],
            ),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Email",
                  style: TextStyle(fontSize: 17),
                ),
                Text(
                  widget.email,
                  style: const TextStyle(fontSize: 17),
                ),
              ],
            ),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Quiz",
                  style: TextStyle(fontSize: 17),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Công đoàn Việt Nam : 16/20",
                      style: TextStyle(fontSize: 17),
                    ),
                    Text("New Quiz : 7/10", style: TextStyle(fontSize: 17)),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
