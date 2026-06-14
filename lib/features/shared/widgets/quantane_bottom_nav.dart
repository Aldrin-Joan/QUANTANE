import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:quantane/core/theme/colors.dart';

class QuantaneBottomNav extends StatelessWidget {
  const QuantaneBottomNav({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColors.dividerColor, width: 1),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: navigationShell.currentIndex,
          onTap: (index) => navigationShell.goBranch(index),
          items: [
            const BottomNavigationBarItem(
              icon: Icon(LucideIcons.house),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(LucideIcons.fuel),
              label: 'Fuel',
            ),
            const BottomNavigationBarItem(
              icon: Icon(LucideIcons.route),
              label: 'Trips',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Analytics',
            ),
            const BottomNavigationBarItem(
              icon: Icon(LucideIcons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
