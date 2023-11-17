import 'dart:async';
import 'package:flutter/material.dart';

import '../screens/home_screen/home_screen.provider.dart';

class SelectedBottleSize extends StatefulWidget {
  final HomeScreenProvider state;

  SelectedBottleSize(this.state);

  @override
  _SelectedBottleSizeState createState() => _SelectedBottleSizeState();
}

class _SelectedBottleSizeState extends State<SelectedBottleSize> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sizeAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000)
    );

    // _sizeAnimation = TweenSequence(
    //   <TweenSequenceItem<double>>[
    //     TweenSequenceItem<double>(
    //         tween: Tween<double>(
    //           begin: 30
    //         ),
    //         weight: weight
    //     )
    //   ];
    // )
  }

  @override
  Widget build(BuildContext context) {
    HomeScreenProvider state = widget.state;

    return GestureDetector(
      onTap: () {
        state.onSelectedBottlePressed();
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
