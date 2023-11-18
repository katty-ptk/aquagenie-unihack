import 'package:bluetooth_classic_example/repos/water_tracker.repo.dart';
import 'package:bluetooth_classic_example/screens/profile_screen/profile_screen.provider.dart';
import 'package:bluetooth_classic_example/utils/get_it.util.dart';
import 'package:flutter/cupertino.dart';

class HomeScreenProvider extends ChangeNotifier {
  WaterTracker waterTracker;

  double waterPercentage = 0.0;

  int selectedBottleMillis = 1000;

  HomeScreenProvider(this.waterTracker) {
    waterPercentage = waterTracker.waterPercentage;

    print("required water intake in homescreen is: ${getIt<ProfileScreenProvider>().required_water_intake}");
  }

  onWaterPercentageChange(double newWaterPercentage) {
    if ( newWaterPercentage <= 1 ) {
      waterPercentage = newWaterPercentage;
    } else {
      waterPercentage = 1;
    }

    notifyListeners();
  }

  onSelectedBottlePressed() {
    // onWaterPercentageChange(waterPercentage + selectedBottleMillis.toDouble() / 1000);
    waterTracker.onWaterPercentageChanged(selectedBottleMillis);
    notifyListeners();
  }

  onChangeSelectedBottle(int newSelectedBottleMillis) {
    selectedBottleMillis = newSelectedBottleMillis;
    notifyListeners();
  }
}