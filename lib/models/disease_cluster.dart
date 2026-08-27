import 'health_case.dart';

class DiseaseCluster {
  final String id;
  final String location;
  final String disease;
  final int caseCount;
  final int highRiskCases;
  final CaseSeverity severity;
  final List<String> caseIds;

  const DiseaseCluster({
    required this.id,
    required this.location,
    required this.disease,
    required this.caseCount,
    required this.highRiskCases,
    required this.severity,
    required this.caseIds,
  });

  String get severityLabel {
    switch (severity) {
      case CaseSeverity.low:
        return 'Low';
      case CaseSeverity.moderate:
        return 'Moderate';
      case CaseSeverity.high:
        return 'High';
      case CaseSeverity.critical:
        return 'Critical';
    }
  }
}