import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:reminder/features/notes/presentation/pages/notes_page.dart';
import 'package:reminder/features/tasks/presentation/pages/task_list_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const TaskListPage(),
    const NotesPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF12121A).withValues(alpha: 0.8),
          border: const Border(
            top: BorderSide(color: Color(0xFF2D2D3A), width: 0.5),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: Colors.transparent,
          selectedItemColor: const Color(0xFF7C3AED),
          unselectedItemColor: const Color(0xFF9CA3AF),
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.check_circle_outline),
              activeIcon: const Icon(Icons.check_circle),
              label: 'tasks'.tr(),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.note_alt_outlined),
              activeIcon: const Icon(Icons.note_alt),
              label: 'notes'.tr(),
            ),
          ],
        ),
      ),
    );
  }
}
