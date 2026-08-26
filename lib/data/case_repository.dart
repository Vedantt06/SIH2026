import '../models/health_case.dart';
import 'mock_cases.dart';

class CaseRepository {
  CaseRepository._();

  static final CaseRepository instance = CaseRepository._();

  final List<HealthCase> _cases = List<HealthCase>.from(mockCases);

  List<HealthCase> get cases => List.unmodifiable(_cases);

  void addCase(HealthCase healthCase) {
    _cases.insert(0, healthCase);
  }

  void updateCase(HealthCase updatedCase) {
    final index = _cases.indexWhere(
      (item) => item.id == updatedCase.id,
    );

    if (index != -1) {
      _cases[index] = updatedCase;
    }
  }

  HealthCase? findCase(String id) {
    for (final healthCase in _cases) {
      if (healthCase.id == id) {
        return healthCase;
      }
    }

    return null;
  }

  void generateMockLabResult(String caseId) {
  final healthCase = findCase(caseId);

  if (healthCase == null) {
    return;
  }

  final updatedCase = HealthCase(
    id: healthCase.id,
    animal: healthCase.animal,
    symptoms: healthCase.symptoms,
    description: healthCase.description,
    severity: healthCase.severity,
    status: CaseStatus.resultAvailable,
    reportedDate: healthCase.reportedDate,
    location: healthCase.location,
    vetName: healthCase.vetName ?? 'Dr. Priya Patil',
    diagnosis: healthCase.diagnosis,
    labTest: 'FMD PCR',
    labSample: 'Oral swab',
    labResult: 'Positive',
    labInterpretation:
        'The laboratory findings are consistent with Foot-and-Mouth Disease.',
    disease: 'Foot-and-Mouth Disease',
    resultDate: '26 Aug 2026',
  );

  updateCase(updatedCase);
}
}