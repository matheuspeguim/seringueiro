import 'package:flutter/material.dart';

class PropertyUserBadge extends StatelessWidget {
  final bool isSeringueiro;
  final bool isAgronomo;
  final bool isProprietario;
  final bool isAdministrador;

  const PropertyUserBadge({
    Key? key,
    required this.isSeringueiro,
    required this.isAgronomo,
    required this.isProprietario,
    required this.isAdministrador,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> badges = [];

    if (isSeringueiro) {
      badges.add(_createBadge('SRG', Colors.green, 'Seringueiro'));
    }
    if (isAgronomo) {
      badges.add(_createBadge('AGR', Colors.brown, 'Agrônomo'));
    }
    if (isProprietario) {
      badges.add(_createBadge('PRP', Colors.blue, 'Proprietário'));
    }
    if (isAdministrador) {
      badges.add(_createBadge('ADM', Colors.red, 'Administrador'));
    }

    return Row(mainAxisSize: MainAxisSize.min, children: badges);
  }

  Widget _createBadge(String text, Color color, String tooltipMessage) {
    return Tooltip(
      message: tooltipMessage,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        margin: EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: 10),
        ),
      ),
    );
  }
}
