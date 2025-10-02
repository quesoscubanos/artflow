import 'package:flutter/material.dart';
import 'package:artflowrise/core/theme/app_theme.dart';
import 'package:artflowrise/features/admin/presentation/pages/admin_dashboard_page.dart';
import 'package:artflowrise/features/admin/presentation/pages/admin_users_page.dart';
import 'package:artflowrise/features/admin/presentation/pages/admin_challenges_page.dart';
import 'package:artflowrise/features/admin/presentation/pages/admin_tutorials_page.dart';
import 'package:artflowrise/features/admin/presentation/pages/admin_profile_page.dart';

class AdminMainNavigationPage extends StatefulWidget {
  const AdminMainNavigationPage({super.key});

  @override
  State<AdminMainNavigationPage> createState() => _AdminMainNavigationPageState();
}

class _AdminMainNavigationPageState extends State<AdminMainNavigationPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const AdminDashboardPage(),
    const AdminUsersPage(),
    const AdminChallengesPage(),
    const AdminTutorialsPage(),
    const AdminProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.lightTheme,
      child: Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: AppTheme.primaryBlue,
          unselectedItemColor: AppTheme.textLight,
          backgroundColor: Colors.white,
          elevation: 8,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outlined),
              activeIcon: Icon(Icons.people),
              label: 'Users',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.emoji_events_outlined),
              activeIcon: Icon(Icons.emoji_events),
              label: 'Challenges',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school_outlined),
              activeIcon: Icon(Icons.school),
              label: 'Tutorials',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outlined),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}