import '../data/case_repository.dart';
import '../models/disease_cluster.dart';
import '../models/health_case.dart';

class ClusterDetectionService {
  ClusterDetectionService._();

  static final ClusterDetectionService instance =
      ClusterDetectionService._();

  List<DiseaseCluster> detectClusters() {
    final cases = CaseRepository.instance.cases;

    final Map<String, List<HealthCase>> groupedCases = {};

    for (final healthCase in cases) {
      final disease =
          healthCase.disease ?? healthCase.triageDisease;

      if (disease == null || disease.isEmpty) {
        continue;
      }

      final key = '$disease|${healthCase.location}';

      groupedCases.putIfAbsent(key, () => []);
      groupedCases[key]!.add(healthCase);
    }

    final List<DiseaseCluster> clusters = [];

    for (final entry in groupedCases.entries) {
      final parts = entry.key.split('|');

      final disease = parts[0];
      final location = parts[1];
      final relatedCases = entry.value;

      final caseCount = relatedCases.length;

      if (caseCount < 2) {
        continue;
      }

      final highRiskCases = relatedCases.where(
        (healthCase) =>
            healthCase.severity == CaseSeverity.high ||
            healthCase.severity == CaseSeverity.critical,
      ).length;

      final CaseSeverity severity;

      if (highRiskCases >= 3 || caseCount >= 5) {
        severity = CaseSeverity.critical;
      } else if (highRiskCases >= 2 || caseCount >= 3) {
        severity = CaseSeverity.high;
      } else {
        severity = CaseSeverity.moderate;
      }

      clusters.add(
        DiseaseCluster(
          id: '$disease-$location',
          location: location,
          disease: disease,
          caseCount: caseCount,
          highRiskCases: highRiskCases,
          severity: severity,
          caseIds: relatedCases.map((item) => item.id).toList(),
        ),
      );
    }

    clusters.sort(
      (a, b) => b.caseCount.compareTo(a.caseCount),
    );

    return clusters;
  }
}