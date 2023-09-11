import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomCalendar extends StatelessWidget {
  final CalendarFormat calendarFormat;

  CustomCalendar(
      {Key? key, required this.calendarFormat, required Column footer})
      : super(key: key);

  final DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.utc(2020, 10, 16),
      lastDay: DateTime.utc(2030, 3, 14),
      focusedDay: _focusedDay,
      locale: 'pt_BR',
      headerVisible: false,
      availableCalendarFormats: {calendarFormat: ''},
      calendarFormat: calendarFormat,
      calendarStyle: CalendarStyle(
        // Configuração da cor de fundo para verde
        todayDecoration: BoxDecoration(
          color: Color.fromARGB(255, 35, 182, 21),
          shape: BoxShape.circle,
        ),
      ),
      calendarBuilders: CalendarBuilders(
        todayBuilder: (context, date, _) => Container(
          margin: const EdgeInsets.all(4.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 35, 182, 21),
            shape: BoxShape.circle,
          ),
          child: Text(
            '${date.day}',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
