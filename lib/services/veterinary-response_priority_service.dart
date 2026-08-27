import '../models/health_case.dart';
import '../data/case_repository.dart';

class VeterinaryResponsePriority {
  final HealthCase healthCase;
  final int priorityScore;
  final String priority;
  final String reason;

  const VeterinaryResponsePriority({
    required this.healthCase,
    required this.priorityScore,
    required this.priority,
    required this.reason,
  });
}

class VeterinaryResponsePriorityService {
  VeterinaryResponsePriorityService._();

  static final VeterinaryResponsePriorityService instance =
      VeterinaryResponsePriorityService._();

  List<VeterinaryResponsePriority> calculatePriorities() {
    final cases = CaseRepository.instance.cases;
    final results = <VeterinaryResponsePriority>[];

    for (final healthCase in cases) {
      int score = 0;
      final reasons = <String>[];

      // Severity
      switch (healthCase.severity) {
        case CaseSeverity.critical:
          score += 50;
          reasons.add('Critical severity');
          break;

        case CaseSeverity.high:
          score += 40;
          reasons.add('High severity');
          break;

        case CaseSeverity.moderate:
          score += 25;
          reasons.add('Moderate severity');
          break;

        case CaseSeverity.low:
          score += 10;
          break;
      }

      // AI triage risk
      if (healthCase.triageRisk == 'High' ||
          healthCase.triageRisk == 'Critical') {
        score += 30;
        reasons.add('High AI-assessed risk');
      }

      // Active infectious disease
      if (healthCase.disease != null &&
          healthCase.disease!.isNotEmpty) {
        score += 15;
        reasons.add('Disease identified');
      }

      // Cases that still require veterinary attention
      if (healthCase.status == CaseStatus.reported ||
          healthCase.status == CaseStatus.underReview ||
          healthCase.status == CaseStatus.vetAssessment) {
        score += 10;
        reasons.add('Veterinary assessment pending');
      }

      String priority;

      if (score >= 70) {
        priority = 'Critical';
      } else if (score >= 50) {
        priority = 'High';
      } else if (score >= 30) {
        priority = 'Moderate';
      } else {
        priority = 'Low';
      }

      results.add(
        VeterinaryResponsePriority(
          healthCase: healthCase,
          priorityScore: score,
          priority: priority,
          reason: reasons.isEmpty
              ? 'No immediate response priority identified'
              : reasons.join(' • '),
        ),
      );
    }

    results.sort(
      (a, b) => b.priorityScore.compareTo(a.priorityScore),
    );

    return results;
  }
}