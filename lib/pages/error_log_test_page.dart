import 'package:flutter_scrumboard/shared/shared.dart';

class ErrorLogTestPage extends StatefulWidget {
  const ErrorLogTestPage({super.key});

  @override
  State<ErrorLogTestPage> createState() => _ErrorLogTestPage();
}

class _ErrorLogTestPage extends State<ErrorLogTestPage> {
  ErrorLog errorLog = ErrorLog();

  @override
  void initState() {
    super.initState();
  }

  void _createErrorLog() {
    errorLog.saveToErrorlog("This is a test of the error log");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: const NavigationDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Push the button to create a new error log. \nThis is the error logs that are stored:',
            ),
            const Padding(padding: EdgeInsets.only(bottom: 10)),
            FutureBuilder<String>(
              future: errorLog.readErrorLog(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(snapshot.data!);
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return const CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createErrorLog,
        tooltip: 'Create a new error log',
        child: const Icon(Icons.add),
      ),
    );
  }
}
