import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final Widget? leading;
  final Widget? trailing;
  final Widget? child;
  final double? height;
  final Widget? footer;

  const CustomCard({
    Key? key,
    required this.title,
    this.leading,
    this.trailing,
    this.child,
    this.height,
    this.footer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        height: height, // Adicione a altura aqui, se for fornecida
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.all(16),
              leading: leading ??
                  SizedBox.shrink(), // se leading for null, ocupa espaço zero
              title: Text(title),
              trailing: trailing,
            ),
            if (child != null)
              Expanded(
                child: child!, // O corpo personalizável do cartão
              ),
            if (footer != null) footer!
          ],
        ),
      ),
    );
  }
}
