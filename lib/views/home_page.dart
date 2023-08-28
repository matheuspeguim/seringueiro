import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_seringueiro/widgets/custom_app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final List<String> titles = [
    "Página Inicial",
    "Mídias sociais",
    "Conversas",
    "Configurações",
    // Adicione mais títulos para páginas conforme necessário
  ];

  final List<Widget> _children = [
    const Text("Página Inicial"),
    const Text("Social"),
    const Text("Conversas"),
    const Text("Configurações"),
    // Adicione mais páginas conforme necessário
  ];

  @override
  Widget build(BuildContext context) {
    _children[0] = TableCalendar(
      firstDay: DateTime.utc(2022, 1, 1),
      lastDay: DateTime.utc(2031, 12, 31),
      focusedDay: _focusedDay,
      calendarFormat: _calendarFormat,
      selectedDayPredicate: (DateTime day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
      onFormatChanged: (format) {
        setState(() {
          _calendarFormat = format;
        });
      },
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
    );
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
          )
          // Adicione mais itens conforme necessário
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
    } else if (index == 3) {
      // Corrigido o posicionamento deste bloco
      return null;
    } else {
      return null; // ou algum FAB padrão
    }
  }
}
