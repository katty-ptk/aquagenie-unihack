import 'package:bluetooth_classic_example/screens/device_screen/device.screen.dart';
import 'package:bluetooth_classic_example/screens/home_screen/home.screen.dart';
import 'package:bluetooth_classic_example/screens/profile_screen/profile.screen.dart';
import 'package:bluetooth_classic_example/utils/colors.util.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class BottomNavigationBarScreen extends StatefulWidget {
  const BottomNavigationBarScreen({super.key});

  @override
  State<BottomNavigationBarScreen> createState() => _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen> {
  int _page = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [
      const HomeScreen(),
      const DeviceScreen(),
      const ProfileScreen()
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: 0,
        height: 60.0,
        items: const [
          Icon(Icons.home, size: 30, color: Colors.white,),
          Icon(Icons.devices, size: 30, color: Colors.white,),
          Icon(Icons.person, size: 30, color: Colors.white,),
        ],
        color: AquaGenieColors().deepPurple,
        buttonBackgroundColor: AquaGenieColors().deepPurple,
        backgroundColor: Colors.white,
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
        letIndexChange: (index) => true,
      ),

      body: screens[_page]
    );
  }
}
