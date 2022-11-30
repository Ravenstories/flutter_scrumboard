import 'package:flutter_scrumboard/shared/shared.dart';

///Get model or operating system name
///Returns the name of the operating system
///Made like this so other parts of the system can find the operating system
class GetTargetPlatform {
  Future<String?> getTargetPlatform() async {
    try {
      if (kIsWeb) {
        return "Web";
      } else {
        if (Platform.isAndroid) {
          return "Android";
        } else if (Platform.isIOS) {
          return "iOS";
        } else if (Platform.isLinux) {
          return "Linux";
        } else if (Platform.isMacOS) {
          return "MacOS";
        } else if (Platform.isWindows) {
          return "Windows";
        }
      }
    } catch (e) {
      ErrorLog saveToErrorlog = ErrorLog();
      saveToErrorlog.saveToErrorlog("getTargetPlatform didn't return a value");
      return 'Error: Failed to get platform version.';
    }
    return null;
  }
}
