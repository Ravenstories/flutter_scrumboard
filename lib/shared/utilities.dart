import 'package:fluttertoast/fluttertoast.dart';
import 'shared.dart';

///Utility class for showing toasts
///This is used to show messages to the user
///It is used in the login page and the register page
///I wanted to expand more on this class but I ran out of time
class Utilities {
  static showToast(String message) => Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
}
