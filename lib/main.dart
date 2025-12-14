import 'package:cafeapp/src/ui/auth/login_screen.dart';
import 'package:cafeapp/src/ui/food/foods_screen.dart';
import 'package:cafeapp/src/ui/main/home/home_screen.dart';
import 'package:cafeapp/src/ui/main/main_screen.dart';
import 'package:cafeapp/src/utils/cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  CacheService.init();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String token =  preferences.getString("token")??"";
  runApp( MyApp(token: token,));
}

class MyApp extends StatelessWidget {
  final String token;
  const MyApp({super.key, required this.token});

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
            platform: TargetPlatform.iOS,
            primarySwatch: Colors.orange,
            textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
          ),
          home: child,
        );
      },
      child:token.isEmpty?LoginScreen():MainScreen(),
    );
  }
}


