import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomCalendar extends StatelessWidget {
  final CalendarFormat calendarFormat;

  CustomCalendar({Key? key, required this.calendarFormat}) : super(key: key);

  final DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendário Personalizado'),
      ),
      body: Container(
        child: TableCalendar(
          firstDay: DateTime.utc(2020, 10, 16),
          lastDay: DateTime.utc(2030, 3, 14),
          focusedDay: _focusedDay,
          locale: 'pt_BR',
          headerVisible: false,
          availableCalendarFormats: {calendarFormat: ''},
          calendarFormat: calendarFormat,
          calendarBuilders: CalendarBuilders(
            todayBuilder: (context, date, _) => Container(
              height: 100, // Reduzindo a altura
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 30, // Reduzindo a altura
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(255, 35, 182, 21),
                    ),
                    child: Center(
                      child: Text(
                        '${date.day}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Container(
                    height: 1, // Reduzindo a altura
                    child: Icon(
                      Icons.wb_sunny,
                      color: Colors.green,
                    ),
                  ),
                  Container(
                    height: 30, // Reduzindo a altura
                    child: Icon(
                      Icons.agriculture,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
