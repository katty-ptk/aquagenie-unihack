import 'package:bluetooth_classic_example/screens/profile_screen/profile_screen.provider.dart';
import 'package:bluetooth_classic_example/services/firebase.service.dart';
import 'package:injectable/injectable.dart';

import '../screens/home_screen/home.screen.dart';
import '../utils/get_it.util.dart';

@Singleton()
class WaterTracker {
  int totalMillis = 0;
  double waterPercentage = 0.0;

  late List<ChartData> chartData = [];

  getWaterTrackingHistory() async {
    var waterTrackingHistory = await FirebaseService()
        .getWaterTrackingHistory();

    if (waterTrackingHistory != null) {
      waterTrackingHistory.forEach((key, value) {
        chartData.add(
            ChartData(key, double.parse(value))
        );
      });
    }
  }

  onWaterPercentageChanged(int millis) async {
    totalMillis += millis;
    waterPercentage = totalMillis * 100 /
        getIt<ProfileScreenProvider>().required_water_intake / 100;

    if (waterPercentage > 1) waterPercentage = 1.0;

    await getWaterTrackingHistory();

      print("new water percentage: ${waterPercentage}");
    }
  }
