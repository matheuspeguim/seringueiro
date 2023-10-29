import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final Widget? trailing;

  CustomCard({
    required this.title,
    required this.children,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.lightGreen.shade50,
      child: Column(
        children: [
          ListTile(
            title: Text(title),
            trailing: trailing,
          ),
          Column(
            children: children,
          )
        ],
      ),
    );
  }
}
