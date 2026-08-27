import '../data/mock_animals.dart';
import '../models/animal.dart';

class VaccinationPriority {
  final Animal animal;
  final int priorityScore;
  final String priority;
  final String reason;

  const VaccinationPriority({
    required this.animal,
    required this.priorityScore,
    required this.priority,
    required this.reason,
  });
}

class VaccinationPriorityService {
  VaccinationPriorityService._();

  static final VaccinationPriorityService instance =
      VaccinationPriorityService._();

  List<VaccinationPriority> calculatePriorities() {
    final List<VaccinationPriority> results = [];

    for (final animal in mockAnimals) {
      int score = 0;
      final reasons = <String>[];

      // Vaccination status
      if (animal.vaccinationStatus != 'Up to date') {
        score += 40;
        reasons.add('Vaccination overdue');
      }

      // Current health condition
      if (animal.healthStatus != 'Healthy') {
        score += 30;
        reasons.add('Existing health concern');
      }

      // Disease surveillance / monitored area
      if (animal.location.contains('Nashik')) {
        score += 10;
        reasons.add('Located in monitored area');
      }

      // Determine priority
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
        VaccinationPriority(
          animal: animal,
          priorityScore: score,
          priority: priority,
          reason: reasons.isEmpty
              ? 'No immediate vaccination risk identified'
              : reasons.join(' • '),
        ),
      );
    }

    // Highest priority first
    results.sort(
      (a, b) => b.priorityScore.compareTo(a.priorityScore),
    );

    return results;
  }
}