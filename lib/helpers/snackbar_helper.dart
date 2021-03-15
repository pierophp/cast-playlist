import 'package:luca_play/main.dart';
import 'package:luca_play/widgets/custom_typography.dart';
import 'package:flutter/material.dart';

class SnackbarHelper {
  static void show({
    required BuildContext context,
    required String text,
    Duration? duration,
    IconData? icon,
  }) {
    final snackbar = SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 0.0,
          vertical: 5.0,
        ),
        child: Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Icon(
              icon != null ? icon : Icons.done,
              color: Colors.white,
            ),
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 0.0,
                ),
                child: CustomTypography(
                  text: text,
                  textAlign: TextAlign.left,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                rootScaffoldMessengerKey?.currentState?.hideCurrentSnackBar(
                  reason: SnackBarClosedReason.hide,
                );
              },
              child: Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      duration: duration != null ? duration : const Duration(seconds: 3),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Colors.white,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
