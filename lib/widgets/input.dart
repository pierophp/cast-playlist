import 'package:luca_play/widgets/custom_typography.dart';
import 'package:flutter/material.dart';

class InputState {
  const InputState(this.code);

  final String code;

  static const InputState normal = InputState("normal");
  static const InputState error = InputState("error");
  static const InputState success = InputState("success");
}

class Input extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? hintText;
  final IconData? icon;
  final TextInputType inputType;
  final bool isPassword;
  final InputState state;
  final FormFieldValidator<String>? validator;

  const Input({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.inputType,
    this.hintText,
    this.icon,
    this.isPassword = false,
    this.state = InputState.normal,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const successBorderColor = Color.fromRGBO(11, 191, 108, 1.0);
    const normalBorderColor = Color.fromRGBO(230, 230, 230, 1.0);
    const errorBorderColor = Color.fromRGBO(255, 74, 74, 1.0);

    var borderColor = normalBorderColor;
    if (this.state == InputState.error) {
      borderColor = errorBorderColor;
    } else if (this.state == InputState.success) {
      borderColor = successBorderColor;
    }

    return TextFormField(
      controller: this.controller,
      keyboardType: this.inputType,
      obscureText: this.isPassword,
      validator: this.validator,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 20.0,
        ),
        focusedBorder: InputBorder.none,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelStyle: TextStyle(
          fontSize: 14.0,
          fontFamily: FontFamily.montserrat,
          fontWeight: FontWeight.bold,
          color: Colors.black,
          height: 1,
        ),
        labelText: this.labelText,
        hintText: this.hintText,
        icon: icon != null ? Icon(this.icon) : null,
        filled: true,
        fillColor: Color.fromRGBO(248, 248, 248, 1.0),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1.0,
            style: BorderStyle.solid,
            color: borderColor,
          ),
        ),
      ),
      style: TextStyle(
        fontSize: 14.0,
        fontFamily: FontFamily.montserrat,
        height: 2,
      ),
    );
  }
}
