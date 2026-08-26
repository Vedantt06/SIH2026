import 'package:flutter/material.dart';


import '../../data/case_repository.dart';
import '../../models/health_case.dart';

class FarmerCasesScreen extends StatefulWidget {
  const FarmerCasesScreen({super.key});

  @override
  State<FarmerCasesScreen> createState() =>
      _FarmerCasesScreenState();
}

class _FarmerCasesScreenState
    extends State<FarmerCasesScreen> {
  @override
  Widget build(BuildContext context) {
    final cases = CaseRepository.instance.cases;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Health Cases',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: cases.isEmpty
          ? const Center(
              child: Text('No health cases reported yet.'),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(
                20,
                8,
                20,
                30,
              ),
              children: [
                const Text(
                  'Health Reports',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ...cases.map(_caseCard),
              ],
            ),
    );
  }

  Widget _caseCard(HealthCase healthCase) {
    final color = _statusColor(
      healthCase.status,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              Icons.medical_information_outlined,
              color: color,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  healthCase.id,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  healthCase.animal.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  healthCase.symptoms.take(2).join(' • '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  healthCase.statusLabel,
                  style: TextStyle(
                    color: color,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _statusColor(CaseStatus status) {
    switch (status) {
      case CaseStatus.reported:
        return Colors.orange;
      case CaseStatus.underReview:
        return Colors.blue;
      case CaseStatus.vetAssessment:
        return Colors.indigo;
      case CaseStatus.labTesting:
        return Colors.purple;
      case CaseStatus.resultAvailable:
        return Colors.teal;
      case CaseStatus.diagnosisConfirmed:
        return Colors.red;
      case CaseStatus.treatment:
        return Colors.green;
      case CaseStatus.closed:
        return Colors.grey;
    }
  }
}