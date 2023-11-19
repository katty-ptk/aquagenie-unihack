import 'package:bluetooth_classic_example/services/firebase.service.dart';
import 'package:bluetooth_classic_example/utils/colors.util.dart';
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
      onTap: () async {
        await state.onSelectedBottlePressed();
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          width: 100,
          height: 120,
          decoration: BoxDecoration(
            color: AquaGenieColors().darkBlue,
            borderRadius: BorderRadius.circular(10),
          ),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                  Icons.water_drop_outlined,
                  size: 48,
                  color: Colors.white
              ),

              const SizedBox(height: 10,),

              Text(
                "${state.selectedBottleMillis}ml",
                style: const TextStyle(
                    color: Colors.white,
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
