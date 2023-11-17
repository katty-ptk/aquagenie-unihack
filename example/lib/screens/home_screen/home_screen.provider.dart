import 'package:flutter/cupertino.dart';

class HomeScreenProvider extends ChangeNotifier {
  double waterPercentage = 0.0;
  int selectedBottleMillis = 1000;


  onWaterPercentageChange(double newWaterPercentage) {
    if ( newWaterPercentage <= 1 ) {
      waterPercentage = newWaterPercentage;
    } else {
      waterPercentage = 1;
    }

    notifyListeners();
  }

  onSelectedBottlePressed() {
    onWaterPercentageChange(waterPercentage + selectedBottleMillis.toDouble() / 1000);
    notifyListeners();
  }

  onChangeSelectedBottle(int newSelectedBottleMillis) {
    selectedBottleMillis = newSelectedBottleMillis;
    notifyListeners();
  }
}