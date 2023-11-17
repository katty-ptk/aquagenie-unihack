import 'dart:async';

import 'package:bluetooth_classic_example/providers/auth.provider.dart';
import 'package:bluetooth_classic_example/screens/botttom_navbar_scree/bottom_nav_bar.screen.dart';
import 'package:bluetooth_classic_example/screens/login_screen/login.screen.dart';
import 'package:bluetooth_classic_example/utils/get_it.util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  Widget? screenToLoad;

  late AnimationController _controller;

  bool loaded = false;
  bool isUserSignedIn = false;

  // init state
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _controller.forward();
    loaded = false;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<dynamic> loadData() async {
      await Future.delayed(const Duration(seconds: 2));
      setState(() {
        loaded = true;
      });
    }

    return ChangeNotifierProvider(
      create: (context) {
        return getIt<AuthProvider>();
      },
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return FutureBuilder(
            future: loadData(),
              builder: (BuildContext context, snapshot) {
              if ( !loaded) {
                return Center(
                  child: RotationTransition(
                    turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
                    child: Image.asset('lib/assets/images/cute_robot_face.png'),
                  ),
                );
              } else {
                if ( authProvider.userSignedIn ){
                  return BottomNavigationBarScreen();
                } else {
                  return LoginScreen();
                }
              }
            }
          );
        }
      ),
    );
  }
}
