import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_seringueiro/views/main/chat_room/chat_room_bloc.dart';
import 'package:flutter_seringueiro/views/main/chat_room/chat_room_page.dart';
import 'package:flutter_seringueiro/views/main/home/home_page.dart';
import 'package:flutter_seringueiro/views/main/home/home_page_bloc.dart';
import 'package:flutter_seringueiro/views/main/jotinha/jotinha_bloc.dart';
import 'package:flutter_seringueiro/views/main/jotinha/jotinha_page.dart';

class MainPage extends StatefulWidget {
  final User user;

  MainPage({Key? key, required this.user}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  late List<BlocProvider> _blocProviders;
  String userName = "";

  @override
  void initState() {
    super.initState();
    _blocProviders = [
      BlocProvider<HomePageBloc>(
        create: (context) => HomePageBloc(user: widget.user),
        lazy: false,
      ),
      BlocProvider<JotinhaBloc>(
        create: (context) => JotinhaBloc(user: widget.user),
        lazy: false,
      ),
      BlocProvider<ChatRoomBloc>(
        create: (context) => ChatRoomBloc(user: widget.user),
        lazy: false,
      ),
    ];
    _fetchUserName(); // Chama o método para buscar o nome do usuário
  }

  void _fetchUserName() async {
    try {
      DocumentSnapshot personalInfoDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user.uid)
          .collection('personal_info')
          .doc('info')
          .get();

      if (personalInfoDoc.exists) {
        Map<String, dynamic>? data =
            personalInfoDoc.data() as Map<String, dynamic>?;
        String fullName = data?['nome'] ?? "Usuário";
        List<String> nameParts = fullName.split(" ");
        setState(() {
          userName = nameParts.first;
        });
      }
    } catch (e) {
      print("Erro ao buscar dados do usuário: $e");
      // Lidar com o erro conforme necessário
    }
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return HomePage(user: widget.user);
      case 1:
        return JotinhaPage(user: widget.user);
      case 2:
        return ChatRoomPage(user: widget.user);
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.green.shade900,
          elevation: 5.0,
          shadowColor: Colors.grey.shade900,
          title: Text(
            'Olá, $userName',
            style: TextStyle(color: Colors.white),
          )),
      body: IndexedStack(
        index: _currentIndex,
        children: List.generate(
          _blocProviders.length,
          (index) => _blocProviders[index].child ?? _buildPage(index),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        elevation: 5.0,
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Início',
          ),
          NavigationDestination(
            icon: Icon(Icons.newspaper),
            label: 'Jotinha news',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat),
            label: 'Conversas',
          ),
        ],
      ),
    );
  }
}
