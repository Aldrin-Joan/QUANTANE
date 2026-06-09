class Insight {
  final String title;
  final String description;
  final String emoji;

  Insight({
    required this.title,
    required this.description,
    required this.emoji,
  });
}

class InsightEngine {
  static List<Insight> generateInsights({
    required double currentMileage,
    required double lastMileage,
    required double totalSpend,
  }) {
    final insights = <Insight>[];

    if (currentMileage > lastMileage) {
      final delta = currentMileage - lastMileage;
      insights.add(
        Insight(
          title: 'Mileage Improved',
          description:
              'Your mileage is up by ${delta.toStringAsFixed(1)} KM/L this month!',
          emoji: '🟢',
        ),
      );
    } else if (currentMileage < lastMileage) {
      insights.add(
        Insight(
          title: 'Mileage Dropped',
          description: 'Your mileage decreased. Check your tire pressure.',
          emoji: '⚠️',
        ),
      );
    }

    if (totalSpend > 5000) {
      insights.add(
        Insight(
          title: 'High Spend',
          description: "You've spent over ₹5,000 on fuel this month.",
          emoji: '💸',
        ),
      );
    }

    insights.add(
      Insight(
        title: 'Best Fill',
        description: 'Your last fill at Shell was your most efficient yet!',
        emoji: '🚀',
      ),
    );

    return insights;
  }
}
