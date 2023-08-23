import 'package:flutter/material.dart';

// Widget de Checkbox Personalizado
class CustomCheckBox extends StatefulWidget {
  final String text;
  const CustomCheckBox({Key? key, required this.text}) : super(key: key);

  @override
  _CustomCheckBoxState createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Checkbox(
          value: isChecked,
          onChanged: (newValue) {
            setState(() {
              isChecked = newValue ?? false;
            });
          },
        ),
        Text(widget.text),
      ],
    );
  }
}
