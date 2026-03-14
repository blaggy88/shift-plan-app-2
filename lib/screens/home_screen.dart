import 'package:flutter/material.dart';
import 'package:shift_plan_app/screens/rotating_plan_screen.dart';
import 'package:shift_plan_app/screens/standard_plan_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = [
    RotatingPlanScreen(),
    StandardPlanScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schichtplan App'),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Rotierender Plan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'Standardplan',
          ),
        ],
      ),
    );
  }
}