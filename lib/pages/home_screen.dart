import 'package:flutter/material.dart';
import 'package:tf12c_0032_my_personal_expenses_app/pages/expenses_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _listPages = [
    ExpensesPage(),
    Text('Programar'),
    Text('Profile'),
  ];

  var _pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _listPages[_pageIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on),
            label: 'Gastos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: 'Programar Gasto',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
        currentIndex: _pageIndex,
        onTap: (index) {
          setState(() {
            _pageIndex = index;
          });
        },
      ),
    );
  }
}
