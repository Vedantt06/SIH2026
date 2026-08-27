import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../data/case_repository.dart';
import '../../models/health_case.dart';

class VetCaseDetailScreen extends StatefulWidget {
  final HealthCase healthCase;

  const VetCaseDetailScreen({
    super.key,
    required this.healthCase,
  });

  @override
  State<VetCaseDetailScreen> createState() =>
      _VetCaseDetailScreenState();
}

class _VetCaseDetailScreenState
    extends State<VetCaseDetailScreen> {
  late HealthCase currentCase;

  @override
  void initState() {
    super.initState();
    currentCase = widget.healthCase;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Case Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _caseHeader(),

            const SizedBox(height: 18),

            _animalSection(),

            const SizedBox(height: 14),

            _symptomsSection(),

            const SizedBox(height: 14),

            _descriptionSection(),

            const SizedBox(height: 14),

            _locationSection(),

            if (currentCase.status.index >= CaseStatus.resultAvailable.index)
        ...[
          const SizedBox(height: 14),
          _labResultSection(),
        ],

            const SizedBox(height: 14),

            _timeline(),

            const SizedBox(height: 22),

            _actions(),
          ],
        ),
      ),
    );
  }

  Widget _caseHeader() {
    final color = _severityColor(
      currentCase.severity,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
        color: AppTheme.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'HEALTH CASE',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 9,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            currentCase.id,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 13),
          Row(
            children: [
              _headerBadge(
                currentCase.statusLabel,
                Colors.white,
              ),
              const SizedBox(width: 7),
              _headerBadge(
                currentCase.severityLabel,
                color,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _headerBadge(
    String text,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _animalSection() {
    final animal = currentCase.animal;

    return _card(
      title: 'Animal Information',
      icon: Icons.pets_outlined,
      children: [
        _infoRow('Animal', animal.name),
        _infoRow('Animal ID', animal.id),
        _infoRow('Species', animal.species),
        _infoRow('Breed', animal.breed),
        _infoRow('Age', '${animal.age} years'),
        _infoRow('Gender', animal.gender),
      ],
    );
  }

  Widget _symptomsSection() {
    return _card(
      title: 'Reported Symptoms',
      icon: Icons.sick_outlined,
      children: [
        Wrap(
          spacing: 7,
          runSpacing: 7,
          children: currentCase.symptoms.map(
            (symptom) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Text(
                  symptom,
                  style: const TextStyle(
                    color: Colors.orange,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            },
          ).toList(),
        ),
      ],
    );
  }

  Widget _descriptionSection() {
    return _card(
      title: 'Farmer Description',
      icon: Icons.description_outlined,
      children: [
        Text(
          currentCase.description,
          style: const TextStyle(
            fontSize: 12,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _locationSection() {
    return _card(
      title: 'Location',
      icon: Icons.location_on_outlined,
      children: [
        Row(
          children: [
            const Icon(
              Icons.location_on,
              color: AppTheme.primary,
              size: 20,
            ),
            const SizedBox(width: 9),
            Expanded(
              child: Text(
                currentCase.location,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

 Widget _timeline() {
  return _card(
    title: 'Case Progress',
    icon: Icons.timeline_outlined,
    children: [
      _timelineItem(
        'Case Reported',
        currentCase.reportedDate,
        true,
      ),

      _timelineItem(
        'Veterinarian Assessment',
        currentCase.status.index >=
                CaseStatus.vetAssessment.index
            ? 'Current'
            : 'Pending',
        currentCase.status.index >=
            CaseStatus.vetAssessment.index,
      ),

      _timelineItem(
        'Lab Testing',
        currentCase.status.index >=
                CaseStatus.labTesting.index
            ? 'In progress / completed'
            : 'Pending',
        currentCase.status.index >=
            CaseStatus.labTesting.index,
      ),

      _timelineItem(
        'Diagnosis',
        currentCase.status.index >=
                CaseStatus.diagnosisConfirmed.index
            ? 'Confirmed'
            : 'Pending',
        currentCase.status.index >=
            CaseStatus.diagnosisConfirmed.index,
      ),

      // 👇 ADD THIS HERE
      _timelineItem(
        'Diagnosis Confirmed',
        currentCase.status.index >=
                CaseStatus.diagnosisConfirmed.index
            ? 'Confirmed'
            : 'Pending',
        currentCase.status.index >=
            CaseStatus.diagnosisConfirmed.index,
      ),
    ],
  );
}

  Widget _timelineItem(
    String title,
    String subtitle,
    bool completed,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Row(
        children: [
          Container(
            width: 11,
            height: 11,
            decoration: BoxDecoration(
              color: completed
                  ? AppTheme.primary
                  : Colors.grey.shade300,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 11,
                fontWeight:
                    completed ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              color: completed
                  ? AppTheme.primary
                  : Colors.grey,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }

  Widget _actions() {
  if (currentCase.status == CaseStatus.reported ||
    currentCase.status == CaseStatus.underReview) {
  return SizedBox(
    width: double.infinity,
    height: 50,
    child: ElevatedButton.icon(
      onPressed: _startAssessment,
      icon: const Icon(
        Icons.medical_services_outlined,
      ),
      label: const Text(
        'Start Vet Assessment',
      ),
    ),
  );
}

if (currentCase.status == CaseStatus.vetAssessment) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton.icon(
        onPressed: _requestLabTest,
        icon: const Icon(
          Icons.science_outlined,
        ),
        label: const Text(
          'Request Lab Test',
        ),
      ),
    );
  }

  if (currentCase.status == CaseStatus.labTesting) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: _generateLabResult,
        icon: const Icon(
          Icons.biotech_outlined,
        ),
        label: const Text(
          'Simulate Lab Result',
        ),
      ),
    );
  }

  if (currentCase.status == CaseStatus.resultAvailable) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: _confirmDiagnosis,
        icon: const Icon(
          Icons.verified_outlined,
        ),
        label: const Text(
          'Confirm Diagnosis',
        ),
      ),
    );
  }

  if (currentCase.status == CaseStatus.diagnosisConfirmed) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.green.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Row(
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Diagnosis confirmed successfully.',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),

      const SizedBox(height: 12),

      SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () {
            final updatedCase = HealthCase(
              id: currentCase.id,
              animal: currentCase.animal,
              symptoms: currentCase.symptoms,
              description: currentCase.description,
              severity: currentCase.severity,
              status: CaseStatus.treatment,
              reportedDate: currentCase.reportedDate,
              location: currentCase.location,
              vetName: currentCase.vetName,
              diagnosis: currentCase.diagnosis,
              labTest: currentCase.labTest,
              labSample: currentCase.labSample,
              labResult: currentCase.labResult,
              labInterpretation: currentCase.labInterpretation,
              disease: currentCase.disease,
              resultDate: currentCase.resultDate,
              triageRisk: currentCase.triageRisk,
              triageDisease: currentCase.triageDisease,
              triageRecommendation:
                  currentCase.triageRecommendation,
              triageUrgency: currentCase.triageUrgency,
            );

            CaseRepository.instance.updateCase(updatedCase);

            setState(() {
              currentCase = updatedCase;
            });

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Case moved to Treatment.',
                ),
              ),
            );
          },
          icon: const Icon(Icons.medication_outlined),
          label: const Text('Start Treatment'),
        ),
      ),
    ],
  );
}

  return const SizedBox.shrink();
}

void _startAssessment() {
  final updated = HealthCase(
    id: currentCase.id,
    animal: currentCase.animal,
    symptoms: currentCase.symptoms,
    description: currentCase.description,
    severity: currentCase.severity,
    status: CaseStatus.vetAssessment,
    reportedDate: currentCase.reportedDate,
    location: currentCase.location,
    vetName: 'Dr. Priya Patil',
    diagnosis: currentCase.diagnosis,
    labTest: currentCase.labTest,
    labSample: currentCase.labSample,
    labResult: currentCase.labResult,
    labInterpretation: currentCase.labInterpretation,
    disease: currentCase.disease,
    resultDate: currentCase.resultDate,
  );

  CaseRepository.instance.updateCase(updated);

  setState(() {
    currentCase = updated;
  });

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text(
        'Vet assessment started.',
      ),
    ),
  );
}

void _generateLabResult() {
  CaseRepository.instance.generateMockLabResult(
    currentCase.id,
  );

  final updated = CaseRepository.instance.findCase(
    currentCase.id,
  );

  if (updated == null) {
    return;
  }

  setState(() {
    currentCase = updated;
  });

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text(
        'Laboratory result is now available.',
      ),
    ),
  );
}

void _confirmDiagnosis() {
  final updated = HealthCase(
    id: currentCase.id,
    animal: currentCase.animal,
    symptoms: currentCase.symptoms,
    description: currentCase.description,
    severity: currentCase.severity,
    status: CaseStatus.diagnosisConfirmed,
    reportedDate: currentCase.reportedDate,
    location: currentCase.location,
    vetName: currentCase.vetName ?? 'Dr. Priya Patil',
    diagnosis: currentCase.disease ?? 'Disease confirmed',
    labTest: currentCase.labTest,
    labSample: currentCase.labSample,
    labResult: currentCase.labResult,
    labInterpretation: currentCase.labInterpretation,
    disease: currentCase.disease,
    resultDate: currentCase.resultDate,
  );

  CaseRepository.instance.updateCase(updated);

  setState(() {
    currentCase = updated;
  });

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        'Diagnosis confirmed: ${updated.diagnosis}',
      ),
    ),
  );
}

  Widget _labResultSection() {
  final isPositive = currentCase.labResult == 'Positive';

  return _card(
    title: 'Laboratory Result',
    icon: Icons.science_outlined,
    children: [
      _infoRow(
        'Test',
        currentCase.labTest ?? 'Not available',
      ),
      _infoRow(
        'Sample',
        currentCase.labSample ?? 'Not available',
      ),
      _infoRow(
        'Result',
        currentCase.labResult ?? 'Pending',
      ),
      _infoRow(
        'Result Date',
        currentCase.resultDate ?? 'Pending',
      ),
      const SizedBox(height: 8),
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: (isPositive ? Colors.red : Colors.green)
              .withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          currentCase.labInterpretation ??
              'Laboratory interpretation is not available.',
          style: TextStyle(
            color: isPositive ? Colors.red : Colors.green,
            fontSize: 11,
            height: 1.4,
          ),
        ),
      ),
    ],
  );
}



  Future<void> _requestLabTest() async {
    final updated = HealthCase(
      id: currentCase.id,
      animal: currentCase.animal,
      symptoms: currentCase.symptoms,
      description: currentCase.description,
      severity: currentCase.severity,
      status: CaseStatus.labTesting,
      reportedDate: currentCase.reportedDate,
      location: currentCase.location,
      vetName: 'Dr. Priya Patil',
      diagnosis: currentCase.diagnosis,
    );

    CaseRepository.instance.updateCase(updated);

    setState(() {
      currentCase = updated;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Lab test requested.',
        ),
      ),
    );
  }

  Widget _card({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: AppTheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _infoRow(
    String label,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 11,
              ),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _severityColor(CaseSeverity severity) {
    switch (severity) {
      case CaseSeverity.low:
        return Colors.green;
      case CaseSeverity.moderate:
        return Colors.orange;
      case CaseSeverity.high:
        return Colors.red;
      case CaseSeverity.critical:
        return Colors.purple;
    }
  }
}