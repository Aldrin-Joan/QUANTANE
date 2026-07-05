class HomeSummary {
  HomeSummary({
    required this.totalSpendMonth,
    required this.totalDistanceMonth,
    required this.avgMileageMonth,
  });
  final double totalSpendMonth;
  final double totalDistanceMonth;
  final double avgMileageMonth;
}

class QuickStats {
  QuickStats({
    required this.avgMileage,
    this.avgMileageDeltaPercent,
    required this.totalDistance,
    required this.avgSpeed,
    required this.costPerKm,
  });
  final double avgMileage;
  final double? avgMileageDeltaPercent;
  final double totalDistance;
  final double avgSpeed;
  final double costPerKm;
}

class DailySpend {
  DailySpend({required this.date, required this.amount});
  final DateTime date;
  final double amount;

  String get label => '${date.month}/${date.day}';
}
