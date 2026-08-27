import '../models/health_case.dart';

class TriageResult {
  final String riskLevel;
  final String possibleDisease;
  final String recommendation;
  final String urgency;

  const TriageResult({
    required this.riskLevel,
    required this.possibleDisease,
    required this.recommendation,
    required this.urgency,
  });
}

class AiTriageService {
  AiTriageService._();

  static TriageResult analyze(HealthCase healthCase) {
    final symptoms = healthCase.symptoms
        .map((symptom) => symptom.toLowerCase())
        .toList();

    final description = healthCase.description.toLowerCase();

    final hasFever = symptoms.contains('fever') ||
        description.contains('fever') ||
        description.contains('ताप');

    final hasSalivation = symptoms.contains('excessive salivation') ||
        description.contains('salivation') ||
        description.contains('लाळ');

    final hasDifficultyWalking =
        symptoms.contains('difficulty walking') ||
            description.contains('difficulty walking') ||
            description.contains('चाल');

    final hasSkinLesions = symptoms.contains('skin lesions') ||
        description.contains('skin lesions') ||
        description.contains('जखम');

    final hasReducedAppetite =
        symptoms.contains('reduced appetite') ||
            description.contains('not eating') ||
            description.contains('reduced appetite');

    // Strong FMD-like symptom combination.
    if (hasFever &&
        (hasSalivation || hasDifficultyWalking)) {
      return const TriageResult(
        riskLevel: 'High Risk',
        possibleDisease: 'Foot-and-Mouth Disease',
        recommendation:
            'Isolate the animal and contact a veterinarian immediately.',
        urgency: 'Immediate',
      );
    }

    // Fever combined with skin lesions.
    if (hasFever && hasSkinLesions) {
      return const TriageResult(
        riskLevel: 'High Risk',
        possibleDisease: 'Possible infectious disease',
        recommendation:
            'Separate the animal from others and arrange veterinary assessment.',
        urgency: 'Urgent',
      );
    }

    // Critical cases always require immediate attention.
    if (healthCase.severity == CaseSeverity.critical) {
      return const TriageResult(
        riskLevel: 'Critical',
        possibleDisease: 'Requires veterinary assessment',
        recommendation:
            'Seek immediate veterinary assistance and isolate the animal if infection is suspected.',
        urgency: 'Immediate',
      );
    }

    // High severity without a specific disease pattern.
    if (healthCase.severity == CaseSeverity.high) {
      return const TriageResult(
        riskLevel: 'High Risk',
        possibleDisease: 'Requires veterinary assessment',
        recommendation:
            'Contact a veterinarian promptly for clinical examination.',
        urgency: 'Urgent',
      );
    }

    // Moderate cases with fever or appetite changes.
    if (healthCase.severity == CaseSeverity.moderate &&
        (hasFever || hasReducedAppetite)) {
      return const TriageResult(
        riskLevel: 'Moderate Risk',
        possibleDisease: 'Possible illness',
        recommendation:
            'Monitor the animal closely and arrange veterinary assessment.',
        urgency: 'Within 24 hours',
      );
    }

    // Low-risk fallback.
    return const TriageResult(
      riskLevel: 'Low Risk',
      possibleDisease: 'No specific disease pattern detected',
      recommendation:
          'Continue monitoring the animal and consult a veterinarian if symptoms worsen.',
      urgency: 'Routine',
    );
  }
}