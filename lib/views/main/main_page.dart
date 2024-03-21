import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_seringueiro/common/models/usuario.dart';
import 'package:flutter_seringueiro/views/main/seachers/user_seacher/user_seacher_bloc.dart';
import 'package:flutter_seringueiro/views/main/seachers/user_seacher/user_seacher_page.dart';
import 'package:flutter_seringueiro/views/main/seringuia/seringuia_bloc.dart';
import 'package:flutter_seringueiro/views/main/seringuia/seringuia_page.dart';
import 'package:flutter_seringueiro/views/main/home/home_page.dart';
import 'package:flutter_seringueiro/views/main/home/home_page_bloc.dart';
import 'package:flutter_seringueiro/views/main/jotinha/jotinha_bloc.dart';
import 'package:flutter_seringueiro/views/main/jotinha/jotinha_page.dart';
import 'package:flutter_seringueiro/common/widgets/custom_drawer.dart';

class MainPage extends StatefulWidget {
  final User user;

  MainPage({Key? key, required this.user}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  String userName = "";
  Usuario? _currentUser;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _fetchUserData() async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user.uid)
        .get();

    if (userDoc.exists) {
      var userData = userDoc.data() as Map<String, dynamic>;

      // Supondo que a classe Usuario tenha um construtor nomeado adequado
      // que aceita Map<String, dynamic> diretamente.
      Usuario usuario = Usuario.fromMap(userData);

      setState(() {
        // Supondo que a classe Usuario tenha uma propriedade 'nome'
        // e que você deseje extrair o primeiro nome para exibir.
        userName = usuario.nome.split(" ").first;

        // Salve o objeto Usuario completo para uso posterior.
        _currentUser = usuario;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser == null) {
      return Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Olá, $userName',
        ),
      ),
      drawer: CustomDrawer(usuario: _currentUser!),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _currentIndex = index),
        children: [
          BlocProvider(
              create: (_) => HomePageBloc(user: widget.user),
              child: HomePage(user: widget.user)),
          BlocProvider(
            create: (_) => UserSearchBloc(),
            child: UserSearchPage(),
          ),
          BlocProvider(
              create: (_) => JotinhaBloc(user: widget.user),
              child: JotinhaPage(user: widget.user)),
          BlocProvider(
              create: (_) => SeringuiaBloc(user: widget.user),
              child: SeringuiaPage(user: widget.user)),
        ],
      ),
      bottomNavigationBar: _buildNavigationBar(context),
    );
  }

  NavigationBar _buildNavigationBar(context) {
    final theme = Theme.of(context);
    return NavigationBar(
      indicatorColor: theme.colorScheme.primary,
      selectedIndex: _currentIndex,
      onDestinationSelected: (index) => _onDestinationSelected(index),
      destinations: [
        NavigationDestination(
            icon: Icon(Icons.home),
            selectedIcon: Icon(Icons.home),
            label: 'Início'),
        NavigationDestination(
            icon: Icon(Icons.search),
            selectedIcon: Icon(Icons.search),
            label: 'Buscar'),
        NavigationDestination(
            icon: Icon(Icons.newspaper),
            selectedIcon: Icon(Icons.newspaper),
            label: 'Painel'),
        NavigationDestination(
            icon: Icon(Icons.library_books),
            selectedIcon: Icon(Icons.library_books),
            label: 'Seringuia'),
      ],
    );
  }

  void _onDestinationSelected(int index) async {
    setState(() => _currentIndex = index);
    _pageController.animateToPage(index,
        duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }
}
