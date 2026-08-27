import 'package:flutter/material.dart';

import '../../data/case_repository.dart';
import '../../models/health_case.dart';

class FarmerCasesScreen extends StatefulWidget {
  const FarmerCasesScreen({super.key});

  @override
  State<FarmerCasesScreen> createState() => _FarmerCasesScreenState();
}

class _FarmerCasesScreenState extends State<FarmerCasesScreen> {
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
    final color = _statusColor(healthCase.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          // Case summary
          Padding(
            padding: const EdgeInsets.all(15),
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
          ),

          // AI triage section
          if (healthCase.triageRisk != null)
            _aiTriageCard(healthCase),
        ],
      ),
    );
  }

  Widget _aiTriageCard(HealthCase healthCase) {
    final riskColor = _riskColor(healthCase.triageRisk);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: riskColor.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: riskColor.withValues(alpha: 0.18),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.auto_awesome,
                size: 18,
                color: riskColor,
              ),
              const SizedBox(width: 7),
              const Expanded(
                child: Text(
                  'AI Triage Assessment',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: riskColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  healthCase.triageRisk ?? 'Unknown',
                  style: TextStyle(
                    color: riskColor,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          _triageRow(
            Icons.coronavirus_outlined,
            'Possible condition',
            healthCase.triageDisease ?? 'Not determined',
          ),

          const SizedBox(height: 8),

          _triageRow(
            Icons.priority_high_rounded,
            'Urgency',
            healthCase.triageUrgency ?? 'Not determined',
          ),

          const SizedBox(height: 8),

          _triageRow(
            Icons.medical_services_outlined,
            'Recommendation',
            healthCase.triageRecommendation ?? 'No recommendation',
          ),

          const SizedBox(height: 10),

          const Text(
            'AI-assisted prototype analysis • Not a veterinary diagnosis',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 8,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _triageRow(
    IconData icon,
    String title,
    String value,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.grey,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 10,
              ),
              children: [
                TextSpan(
                  text: '$title: ',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                  text: value,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Color _riskColor(String? risk) {
    switch (risk?.toLowerCase()) {
      case 'low':
        return Colors.green;

      case 'moderate':
        return Colors.orange;

      case 'high':
        return Colors.red;

      case 'critical':
        return Colors.purple;

      default:
        return Colors.grey;
    }
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