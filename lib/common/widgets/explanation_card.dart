import 'package:flutter/material.dart';

// Enum para os tipos de mensagem
enum MessageType { explicativo, dica, atencao, alerta }

// Widget Personalizado
class ExplanationCard extends StatelessWidget {
  final String titulo;
  final String explicacao;
  final MessageType tipo;

  ExplanationCard({
    required this.titulo,
    required this.explicacao,
    required this.tipo,
  });

  Color _getBackgroundColor(BuildContext context) {
    var theme = Theme.of(context);
    switch (tipo) {
      case MessageType.explicativo:
        return Colors.blue.shade700.withOpacity(0.2);
      case MessageType.dica:
        return theme.colorScheme.primary.withOpacity(0.2);
      case MessageType.atencao:
        return Colors.yellow.shade700.withOpacity(0.2);
      case MessageType.alerta:
        return theme.colorScheme.error.withOpacity(0.2);
      default:
        return theme.colorScheme.surface;
    }
  }

  Color _getTextColor(BuildContext context) {
    var theme = Theme.of(context);
    switch (tipo) {
      case MessageType.explicativo:
        return Colors.blue.shade800;
      case MessageType.dica:
        return theme.colorScheme.primary;
      case MessageType.atencao:
        return Colors.yellow.shade800;
      case MessageType.alerta:
        return theme.colorScheme.error;
      default:
        return theme.colorScheme.onSurface;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: _getBackgroundColor(context),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: _getTextColor(context),
            ),
          ),
          SizedBox(height: 8),
          Text(
            explicacao,
            style: TextStyle(
              color: _getTextColor(context),
            ),
          ),
        ],
      ),
    );
  }
}
