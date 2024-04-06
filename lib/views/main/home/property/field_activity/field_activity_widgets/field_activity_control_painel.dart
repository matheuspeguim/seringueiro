import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_seringueiro/common/models/field_activity.dart';
import 'package:flutter_seringueiro/views/main/home/property/field_activity/field_activity_manager.dart';
import 'package:flutter_seringueiro/views/main/home/property/field_activity/field_activity_widgets/time_elapsed_display.dart';

class FieldActivityControlPanel extends StatefulWidget {
  final String userId;
  final String propertyId;

  const FieldActivityControlPanel({
    Key? key,
    required this.userId,
    required this.propertyId,
  }) : super(key: key);

  @override
  _FieldActivityControlPanelState createState() =>
      _FieldActivityControlPanelState();
}

class _FieldActivityControlPanelState extends State<FieldActivityControlPanel> {
  late FieldActivityManager fieldActivityManager;

  @override
  void initState() {
    super.initState();
    // Inicializa a instância de FieldActivityManager
    fieldActivityManager = FieldActivityManager();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Stream<FieldActivity?> getFieldActivityStream(
      String userId, String propertyId) {
    return FirebaseFirestore.instance
        .collection('field_activities')
        .where('propertyId', isEqualTo: propertyId)
        .where('usuarioUid', isEqualTo: userId)
        .where('finalizada', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.isNotEmpty
            ? FieldActivity.fromMap(
                snapshot.docs.first.data() as Map<String, dynamic>)
            : null);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FieldActivity?>(
      stream: getFieldActivityStream(widget.userId, widget.propertyId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        }

        final activity = snapshot.data;

        if (activity == null) {
          return Container(); // Ou algum placeholder adequado
        }

        // Aqui, você implementa a lógica para exibir o controle da atividade
        // incluindo informações sobre a atividade e botões para ações como pausar ou finalizar
        return Visibility(
          visible: true,
          child: Card(
            color: Theme.of(context)
                .colorScheme
                .surface, // Cor alterada para usar o tema
            margin: const EdgeInsets.all(4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Atividade em andamento',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface), // Estilo customizado baseado no tema
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    '${activity.atividade.toUpperCase()}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface), // Estilo customizado baseado no tema
                  ),
                  Text(
                    '${activity.tabela}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                  SizedBox(height: 12),
                  TimeElapsedDisplay(startTime: activity.inicio),
                  SizedBox(height: 12),
                  LinearProgressIndicator(
                    backgroundColor: Theme.of(context).colorScheme.background,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.primary),
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          // Exibe um AlertDialog para confirmar o cancelamento
                          final bool confirm = await showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text("Cancelar Atividade"),
                                  content: Text(
                                      "Você realmente deseja CANCELAR esta atividade?"),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: Text("Cancelar"),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: Text(
                                        "Confirmar",
                                        style: TextStyle(
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ) ??
                              false; // O '?? false' garante um valor padrão de 'false' caso 'null' seja retornado

                          if (confirm) {
                            // Se confirmado, chama o método para finalizar a atividade
                            // Certifique-se de que você tem uma instância válida de FieldActivityManager e que o método finalizarAtividade está correto
                            await fieldActivityManager.cancelarAtividade(
                              context,
                              activity,
                            ); // Ajuste conforme sua implementação real
                          }
                        },
                        child: Text('Cancelar',
                            style: TextStyle(
                              color: Colors.white,
                            )),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 4,
                        ),
                      ),
                      // Supondo que você tenha uma instância de FieldActivityManager chamada fieldActivityManager no seu widget
                      ElevatedButton(
                        onPressed: () async {
                          // Exibe um AlertDialog para confirmar a finalização
                          final bool confirm = await showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text("Finalizar Atividade"),
                                  content: Text(
                                      "Você realmente deseja finalizar esta atividade?"),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: Text("Cancelar"),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: Text("Confirmar"),
                                    ),
                                  ],
                                ),
                              ) ??
                              false; // O '?? false' garante um valor padrão de 'false' caso 'null' seja retornado

                          if (confirm) {
                            // Se confirmado, chama o método para finalizar a atividade
                            // Certifique-se de que você tem uma instância válida de FieldActivityManager e que o método finalizarAtividade está correto
                            await fieldActivityManager.finalizarAtividade(
                                context,
                                activity); // Ajuste conforme sua implementação real
                          }
                        },
                        child: Text(
                          'Finalizar',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 4,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
