import 'package:bluetooth_classic_example/providers/device.provider.dart';
import 'package:bluetooth_classic_example/screens/botttom_navbar_scree/bottom_nav_bar.screen.dart';
import 'package:bluetooth_classic_example/screens/device_screen/device.screen.dart';
import 'package:bluetooth_classic_example/screens/login_screen/login.screen.dart';
import 'package:bluetooth_classic_example/screens/splash_screen/splash.screen.dart';
import 'package:bluetooth_classic_example/utils/get_it.util.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupGetIt();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => DeviceProvider()),
      ],
      child: MaterialApp(
            debugShowCheckedModeBanner: false,
            routes: {
              '/': (context) => const SplashScreen(),
              '/splash': (context) => const SplashScreen(),
              '/login': (context) => const LoginScreen(),
              '/bottomNavBar': (context) => const BottomNavigationBarScreen(),
              '/deviceScreen': ( context ) => const DeviceScreen()
            },
            initialRoute: '/splash',
      ),
    );
  }
}
