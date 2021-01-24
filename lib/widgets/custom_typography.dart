import 'package:flutter/material.dart';

class FontFamily {
  static const String montserrat = 'Montserrat';
  static const String barlow_condensed = 'Barlow Condensed';
  static const String playfair_display = 'PlayFair Display';
}

class CustomTypography extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final String fontFamily;
  final TextAlign textAlign;
  final TextDecoration decoration;

  const CustomTypography({
    Key key,
    @required this.text,
    this.fontFamily = FontFamily.montserrat,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w400,
    this.color = Colors.black,
    this.textAlign = TextAlign.center,
    this.decoration = TextDecoration.none,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      this.text,
      textAlign: this.textAlign,
      style: TextStyle(
        fontFamily: this.fontFamily,
        fontWeight: this.fontWeight,
        fontSize: this.fontSize,
        color: this.color,
      ),
    );
  }
}
