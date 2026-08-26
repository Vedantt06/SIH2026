import '../models/health_case.dart';
import 'mock_animals.dart';

final List<HealthCase> mockCases = [
  HealthCase(
    id: 'CASE-MH-NK-00124',
    animal: mockAnimals[0],
    symptoms: const [
      'Fever',
      'Reduced appetite',
      'Excessive salivation',
    ],
    description:
        'Animal has been eating less and showing signs of fever for two days.',
    severity: CaseSeverity.moderate,
    status: CaseStatus.vetAssessment,
    reportedDate: '24 Aug 2026',
    location: 'Nashik, Maharashtra',
    vetName: 'Dr. Priya Patil',
  ),
  HealthCase(
    id: 'CASE-MH-NK-00121',
    animal: mockAnimals[2],
    symptoms: const [
      'Reduced movement',
      'Loss of appetite',
    ],
    description:
        'Animal appears less active than usual and has reduced food intake.',
    severity: CaseSeverity.high,
    status: CaseStatus.underReview,
    reportedDate: '22 Aug 2026',
    location: 'Nashik, Maharashtra',
  ),
];