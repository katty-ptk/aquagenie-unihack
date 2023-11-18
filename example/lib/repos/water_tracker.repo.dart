import 'package:bluetooth_classic_example/screens/profile_screen/profile_screen.provider.dart';
import 'package:injectable/injectable.dart';

import '../utils/get_it.util.dart';

@Singleton()
class WaterTracker {
  int totalMillis = 0;
  double waterPercentage = 0.0;

  onWaterPercentageChanged(int millis) {
    totalMillis += millis;
    waterPercentage = totalMillis * 100 / getIt<ProfileScreenProvider>().required_water_intake / 100;

    if ( waterPercentage > 1 ) waterPercentage = 1.0;

    print("new water percentage: ${waterPercentage}");
  }
}