import 'package:flutter/material.dart';
import 'pairing_page.dart';
import 'data_receiving_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final title = 'BLE Set Notification';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(
          color: Colors.white,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'Arial',
          ),
          centerTitle: true,
        ),
        textTheme: TextTheme(
          headlineLarge: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.black),
          bodyMedium: TextStyle(fontSize: 18.0, color: Colors.black),
        ),
      ),
      home: HomeScreen(title: title),
    );
  }
}

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static List<Widget> _pages = <Widget>[
    PairingPage(),
    DataReceivingPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.bluetooth),
            label: 'Pairing',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.data_usage),
            label: 'Data',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
