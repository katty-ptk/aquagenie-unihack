import 'package:bluetooth_classic_example/repos/water_tracker.repo.dart';
import 'package:bluetooth_classic_example/screens/profile_screen/profile_screen.provider.dart';
import 'package:bluetooth_classic_example/utils/get_it.util.dart';
import 'package:flutter/cupertino.dart';

import '../../services/firebase.service.dart';
import 'home.screen.dart';

class HomeScreenProvider extends ChangeNotifier {
  WaterTracker waterTracker;

  double waterPercentage = 0.0;

  int selectedBottleMillis = 1000;

  List<ChartData> chartData = [];

  HomeScreenProvider(this.waterTracker) {
    waterPercentage = waterTracker.waterPercentage;
  }

  onWaterPercentageChange(double newWaterPercentage) {
    if ( newWaterPercentage <= 1 ) {
      waterPercentage = newWaterPercentage;
    } else {
      waterPercentage = 1;
    }

    notifyListeners();
  }

  onSelectedBottlePressed() async {
    waterTracker.onWaterPercentageChanged(selectedBottleMillis);
    await FirebaseService().logWaterToFirestore(selectedBottleMillis);
    var waterTrackingHistory = await FirebaseService().getWaterTrackingHistory();

    if ( waterTrackingHistory != null ) {
      waterTrackingHistory.forEach((key, value) {
        chartData.add(
          ChartData(key, double.parse(value))
        );
      });
    }

    notifyListeners();
  }

  onChangeSelectedBottle(int newSelectedBottleMillis) {
    selectedBottleMillis = newSelectedBottleMillis;
    notifyListeners();
  }
}