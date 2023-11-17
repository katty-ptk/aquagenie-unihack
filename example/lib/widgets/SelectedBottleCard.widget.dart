import 'dart:async';
import 'package:flutter/material.dart';

import '../providers/device.provider.dart';
import '../screens/home_screen/home_screen.provider.dart';
import '../utils/get_it.util.dart';

class SelectedBottleSize extends StatefulWidget {
  final HomeScreenProvider state;

  SelectedBottleSize(this.state);

  @override
  _SelectedBottleSizeState createState() => _SelectedBottleSizeState();
}

class _SelectedBottleSizeState extends State<SelectedBottleSize> with TickerProviderStateMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    HomeScreenProvider state = widget.state;

    return GestureDetector(
      onTap: () {
        state.onSelectedBottlePressed();
        print("DEVICE PROFIVER STATUS OS: ${getIt<DeviceProvider>().deviceStatus}");
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          width: 100,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(10),
          ),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                  Icons.water_drop,
                  size: 48,
                  color: Colors.white
              ),

              const SizedBox(height: 10,),

              Text(
                "${state.selectedBottleMillis}ml",
                style: const TextStyle(
                    color: Colors.white54,
                    fontWeight: FontWeight.bold
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
