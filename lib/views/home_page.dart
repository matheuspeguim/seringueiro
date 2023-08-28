import 'package:flutter/material.dart';
import 'package:flutter_seringueiro/widgets/custom_app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<String> titles = [
    "Página Inicial",
    "Mídias sociais",
    "Tarefas",
    "Configurações",
    // Adicione mais títulos para páginas conforme necessário
  ];

  final List<Widget> _children = [
    const Text("Página Inicial"),
    const Text("Social"),
    const Text("Tarefas"),
    const Text("Configurações"),
    // Adicione mais páginas conforme necessário
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
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add),
            label: 'Mídias Sociais',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task),
            label: 'Tarefas',
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
