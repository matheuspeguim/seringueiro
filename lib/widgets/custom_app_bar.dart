import 'package:flutter/material.dart';
import 'custom_colors.dart'; // Certifique-se de importar o arquivo correto para as cores personalizadas

// Widget de AppBar Personalizada
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const CustomAppBar({Key? key, required this.title, this.actions})
      : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: actions,
      backgroundColor: CustomColors.primaryGreen,
      centerTitle: true,
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 33,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
