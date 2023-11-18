class Gender {
  final int male = 37;
  final int female = 27;
  final int other = 32;
}

class ActivityLevel {
  final double not_active = 0.89;
  final double active = 1;
  final double extremely_active = 1.15;
}

class CalculationUtil {
  double calculateAmountOfWater(int gender, int weight, double activity_level) {
    return gender * weight * activity_level;
  }
}