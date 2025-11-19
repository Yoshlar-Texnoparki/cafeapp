import 'package:cafeapp/src/theme/app_colors.dart';
import 'package:cafeapp/src/ui/main/home/home_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  List<Widget> screens= [
    HomeScreen(),
    Container(),
    Container(),
  ];
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
          onTap: (i){
            _selectedIndex = i;
            setState(() {
            });
          },
          backgroundColor: AppColors.inputColor,
            items: [
          BottomNavigationBarItem(icon: Icon(Icons.home),label: 'main.text1'.tr()),
          BottomNavigationBarItem(icon: Icon(Icons.cookie),label: 'main.text2'.tr()),
          BottomNavigationBarItem(icon: Icon(Icons.receipt),label: 'main.text3'.tr()),
        ]),
      ),
    );
  }
}
