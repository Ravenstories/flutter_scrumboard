import 'package:flutter_scrumboard/shared/shared.dart';
import 'package:path_provider/path_provider.dart';

class ErrorLog {
  GetTargetPlatform targetPlatform = GetTargetPlatform();

  Future<String> get _localPath async {
    Directory directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/errorlog.txt').create(recursive: true);
  }

  Future<File?> saveToErrorlog(String error) async {
    DateTime time = DateTime.now();
    String errorToLog = "$time: $error \n";
    // ignore: avoid_print
    print("Error: $errorToLog");
    // ignore: avoid_print
    print("Error saved to: ${await _localPath}");
    targetPlatform.getTargetPlatform().then((value) async {
      // ignore: avoid_print
      print("$value");
      switch (value) {
        case 'Android':
          final file = await _localFile;
          return file.writeAsString(errorToLog, mode: FileMode.append);
        case 'iOS':
          final file = await _localFile;
          return file.writeAsString(errorToLog, mode: FileMode.append);
        case 'Win32':
          // ignore: avoid_print
          print("Platform not supported");
          return null;
        default:
          return "Platform couldn't be determined";
      }
    });
    return null;
  }

  Future<String> readErrorLog() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return "Couldn't read the errorlog";
    }
  }
}
