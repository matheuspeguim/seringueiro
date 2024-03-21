import 'package:flutter/material.dart';
import 'package:flutter_seringueiro/views/main/home/property/field_activity/field_activity_widgets/fiel_activity_list.dart';
import 'package:table_calendar/table_calendar.dart';

class PropertyCalendar extends StatefulWidget {
  final String propertyId;

  PropertyCalendar({Key? key, required this.propertyId}) : super(key: key);

  @override
  _PropertyCalendarState createState() => _PropertyCalendarState();
}

class _PropertyCalendarState extends State<PropertyCalendar> {
  late DateTime _selectedDay;
  late DateTime _focusedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    // Accessing theme data
    final theme = Theme.of(context);
    return Container(
      height: 600,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: theme.colorScheme.surface,
      ),
      margin: EdgeInsets.all(4),
      child: Column(
        children: [
          Text(
            'Atividades de campo',
            style: theme.textTheme.titleLarge
                ?.copyWith(color: theme.colorScheme.onSurface),
          ),
          TableCalendar(
            firstDay: DateTime.utc(2010, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: CalendarFormat.week,
            availableCalendarFormats: const {
              CalendarFormat.week:
                  'Week', // Inclua apenas o formato que deseja usar
            },
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay; // Update `_focusedDay` here as well
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            // Applying theme to the calendar
            calendarStyle: CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: theme.colorScheme.primary,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: theme.colorScheme.secondary,
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: HeaderStyle(
              formatButtonDecoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(20.0),
              ),
              formatButtonTextStyle:
                  TextStyle(color: theme.colorScheme.onPrimary),
            ),
          ),
          Expanded(
            child: FieldActivityList(
              propertyId: widget.propertyId,
              selectedDay: _selectedDay,
            ),
          ),
        ],
      ),
    );
  }
}
