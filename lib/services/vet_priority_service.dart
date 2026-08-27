import '../data/case_repository.dart';
import '../models/health_case.dart';

class VetPriority {
  final HealthCase healthCase;
  final int priorityScore;
  final String priority;
  final String reason;

  const VetPriority({
    required this.healthCase,
    required this.priorityScore,
    required this.priority,
    required this.reason,
  });
}

class VetPriorityService {
  VetPriorityService._();

  static final VetPriorityService instance =
      VetPriorityService._();

  List<VetPriority> calculatePriorities() {
    final cases = CaseRepository.instance.cases;

    final List<VetPriority> results = [];

    for (final healthCase in cases) {
      int score = 0;
      final reasons = <String>[];

      switch (healthCase.severity) {
        case CaseSeverity.critical:
          score += 100;
          reasons.add('Critical severity');
          break;

        case CaseSeverity.high:
          score += 70;
          reasons.add('High severity');
          break;

        case CaseSeverity.moderate:
          score += 40;
          reasons.add('Moderate severity');
          break;

        case CaseSeverity.low:
          score += 15;
          reasons.add('Low severity');
          break;
      }

      if (healthCase.triageUrgency == 'Immediate') {
        score += 30;
        reasons.add('AI triage indicates immediate attention');
      }

      if (healthCase.status == CaseStatus.reported) {
        score += 20;
        reasons.add('Awaiting veterinary assessment');
      }

      String priority;

      if (score >= 100) {
        priority = 'Emergency';
      } else if (score >= 70) {
        priority = 'High';
      } else if (score >= 40) {
        priority = 'Moderate';
      } else {
        priority = 'Low';
      }

      results.add(
        VetPriority(
          healthCase: healthCase,
          priorityScore: score,
          priority: priority,
          reason: reasons.join(' • '),
        ),
      );
    }

    results.sort(
      (a, b) => b.priorityScore.compareTo(a.priorityScore),
    );

    return results;
  }
}