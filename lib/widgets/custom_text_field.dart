import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final Color textColor;
  final Color hintTextColor;
  final double fontSize;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final AutovalidateMode? autovalidateMode;
  final ValueChanged<String>? onChanged;

  const CustomTextField({
    Key? key,
    required this.hintText,
    this.controller,
    this.textColor = Colors.black,
    this.hintTextColor = Colors.black,
    this.fontSize = 16.0,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.autovalidateMode,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        errorText: validator?.call(controller?.text),
        hintStyle: TextStyle(
          color: hintTextColor,
        ),
      ),
      style: TextStyle(
        color: textColor,
        fontSize: fontSize,
      ),
      autovalidateMode: autovalidateMode,
      validator: validator,
      onChanged: onChanged,
      autofocus: true,
    );
  }
}
