import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_seringueiro/views/main/seringuia/seringuia_bloc.dart';
import 'package:flutter_seringueiro/views/main/seringuia/seringuia_page.dart';
import 'package:flutter_seringueiro/views/main/home/home_page.dart';
import 'package:flutter_seringueiro/views/main/home/home_page_bloc.dart';
import 'package:flutter_seringueiro/views/main/jotinha/jotinha_bloc.dart';
import 'package:flutter_seringueiro/views/main/jotinha/jotinha_page.dart';
import 'package:flutter_seringueiro/widgets/custom_drawer.dart';
import 'package:vibration/vibration.dart';

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

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  void _fetchUserName() async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user.uid)
        .get();
    if (userDoc.exists) {
      setState(() {
        userName =
            (userDoc.data() as Map<String, dynamic>)['nome'].split(" ").first;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: Colors.green.shade900,
        elevation: 5.0,
        shadowColor: Colors.grey.shade900,
        title:
            Text('Olá, $userName', style: const TextStyle(color: Colors.white)),
      ),
      drawer: CustomDrawer(),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _currentIndex = index),
        children: [
          BlocProvider(
              create: (_) => HomePageBloc(user: widget.user),
              child: HomePage(user: widget.user)),
          BlocProvider(
              create: (_) => JotinhaBloc(user: widget.user),
              child: JotinhaPage(user: widget.user)),
          BlocProvider(
              create: (_) => SeringuiaBloc(user: widget.user),
              child: SeringuiaPage(user: widget.user)),
        ],
      ),
      bottomNavigationBar: _buildNavigationBar(),
    );
  }

  NavigationBar _buildNavigationBar() {
    return NavigationBar(
      backgroundColor: Colors.green.shade100,
      elevation: 5.0,
      shadowColor: Colors.grey.shade900,
      selectedIndex: _currentIndex,
      onDestinationSelected: (index) => _onDestinationSelected(index),
      indicatorColor: Colors.green.shade500,
      destinations: [
        NavigationDestination(
            icon: Icon(Icons.home),
            selectedIcon: Icon(Icons.home, color: Colors.white),
            label: 'Início'),
        NavigationDestination(
            icon: Icon(Icons.newspaper),
            selectedIcon: Icon(Icons.newspaper, color: Colors.white),
            label: 'Jornal Jotinha'),
        NavigationDestination(
            icon: Icon(Icons.library_books),
            selectedIcon: Icon(Icons.library_books, color: Colors.white),
            label: 'Seringuia'),
      ],
    );
  }

  void _onDestinationSelected(int index) async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 50);
    }
    setState(() => _currentIndex = index);
    _pageController.animateToPage(index,
        duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }
}
