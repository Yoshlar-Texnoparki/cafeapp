import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cafeapp/src/ui/auth/login_screen.dart';
import 'package:cafeapp/src/ui/main/main_screen.dart';
import 'package:cafeapp/src/utils/cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheService.init();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String token = preferences.getString("token") ?? "";
  runApp(MyApp(token: token));
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
            primaryColor: Colors.orange,
            textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
          ),
          home: child,
        );
      },
      child: token.isEmpty ? const LoginScreen() : MainScreen(),
    );
  }
}

class OrderMonitorScreen extends StatefulWidget {
  final String token;
  const OrderMonitorScreen({super.key, required this.token});

  @override
  _OrderMonitorScreenState createState() => _OrderMonitorScreenState();
}

class _OrderMonitorScreenState extends State<OrderMonitorScreen> {
  WebSocketChannel? _channel;
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _connectWs();
  }

  void _connectWs() {
    final wsUrl = 'wss://cafe.geeks-soft.uz/ws/api/places?token=${widget.token}';

    print("Ulanishga urinish: $wsUrl");

    // IOWebSocketChannel orqali headerlarni qo'shamiz
    _channel = IOWebSocketChannel.connect(
      Uri.parse(wsUrl),
      headers: {
        'Origin': 'https://cafe.geeks-soft.uz', // BRAUZER SIMULYATSIYASI
        'User-Agent': 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X)',
      },
      pingInterval: const Duration(seconds: 20),
    );

    _channel!.ready.then((_) {
      setState(() {
        _isConnected = true;
      });
      print("Muvaffaqiyatli ulanish amalga oshirildi!");
    }).catchError((e) {
      print("Ulanishda xatolik: $e");
      _reconnect();
    });
  }

  void _reconnect() {
    _isConnected = false;
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        print("Qayta ulanishga urinilmoqda...");
        _connectWs();
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Real-time Buyurtmalar"),
        backgroundColor: _isConnected ? Colors.green : Colors.red,
        actions: [
          Icon(_isConnected ? Icons.cloud_done : Icons.cloud_off),
          const SizedBox(width: 15),
        ],
      ),
      body: StreamBuilder(
        stream: _channel?.stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Xatolik: ${snapshot.error}"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData) {
            try {
              final data = jsonDecode(snapshot.data.toString());
              print("Kelgan ma'lumot: $data");

              if (data['event'] == "order_added" || data['event'] == "order_paid") {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.notifications_active, color: Colors.green, size: 80),
                      Text("Voqea: ${data['event']}", style: const TextStyle(color: Colors.black, fontSize: 20)),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text("Ma'lumot: ${data.toString()}", style: const TextStyle(color: Colors.grey)),
                      ),
                    ],
                  ),
                );
              }
            } catch (e) {
              return Center(child: Text("Ma'lumotni o'qishda xato: $snapshot.data"));
            }
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.hourglass_empty, color: Colors.orange, size: 50),
                const SizedBox(height: 10),
                Text(_isConnected ? "Yangi buyurtmalar kutilmoqda..." : "Ulanish uzilgan...",
                    style: const TextStyle(color: Colors.black)),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _channel?.sink.close();
    super.dispose();
  }
}