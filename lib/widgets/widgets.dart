import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Widgets {
  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Expanded(
              child: Text(message, style: TextStyle(color: Colors.white)),
            ),
            IconButton(
              icon: Icon(Icons.copy, color: Colors.indigoAccent),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: message));

                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Center(
                      child: Text(
                        "Testo copiato!",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    backgroundColor: Colors.grey[850],
                    duration: Duration(seconds: 1),
                    width: 125,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        backgroundColor: Colors.grey[850],
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
