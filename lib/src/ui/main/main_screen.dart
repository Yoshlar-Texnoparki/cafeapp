import 'package:cafeapp/src/theme/app_colors.dart';
import 'package:cafeapp/src/ui/main/history/order_history.dart';
import 'package:cafeapp/src/ui/main/home/home_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  List<Widget> screens = [HomeScreen(), OrderHistoryScreen()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_selectedIndex],
      backgroundColor: AppColors.background,
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BottomNavigationBar(
          selectedItemColor: AppColors.buttonColor,
          unselectedItemColor: AppColors.grey,
          currentIndex: _selectedIndex,
          onTap: (i) {
            _selectedIndex = i;
            setState(() {});
          },
          backgroundColor: AppColors.inputColor,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Asosiy'),
            // BottomNavigationBarItem(icon: Icon(Icons.cookie), label: 'Taomlar'),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt),
              label: 'Cheklar',
            ),
          ],
        ),
      ),
    );
  }
}
