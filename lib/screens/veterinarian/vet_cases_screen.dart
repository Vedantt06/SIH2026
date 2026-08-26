import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../data/case_repository.dart';
import '../../models/health_case.dart';
import 'vet_case_detail_screen.dart';

class VetCasesScreen extends StatefulWidget {
  const VetCasesScreen({super.key});

  @override
  State<VetCasesScreen> createState() => _VetCasesScreenState();
}

class _VetCasesScreenState extends State<VetCasesScreen> {
  String filter = 'All';

  List<HealthCase> get filteredCases {
    final cases = CaseRepository.instance.cases;

    if (filter == 'All') {
      return cases;
    }

    return cases.where((healthCase) {
      return healthCase.statusLabel == filter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final cases = filteredCases;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Health Cases',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
          children: [
            _summary(),

            const SizedBox(height: 20),

            const Text(
              'Cases',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            _filters(),

            const SizedBox(height: 14),

            if (cases.isEmpty)
              _emptyState()
            else
              ...cases.map(_caseCard),
          ],
        ),
      ),
    );
  }

  Widget _summary() {
    final cases = CaseRepository.instance.cases;

    final urgent = cases.where(
      (item) =>
          item.severity == CaseSeverity.high ||
          item.severity == CaseSeverity.critical,
    ).length;

    final pending = cases.where(
      (item) =>
          item.status == CaseStatus.reported ||
          item.status == CaseStatus.underReview ||
          item.status == CaseStatus.vetAssessment,
    ).length;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: _summaryItem(
              Icons.assignment_outlined,
              '${cases.length}',
              'Total Cases',
            ),
          ),
          Container(
            width: 1,
            height: 45,
            color: Colors.white24,
          ),
          Expanded(
            child: _summaryItem(
              Icons.pending_actions_outlined,
              '$pending',
              'Pending',
            ),
          ),
          Container(
            width: 1,
            height: 45,
            color: Colors.white24,
          ),
          Expanded(
            child: _summaryItem(
              Icons.priority_high,
              '$urgent',
              'Urgent',
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryItem(
    IconData icon,
    String value,
    String label,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white70,
          size: 20,
        ),
        const SizedBox(height: 7),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _filters() {
    const filters = [
      'All',
      'Reported',
      'Under Review',
      'Vet Assessment',
    ];

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) {
          return const SizedBox(width: 8);
        },
        itemBuilder: (context, index) {
          final item = filters[index];
          final selected = filter == item;

          return GestureDetector(
            onTap: () {
              setState(() {
                filter = item;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
              ),
              decoration: BoxDecoration(
                color: selected
                    ? AppTheme.primary
                    : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selected
                      ? AppTheme.primary
                      : Colors.black.withValues(alpha: 0.06),
                ),
              ),
              child: Center(
                child: Text(
                  item,
                  style: TextStyle(
                    color: selected
                        ? Colors.white
                        : Colors.black87,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _caseCard(HealthCase healthCase) {
    final severityColor = _severityColor(
      healthCase.severity,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => VetCaseDetailScreen(
                healthCase: healthCase,
              ),
            ),
          );

          setState(() {});
        },
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: severityColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.medical_information_outlined,
                  color: severityColor,
                ),
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      healthCase.id,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      healthCase.animal.name,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
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
                    Row(
                      children: [
                        _badge(
                          healthCase.severityLabel,
                          severityColor,
                        ),
                        const SizedBox(width: 6),
                        _badge(
                          healthCase.statusLabel,
                          Colors.blueGrey,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.chevron_right,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _badge(
    String text,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 7,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 8,
          fontWeight: FontWeight.bold,
        ),
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

  Widget _emptyState() {
    return Padding(
      padding: const EdgeInsets.all(35),
      child: Column(
        children: [
          Icon(
            Icons.assignment_outlined,
            size: 55,
            color: Colors.grey.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 15),
          const Text(
            'No cases found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}