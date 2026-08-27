class DiseaseTrendPoint {
  final String month;
  final int cases;

  const DiseaseTrendPoint({
    required this.month,
    required this.cases,
  });
}

class DiseaseTrend {
  final String disease;
  final String location;
  final List<DiseaseTrendPoint> points;

  const DiseaseTrend({
    required this.disease,
    required this.location,
    required this.points,
  });

  int get totalCases {
    return points.fold(0, (sum, point) => sum + point.cases);
  }

  int get recentCases {
    if (points.length < 2) {
      return points.isEmpty ? 0 : points.last.cases;
    }

    return points[points.length - 1].cases;
  }

  int get previousCases {
    if (points.length < 2) {
      return 0;
    }

    return points[points.length - 2].cases;
  }

  bool get isIncreasing {
    return recentCases > previousCases;
  }

  String get trendLabel {
    if (recentCases > previousCases) {
      return 'Increasing';
    }

    if (recentCases < previousCases) {
      return 'Decreasing';
    }

    return 'Stable';
  }

  double get growthPercentage {
    if (previousCases == 0) {
      return recentCases > 0 ? 100 : 0;
    }

    return ((recentCases - previousCases) / previousCases) * 100;
  }
}

class DiseaseTrendService {
  DiseaseTrendService._();

  static final DiseaseTrendService instance =
      DiseaseTrendService._();

  List<DiseaseTrend> getHistoricalTrends() {
    return const [
      DiseaseTrend(
        disease: 'Foot-and-Mouth Disease',
        location: 'Nashik',
        points: [
          DiseaseTrendPoint(month: 'Apr', cases: 2),
          DiseaseTrendPoint(month: 'May', cases: 3),
          DiseaseTrendPoint(month: 'Jun', cases: 4),
          DiseaseTrendPoint(month: 'Jul', cases: 6),
          DiseaseTrendPoint(month: 'Aug', cases: 8),
        ],
      ),
      DiseaseTrend(
        disease: 'Suspected Infectious Disease',
        location: 'Pune',
        points: [
          DiseaseTrendPoint(month: 'Apr', cases: 2),
          DiseaseTrendPoint(month: 'May', cases: 2),
          DiseaseTrendPoint(month: 'Jun', cases: 3),
          DiseaseTrendPoint(month: 'Jul', cases: 4),
          DiseaseTrendPoint(month: 'Aug', cases: 5),
        ],
      ),
      DiseaseTrend(
        disease: 'Livestock Respiratory Disease',
        location: 'Latur',
        points: [
          DiseaseTrendPoint(month: 'Apr', cases: 5),
          DiseaseTrendPoint(month: 'May', cases: 4),
          DiseaseTrendPoint(month: 'Jun', cases: 4),
          DiseaseTrendPoint(month: 'Jul', cases: 3),
          DiseaseTrendPoint(month: 'Aug', cases: 3),
        ],
      ),
      DiseaseTrend(
        disease: 'Livestock Disease',
        location: 'Nagpur',
        points: [
          DiseaseTrendPoint(month: 'Apr', cases: 2),
          DiseaseTrendPoint(month: 'May', cases: 3),
          DiseaseTrendPoint(month: 'Jun', cases: 2),
          DiseaseTrendPoint(month: 'Jul', cases: 2),
          DiseaseTrendPoint(month: 'Aug', cases: 2),
        ],
      ),
    ];
  }

  DiseaseTrend? getTrend(String location) {
    for (final trend in getHistoricalTrends()) {
      if (trend.location.toLowerCase() ==
          location.toLowerCase()) {
        return trend;
      }
    }

    return null;
  }
}