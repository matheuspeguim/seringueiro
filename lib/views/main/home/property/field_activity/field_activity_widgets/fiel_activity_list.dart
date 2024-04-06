import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_seringueiro/common/models/field_activity.dart';
import 'package:flutter_seringueiro/common/models/usuario.dart';
import 'package:flutter_seringueiro/views/main/home/property/field_activity/field_activity_widgets/show_field_activity_details.dart';
import 'package:intl/intl.dart';

class FieldActivityList extends StatefulWidget {
  final String propertyId;
  final DateTime selectedDay;

  FieldActivityList({
    Key? key,
    required this.propertyId,
    required this.selectedDay,
  }) : super(key: key);

  @override
  _FieldActivityListState createState() => _FieldActivityListState();
}

class _FieldActivityListState extends State<FieldActivityList> {
  @override
  void initState() {
    super.initState();
  }

  String formatarHora(DateTime dataHora) {
    final DateFormat formatador = DateFormat('HH:mm'); // Formato 24 horas
    return formatador.format(dataHora);
  }

  Stream<List<FieldActivity>> getFieldActivityList(
      String propertyId, DateTime selectedDay) {
    DateTime normalizedSelectedDay =
        DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
    Timestamp timestampSelectedDayStart =
        Timestamp.fromDate(normalizedSelectedDay);
    Timestamp timestampSelectedDayEnd = Timestamp.fromDate(normalizedSelectedDay
        .add(Duration(days: 1))
        .subtract(Duration(seconds: 1)));

    return FirebaseFirestore.instance
        .collection('field_activities')
        .where('finalizada', isEqualTo: true)
        .where('propertyId', isEqualTo: propertyId)
        .where('inicio', isGreaterThanOrEqualTo: timestampSelectedDayStart)
        .where('inicio', isLessThanOrEqualTo: timestampSelectedDayEnd)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) =>
                FieldActivity.fromMap(doc.data() as Map<String, dynamic>))
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return StreamBuilder<List<FieldActivity>>(
      stream: getFieldActivityList(widget.propertyId, widget.selectedDay),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('Não existem atividades para o dia selecionado.',
              style: theme.textTheme.bodyLarge);
        }

        final activities = snapshot.data!;

        return ListView.builder(
          itemCount: activities.length,
          itemBuilder: (context, index) {
            final activity = activities[index];
            final duration = activity.fim.difference(activity.inicio);

            return ListTile(
              leading: UsuarioIcon(
                usuarioUid: activity.usuarioUid,
              ),
              title:
                  Text(activity.atividade, style: theme.textTheme.titleSmall),
              subtitle: Text(
                "${activity.tabela}\nInício: ${formatarHora(activity.inicio)}\n${duration.inSeconds} segundos",
                style: theme.textTheme.bodySmall,
              ),
              onTap: () {
                FieldActivityDetailsDialog(
                  propertyId: activity.propertyId, // Ajuste conforme necessário
                  fieldActivityId: activity.id!, // Ajuste conforme necessário
                  context: context,
                ).show();
              },
            );
          },
        );
      },
    );
  }
}
