import 'package:flutter/material.dart';
import 'package:flutter_seringueiro/widgets/custom_card.dart';
import 'package:flutter_seringueiro/widgets/custom_calendar.dart';
import 'package:table_calendar/table_calendar.dart';

import '../widgets/weekly_weather_forecast.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  CalendarFormat _calendarFormat =
      CalendarFormat.week; // Você pode alterar isso conforme necessário

  final List<String> titles = [
    "Página Inicial",
    "Mídias sociais",
    "Conversas",
    "Configurações",
  ];
  @override
  Widget build(BuildContext context) {
    final List<Widget> _children = [
      ListView(
        children: [
          CustomCard(
              title: "Calendário de atividades",
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
              children: [
                WeeklyWeatherForecast(),
                CustomCalendar(
                  calendarFormat: _calendarFormat,
                ),
              ]),
          // adicione outros CustomCards conforme necessário
        ],
      ),
      const Text("Mídias sociais"),
      const Text("Conversas"),
      const Text("Configurações"),
    ];

    return Scaffold(
      backgroundColor: Colors.green.shade900,
      appBar: AppBar(
        title:
            Text(titles[_currentIndex], style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green.shade900,
        centerTitle: true,
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _children,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.green,
        showSelectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Tarefas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Mídias Sociais',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Conversas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configurações',
          ),
        ],
      ),
      floatingActionButton: _getFab(_currentIndex),
    );
  }

  Widget? _getFab(int index) {
    if (index == 0) {
      return FloatingActionButton(
        onPressed: () => print("Nova publicação"),
        child: const Icon(Icons.add),
      );
    } else if (index == 1) {
      return FloatingActionButton(
        onPressed: () => print("Nova Publicação"),
        child: const Icon(Icons.add),
      );
    } else if (index == 2) {
      return FloatingActionButton(
        onPressed: () => print("Nova Sangria"),
        child: const Icon(Icons.add_task),
      );
    } else {
      return null;
    }
  }
}
