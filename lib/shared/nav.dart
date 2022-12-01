import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_scrumboard/pages/user_page.dart';
import '../pages/board_page.dart';
import '../pages/error_log_test_page.dart';
import '../pages/login_widget.dart';
import 'shared.dart';
import '../main.dart';

///This class is used for navigating between pages
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

  /// Builds the header of the drawer
  /// Provides the user with the option to login or logout
  /// Placeholder for user profile picture
  Widget buildHeader(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Container(
      color: Colors.blue,
      padding: EdgeInsets.only(
          top: 24 + MediaQuery.of(context).padding.top, bottom: 24),
      child: InkWell(
        onTap: (() => userSignedInCheck(context, 'Profile')),
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
                  children: <Widget>[
                    Text(
                      user?.displayName ?? 'Guest',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user?.email ?? 'Please login',
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 40),
                    if (user != null)
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(30)),
                        icon: const Icon(Icons.logout),
                        label: const Text('Logout'),
                        onPressed: () => {
                          FirebaseAuth.instance.signOut(),
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Home(),
                            ),
                          ),
                        },
                      )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build a menu item.
  /// If [onTap] is not provided, the item will be disabled.
  /// The user needs to be signed in to access any of the features.
  Widget buildMenuItem(BuildContext context) => Container(
        padding: const EdgeInsets.all(24),
        child: Wrap(runSpacing: 16, children: [
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            onTap: (() => userSignedInCheck(context, 'Home')),
          ),
          const Divider(
            color: Colors.black54,
          ),
          ListTile(
            leading: const Icon(Icons.grid_on_outlined),
            title: const Text('Board'),
            onTap: (() => userSignedInCheck(context, 'Board')),
          ),
          const Divider(
            color: Colors.black54,
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Error Log Test'),
            onTap: (() => userSignedInCheck(context, 'ErrorLogTest')),
          ),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('Profile'),
            onTap: (() => userSignedInCheck(context, 'Profile')),
          ),
        ]),
      );

  /// This is a check to see if the user is signed in and if not it opens the login dialog
  /// if the user is signed in it will open the page that was passed in
  userSignedInCheck(context, String? page) {
    if (FirebaseAuth.instance.currentUser != null) {
      switch (page) {
        case 'Board':
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const BoardPage()));
          break;
        case 'ErrorLogTest':
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const ErrorLogTestPage()));
          break;
        case 'Profile':
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const UserPage()));
          break;
        default:
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const MyHomePage(title: 'Home')));
      }
    } else {
      loginDialog(context);
    }
  }

  /// This is the login dialog that will open if the user is not signed in
  loginDialog(BuildContext context) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Scaffold(
              body: StreamBuilder<User?>(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: ((context, snapshot) {
                    return LoginWidget();
                  }))),
        ),
      );
}
