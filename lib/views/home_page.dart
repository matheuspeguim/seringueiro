// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_seringueiro/widgets/custom_app_bar.dart';
import 'package:table_calendar/table_calendar.dart';
import '../widgets/custom_calendar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<String> titles = [
    "Página Inicial",
    "Mídias sociais",
    "Conversas",
    "Configurações",
  ];

  final List<Widget> _children = [
    CustomCalendar(
      calendarFormat: CalendarFormat.week,
    ),
    const Text("Mídias sociais"),
    const Text("Conversas"),
    const Text("Configurações"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: titles[_currentIndex],
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
