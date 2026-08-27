
import '../data/mock_cases.dart';

class OutbreakPrediction {
  final String location;
  final String disease;
  final int riskScore;
  final String riskLevel;
  final int recentCases;
  final int historicalCases;
  final int vaccinationCoverage;
  final bool clusterDetected;
  final String trend;
  final String prediction;
  final String recommendation;

  const OutbreakPrediction({
    required this.location,
    required this.disease,
    required this.riskScore,
    required this.riskLevel,
    required this.recentCases,
    required this.historicalCases,
    required this.vaccinationCoverage,
    required this.clusterDetected,
    required this.trend,
    required this.prediction,
    required this.recommendation,
  });
}

class OutbreakPredictionService {
  OutbreakPredictionService._();

  static final OutbreakPredictionService instance =
      OutbreakPredictionService._();

  List<OutbreakPrediction> predictOutbreaks() {
    final results = <OutbreakPrediction>[];

    final districts = <String>[
      'Nashik',
      'Pune',
      'Latur',
      'Nagpur',
    ];

    for (final district in districts) {
      final districtCases = mockCases.where(
        (caseItem) => caseItem.location.contains(district),
      ).toList();

      final recentCases = districtCases.length;

      /*
       * Synthetic historical baseline for prototype demonstration.
       * In the production system this would come from surveillance
       * history stored in the backend.
       */
      final historicalBaseline = _historicalBaseline(district);

      int score = 0;

      // Recent case activity
      if (recentCases >= 5) {
        score += 30;
      } else if (recentCases >= 3) {
        score += 20;
      } else if (recentCases >= 1) {
        score += 10;
      }

      // Historical trend
      final increasing = recentCases > historicalBaseline;

      if (increasing) {
        score += 25;
      }

      // Cluster signal
      final clusterDetected = _clusterDetected(district);

      if (clusterDetected) {
        score += 25;
      }

      // Vaccination coverage
      final coverage = _vaccinationCoverage(district);

      if (coverage < 65) {
        score += 20;
      } else if (coverage < 75) {
        score += 10;
      }

      // Keep score within 100
      if (score > 100) {
        score = 100;
      }

      final riskLevel = _riskLevel(score);

      final disease = _mostLikelyDisease(district);

      final trend = increasing ? 'Increasing' : 'Stable';

      final prediction = _predictionText(
        riskLevel,
        disease,
      );

      final recommendation = _recommendation(
        riskLevel,
        district,
      );

      results.add(
        OutbreakPrediction(
          location: district,
          disease: disease,
          riskScore: score,
          riskLevel: riskLevel,
          recentCases: recentCases,
          historicalCases: historicalBaseline,
          vaccinationCoverage: coverage,
          clusterDetected: clusterDetected,
          trend: trend,
          prediction: prediction,
          recommendation: recommendation,
        ),
      );
    }

    results.sort(
      (a, b) => b.riskScore.compareTo(a.riskScore),
    );

    return results;
  }

  int _historicalBaseline(String district) {
    switch (district) {
      case 'Nashik':
        return 4;
      case 'Pune':
        return 4;
      case 'Latur':
        return 3;
      case 'Nagpur':
        return 5;
      default:
        return 2;
    }
  }

  int _vaccinationCoverage(String district) {
    switch (district) {
      case 'Nashik':
        return 62;
      case 'Latur':
        return 68;
      case 'Pune':
        return 74;
      case 'Nagpur':
        return 82;
      default:
        return 70;
    }
  }

  bool _clusterDetected(String district) {
    if (district == 'Nashik') {
      return true;
    }

    if (district == 'Pune') {
      return true;
    }

    if (district == 'Latur') {
      return true;
    }

    return false;
  }

  String _mostLikelyDisease(String district) {
    if (district == 'Nashik') {
      return 'Foot-and-Mouth Disease';
    }

    if (district == 'Pune') {
      return 'Suspected infectious disease';
    }

    if (district == 'Latur') {
      return 'Suspected livestock disease';
    }

    return 'No dominant disease detected';
  }

  String _riskLevel(int score) {
    if (score >= 70) {
      return 'High';
    }

    if (score >= 45) {
      return 'Moderate';
    }

    return 'Low';
  }

  String _predictionText(
    String riskLevel,
    String disease,
  ) {
    if (riskLevel == 'High') {
      return 'Potential outbreak of $disease detected.';
    }

    if (riskLevel == 'Moderate') {
      return 'Early warning signals detected. Increased surveillance recommended.';
    }

    return 'No immediate outbreak signal detected.';
  }

  String _recommendation(
    String riskLevel,
    String district,
  ) {
    if (riskLevel == 'High') {
      return 'Prioritize field surveillance, vaccination and rapid case investigation in $district.';
    }

    if (riskLevel == 'Moderate') {
      return 'Increase monitoring and verify new cases reported in $district.';
    }

    return 'Continue routine surveillance in $district.';
  }
}