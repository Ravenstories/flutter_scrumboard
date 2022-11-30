import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_scrumboard/pages/user_page.dart';

import '../pages/board_page.dart';
import '../pages/error_log_test_page.dart';
import '../pages/login_widget.dart';
import 'shared.dart';
import '../main.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          buildHeader(context),
          buildMenuItem(context),
        ],
      ),
    );
  }
}

Widget buildHeader(BuildContext context) => Container(
      color: Colors.blue,
      padding: EdgeInsets.only(
          top: 24 + MediaQuery.of(context).padding.top, bottom: 24),
      child: InkWell(
        onTap: () => loginDialog(context),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: <Widget>[
              const CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://avatars.githubusercontent.com/u/16825387?s=460&u=3b4b3b4b3b4b3b4b3b4b3b4b3b4b3b4b3b4b3b4b&v=4'),
                radius: 32,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const <Widget>[
                    Text(
                      'UserName',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'UserEmail',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

Widget buildMenuItem(BuildContext context) => Container(
      padding: const EdgeInsets.all(24),
      child: Wrap(runSpacing: 16, children: [
        ListTile(
          leading: const Icon(Icons.home_outlined),
          title: const Text('Home'),
          onTap: () => {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const MyHomePage(title: 'Home'))),
          },
        ),
        const Divider(
          color: Colors.black54,
        ),
        ListTile(
          leading: const Icon(Icons.grid_on_outlined),
          title: const Text('Board'),
          onTap: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const BoardPage())),
        ),
        const Divider(
          color: Colors.black54,
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('Error Log Test'),
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const ErrorLogTestPage())),
        ),
        ListTile(
          leading: const Icon(Icons.account_circle),
          title: const Text('Profile'),
          onTap: () => loginDialog(context),
        ),
      ]),
    );

loginDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: Scaffold(
          body: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: ((context, snapshot) {
                if (snapshot.hasData) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const UserPage()));
                  return Home();
                } else {
                  return LoginWidget();
                }
              }))),
    ),
  );
}
