import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomCalendar extends StatelessWidget {
  final CalendarFormat? calendarFormat;

  CustomCalendar({required this.calendarFormat});

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime firstDay = DateTime(now.year, now.month - 6, now.day);
    DateTime lastDay = DateTime(now.year, now.month + 6, now.day);

    return TableCalendar(
      firstDay: firstDay,
      lastDay: lastDay,
      focusedDay: now,
      calendarFormat: calendarFormat ?? CalendarFormat.month,
      headerVisible: calendarFormat == CalendarFormat.month,
      calendarBuilders: CalendarBuilders(
          todayBuilder: (context, date, events) => Container(
              margin: const EdgeInsets.all(4.0),
              alignment: Alignment.center,
              decoration:
                  BoxDecoration(color: Colors.green, shape: BoxShape.circle),
              child: Text(
                date.day.toString(),
                style: TextStyle(color: Colors.white),
              ))),
    );
  }
}
