class HomeSummary {
  final double totalSpendMonth;
  final double totalDistanceMonth;
  final double avgMileageMonth;

  HomeSummary({
    required this.totalSpendMonth,
    required this.totalDistanceMonth,
    required this.avgMileageMonth,
  });
}

class QuickStats {
  final double avgMileage;
  final double totalDistance;
  final double avgSpeed;
  final double costPerKm;

  QuickStats({
    required this.avgMileage,
    required this.totalDistance,
    required this.avgSpeed,
    required this.costPerKm,
  });
}
