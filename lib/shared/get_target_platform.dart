import 'package:flutter_scrumboard/shared/shared.dart';

///Used for determining which platform the app is running on
///Returns the name of the operating system as a string
///Used by the error log class and the fetch token function in main.dart
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
