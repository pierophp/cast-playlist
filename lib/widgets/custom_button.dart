import 'package:flutter/material.dart';

enum IconPosition { trailing, leading }

class CustomButton extends StatelessWidget {
  final String? buttonText;
  final void Function() onPressed;
  final Color backgroundColor;
  final Color textColor;
  final bool withBorder;
  final Color borderColor;
  final double fontSize;
  final IconPosition? iconPosition;
  final IconData? icon;
  final bool disabled;
  final bool loading;

  const CustomButton({
    Key? key,
    required this.onPressed,
    this.backgroundColor = Colors.black,
    this.textColor = Colors.white,
    this.buttonText,
    this.withBorder = false,
    this.borderColor = Colors.white,
    this.fontSize = 16.0,
    this.icon,
    this.iconPosition,
    this.disabled = false,
    this.loading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget child = this.icon != null
        ? Column(
            children: [
              Center(
                child: _getIcon(),
              )
            ],
          )
        : Text(this.buttonText ?? "");

    if (this.loading) {
      child = CircularProgressIndicator(
        backgroundColor: Colors.white,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
      );
    }

    return ElevatedButton(
      onPressed: this.disabled ? null : this.onPressed,
      child: child,
      style: ElevatedButton.styleFrom(
        primary: this.backgroundColor,
        onPrimary: textColor,
        minimumSize: Size(double.maxFinite, 60),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(60.0),
        ),
        padding: EdgeInsets.symmetric(vertical: 25),
        side: withBorder
            ? BorderSide(
                color: this.borderColor,
                width: 1.0,
                style: BorderStyle.solid,
              )
            : null,
        textStyle: TextStyle(
          // fontSize: this.fontSize,
          fontSize: this.fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget? _getIcon() {
    if (this.iconPosition == IconPosition.leading) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: this.fontSize,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Text(
              this.buttonText ?? "",
            ),
          ),
        ],
      );
    }

    if (this.iconPosition == IconPosition.trailing) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Text(
              this.buttonText ?? "",
            ),
          ),
          Icon(
            icon,
            size: this.fontSize,
          ),
        ],
      );
    }
  }
}
