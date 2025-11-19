import 'package:cafeapp/src/ui/auth/login_screen.dart';
import 'package:cafeapp/src/ui/food/foods_screen.dart';
import 'package:cafeapp/src/ui/main/home/home_screen.dart';
import 'package:cafeapp/src/ui/main/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Cafe App',
          theme: ThemeData(
            primarySwatch: Colors.orange,
            textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
          ),
          home: child,
        );
      },
      child: MainScreen(),
    );
  }
}


