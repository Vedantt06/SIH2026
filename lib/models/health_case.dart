import 'animal.dart';

enum CaseStatus {
  reported,
  underReview,
  vetAssessment,
  labTesting,
  resultAvailable,
  diagnosisConfirmed,
  treatment,
  closed,
}

enum CaseSeverity {
  low,
  moderate,
  high,
  critical,
}

class HealthCase {
  final String id;
  final Animal animal;
  final List<String> symptoms;
  final String description;
  final CaseSeverity severity;
  final CaseStatus status;
  final String reportedDate;
  final String location;

  final String? vetName;
  final String? diagnosis;
  final String? labTest;
  final String? labSample;
  final String? labResult;
  final String? labInterpretation;
  final String? disease;
  final String? resultDate;

  // AI triage information
  final String? triageRisk;
  final String? triageDisease;
  final String? triageRecommendation;
  final String? triageUrgency;

  const HealthCase({
    required this.id,
    required this.animal,
    required this.symptoms,
    required this.description,
    required this.severity,
    required this.status,
    required this.reportedDate,
    required this.location,
    this.vetName,
    this.diagnosis,
    this.labTest,
    this.labSample,
    this.labResult,
    this.labInterpretation,
    this.disease,
    this.resultDate,

    // AI triage
    this.triageRisk,
    this.triageDisease,
    this.triageRecommendation,
    this.triageUrgency,
  });

  String get statusLabel {
    switch (status) {
      case CaseStatus.reported:
        return 'Reported';
      case CaseStatus.underReview:
        return 'Under Review';
      case CaseStatus.vetAssessment:
        return 'Vet Assessment';
      case CaseStatus.labTesting:
        return 'Lab Testing';
      case CaseStatus.resultAvailable:
        return 'Result Available';
      case CaseStatus.diagnosisConfirmed:
        return 'Diagnosis Confirmed';
      case CaseStatus.treatment:
        return 'Treatment';
      case CaseStatus.closed:
        return 'Closed';
    }
  }

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