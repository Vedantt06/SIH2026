import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../data/surveillance_repository.dart';
import '../../data/case_repository.dart';
import '../../models/health_case.dart';

class GisScreen extends StatefulWidget {
  final Object role;

  const GisScreen({
    super.key,
    required this.role,
  });

  @override
  State<GisScreen> createState() => _GisScreenState();
}

class _GisScreenState extends State<GisScreen> {
  String selectedDistrict = 'Nashik';
  String? selectedTaluka;
String? selectedVillage;

  String get roleName {
    return widget.role
        .toString()
        .split('.')
        .last
        .toLowerCase();
  }

  bool get isFarmer => roleName.contains('farmer');

  bool get isVet =>
      roleName.contains('vet') ||
      roleName.contains('veterinarian');

  bool get isGovernment =>
      roleName.contains('government') ||
      roleName.contains('gov');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Disease Surveillance Map',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 19,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),

              const SizedBox(height: 18),

              _buildMap(),

              const SizedBox(height: 22),

              _buildDistrictSelector(),

              const SizedBox(height: 22),

              _buildRiskSummary(),
              const SizedBox(height: 22),
              _buildClusterVisualization(),
              const SizedBox(height: 22),
              _buildAnalytics(),
              const SizedBox(height: 22),
              _buildAlerts(),
              const SizedBox(height: 22),
              _buildRoleInformation(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    String title;
    String subtitle;

    if (isFarmer) {
      title = 'Your Local Area';
      subtitle =
          'View your location, nearby services and local disease alerts.';
    } else if (isVet) {
      title = 'Field Surveillance';
      subtitle =
          'View assigned cases, nearby reports and livestock risk areas.';
    } else if (isGovernment) {
      title = 'Maharashtra Surveillance';
      subtitle =
          'Monitor livestock disease activity across districts.';
    } else {
      title = 'System GIS Overview';
      subtitle =
          'Read-only surveillance view of platform activity.';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildMap() {

    final areas = SurveillanceRepository.instance.areas;

    final nashik = areas.firstWhere(
      (area) => area.district == 'Nashik',
    );

    return Container(
      height: 380,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFE5ECE8),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _MapPainter(),
            ),
          ),

          // Maharashtra-style map silhouette
          Positioned.fill(
            child: CustomPaint(
              painter: _StateShapePainter(),
            ),
          ),

          _marker(
            0.27,
            0.25,
            _riskColor(nashik.riskLevel),
            'Nashik',
            nashik.totalCases,
          ),

          _marker(
            0.53,
            0.36,
            Colors.orange,
            'Pune',
            21,
          ),

          _marker(
            0.40,
            0.62,
            Colors.orange,
            'Latur',
            16,
          ),

          _marker(
            0.68,
            0.67,
            Colors.green,
            'Nagpur',
            9,
          ),

          _marker(
            0.20,
            0.68,
            Colors.green,
            'Kolhapur',
            6,
          ),

          Positioned(
            top: 15,
            left: 15,
            child: _mapLegend(),
          ),

          Positioned(
            top: 15,
            right: 15,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 11,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    isFarmer
                        ? Icons.home_outlined
                        : isVet
                            ? Icons.medical_services_outlined
                            : Icons.map_outlined,
                    size: 16,
                    color: AppTheme.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isFarmer
                        ? 'My Area'
                        : isVet
                            ? 'Field View'
                            : 'State View',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            bottom: 15,
            right: 15,
            child: FloatingActionButton.small(
              heroTag: 'gis-location',
              backgroundColor: Colors.white,
              foregroundColor: AppTheme.primary,
              onPressed: () {},
              child: const Icon(
                Icons.my_location,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _marker(
    double x,
    double y,
    Color color,
    String district,
    int cases,
  ) {
    return Positioned(
      left: MediaQuery.of(context).size.width * x,
      top: 380 * y,
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedDistrict = district;
          });
        },
        child: Column(
          children: [
            Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.35),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 3),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 7,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(7),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Text(
                '$district • $cases',
                style: const TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _riskColor(String riskLevel) {
  switch (riskLevel) {
    case 'High Risk':
      return Colors.red;
    case 'Medium Risk':
      return Colors.orange;
    default:
      return Colors.green;
  }
}

  Widget _mapLegend() {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Risk Level',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 7),
          _LegendRow(
            color: Colors.red,
            text: 'High',
          ),
          _LegendRow(
            color: Colors.orange,
            text: 'Medium',
          ),
          _LegendRow(
            color: Colors.green,
            text: 'Low',
          ),
        ],
      ),
    );
  }

Widget _buildDistrictSelector() {
  final districts = [
    'Nashik',
    'Pune',
    'Latur',
    'Nagpur',
    'Kolhapur',
  ];

  final talukas = {
    'Nashik': [
      'Nashik',
      'Sinnar',
      'Igatpuri',
    ],
    'Pune': [
      'Pune',
      'Baramati',
      'Haveli',
    ],
    'Latur': [
      'Latur',
      'Ausa',
      'Udgir',
    ],
    'Nagpur': [
      'Nagpur',
      'Hingna',
      'Kamptee',
    ],
    'Kolhapur': [
      'Karvir',
      'Hatkanangale',
      'Panhala',
    ],
  };

  final villages = {
    'Nashik': [
      'Nashik Village',
      'Makhmalabad',
      'Gangapur',
    ],
    'Sinnar': [
      'Sinnar Village',
      'Shivajinagar',
      'Wavi',
    ],
    'Igatpuri': [
      'Igatpuri Village',
      'Ghoti',
      'Vaitarna',
    ],
    'Pune': [
      'Pune Village',
      'Khadki',
      'Kothrud',
    ],
    'Baramati': [
      'Baramati Village',
      'Malegaon',
      'Supa',
    ],
    'Haveli': [
      'Haveli Village',
      'Wagholi',
      'Lohegaon',
    ],
    'Latur': [
      'Latur Village',
      'Harangul',
      'Ausa Road',
    ],
    'Ausa': [
      'Ausa Village',
      'Kille Dharur',
      'Ujani',
    ],
    'Udgir': [
      'Udgir Village',
      'Nalegaon',
      'Deoni',
    ],
    'Nagpur': [
      'Nagpur Village',
      'Manewada',
      'Dighori',
    ],
    'Hingna': [
      'Hingna Village',
      'Wanadongri',
      'Digdoh',
    ],
    'Kamptee': [
      'Kamptee Village',
      'Kanhan',
      'Koradi',
    ],
    'Karvir': [
      'Karvir Village',
      'Uchgaon',
      'Gargoti',
    ],
    'Hatkanangale': [
      'Hatkanangale Village',
      'Ichalkaranji',
      'Hupari',
    ],
    'Panhala': [
      'Panhala Village',
      'Kale',
      'Kumbharwadi',
    ],
  };

  final currentTalukas = talukas[selectedDistrict] ?? [];

  final currentVillages =
      selectedTaluka == null ? <String>[] : (villages[selectedTaluka] ?? []);

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Location Drill-down',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),

      const SizedBox(height: 12),

      // DISTRICT
      const Text(
        'District',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
        ),
      ),

      const SizedBox(height: 7),

      SizedBox(
        height: 43,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: districts.length,
          separatorBuilder: (_, __) {
            return const SizedBox(width: 8);
          },
          itemBuilder: (context, index) {
            final district = districts[index];
            final selected = district == selectedDistrict;

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedDistrict = district;
                  selectedTaluka = null;
                  selectedVillage = null;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
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
                    district,
                    style: TextStyle(
                      color: selected
                          ? Colors.white
                          : Colors.black87,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),

      // TALUKA
      if (currentTalukas.isNotEmpty) ...[
        const SizedBox(height: 16),

        const Text(
          'Taluka',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),

        const SizedBox(height: 7),

        SizedBox(
          height: 43,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: currentTalukas.length,
            separatorBuilder: (_, __) {
              return const SizedBox(width: 8);
            },
            itemBuilder: (context, index) {
              final taluka = currentTalukas[index];
              final selected = taluka == selectedTaluka;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedTaluka = taluka;
                    selectedVillage = null;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
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
                      taluka,
                      style: TextStyle(
                        color: selected
                            ? Colors.white
                            : Colors.black87,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],

      // VILLAGE
      if (currentVillages.isNotEmpty) ...[
        const SizedBox(height: 16),

        const Text(
          'Village',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),

        const SizedBox(height: 7),

        SizedBox(
          height: 43,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: currentVillages.length,
            separatorBuilder: (_, __) {
              return const SizedBox(width: 8);
            },
            itemBuilder: (context, index) {
              final village = currentVillages[index];
              final selected = village == selectedVillage;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedVillage = village;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
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
                      village,
                      style: TextStyle(
                        color: selected
                            ? Colors.white
                            : Colors.black87,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],

      // CURRENT SELECTION
      const SizedBox(height: 16),

      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.primary.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.location_on_outlined,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                selectedVillage != null
                    ? '$selectedDistrict → $selectedTaluka → $selectedVillage'
                    : selectedTaluka != null
                        ? '$selectedDistrict → $selectedTaluka'
                        : selectedDistrict,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
            if (selectedVillage != null) ...[
        const SizedBox(height: 18),

        const Text(
          'Cases in Selected Village',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

        _buildVillageCases(),
      ],
    ],
  );
}
Widget _buildVillageCases() {
  final allCases = CaseRepository.instance.cases;

  final villageCases = allCases.where((healthCase) {
  final location = healthCase.location.toLowerCase();

  if (selectedVillage != null) {
    return location.contains(
      selectedVillage!.toLowerCase(),
    );
  }

  if (selectedTaluka != null) {
    return location.contains(
      selectedTaluka!.toLowerCase(),
    );
  }

  return location.contains(
    selectedDistrict.toLowerCase(),
  );
}).toList();

  if (villageCases.isEmpty) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.info_outline,
            color: Colors.grey,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'No reported cases found for this location.',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  return Column(
    children: villageCases.map((healthCase) {
      final disease =
          healthCase.disease ?? 'Disease under investigation';

      return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Colors.black.withValues(alpha: 0.06),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.pets_outlined,
                size: 20,
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
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    '${healthCase.animal.name} • $disease',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    healthCase.location,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 9,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: healthCase.status ==
                        CaseStatus.diagnosisConfirmed
                    ? Colors.red.withValues(alpha: 0.08)
                    : Colors.orange.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                healthCase.statusLabel,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: healthCase.status ==
                          CaseStatus.diagnosisConfirmed
                      ? Colors.red
                      : Colors.orange,
                ),
              ),
            ),
          ],
        ),
      );
    }).toList(),
  );
}

  Widget _buildRiskSummary() {
    final data = _districtData[selectedDistrict]!;

  final areas = SurveillanceRepository.instance.areas;

  final selectedArea = areas.firstWhere(
    (area) => area.district == selectedDistrict,
  );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$selectedDistrict Surveillance',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: _statCard(
                'Active Cases',
                '${selectedArea.totalCases}',
                Icons.assignment_outlined,
                Colors.orange,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _statCard(
                'High Risk',
                '${selectedArea.confirmedCases}',
                Icons.warning_amber_rounded,
                Colors.red,
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        Row(
          children: [
            Expanded(
              child: _statCard(
                'Animals',
                '${data['animals']}',
                Icons.pets_outlined,
                AppTheme.primary,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _statCard(
                'Vets',
                '${data['vets']}',
                Icons.medical_services_outlined,
                Colors.blue,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _statCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: color,
            size: 21,
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

Widget _buildClusterVisualization() {
  final allCases = CaseRepository.instance.cases;

  final districtCases = allCases.where((healthCase) {
    return healthCase.location
        .toLowerCase()
        .contains(selectedDistrict.toLowerCase());
  }).toList();

  final Map<String, List<HealthCase>> groupedCases = {};

  for (final healthCase in districtCases) {
    final disease =
        healthCase.disease ?? 'Disease under investigation';

    final key = '${healthCase.location} • $disease';

    groupedCases.putIfAbsent(key, () => []);
    groupedCases[key]!.add(healthCase);
  }

  final clusters = groupedCases.entries
      .where((entry) => entry.value.length >= 2)
      .toList();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Disease Clusters',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),

      const SizedBox(height: 6),

      const Text(
        'Potential areas with concentrated disease activity.',
        style: TextStyle(
          color: Colors.grey,
          fontSize: 12,
        ),
      ),

      const SizedBox(height: 12),

      if (clusters.isEmpty)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Row(
            children: [
              Icon(
                Icons.check_circle_outline,
                color: Colors.green,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'No potential emerging cluster detected in the selected area.',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),

      ...clusters.map((entry) {
        final cases = entry.value;

        final highRisk = cases.any(
          (healthCase) =>
              healthCase.severity == CaseSeverity.high ||
              healthCase.severity == CaseSeverity.critical,
        );

        final parts = entry.key.split(' • ');
        final location = parts.first;
        final disease = parts.length > 1
            ? parts.sublist(1).join(' • ')
            : 'Disease under investigation';

        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: highRisk
                  ? Colors.red.withValues(alpha: 0.18)
                  : Colors.black.withValues(alpha: 0.06),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: highRisk
                      ? Colors.red.withValues(alpha: 0.08)
                      : Colors.orange.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.hub_outlined,
                  color: highRisk
                      ? Colors.red
                      : Colors.orange,
                  size: 21,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      location,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      disease,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      '${cases.length} cases detected',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: highRisk
                      ? Colors.red.withValues(alpha: 0.08)
                      : Colors.orange.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  highRisk
                      ? 'High Risk'
                      : 'Potential Cluster',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: highRisk
                        ? Colors.red
                        : Colors.orange,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    ],
  );
}

Widget _buildAnalytics() {
  final allCases = CaseRepository.instance.cases;

  final districtCases = allCases.where((healthCase) {
    return healthCase.location
        .toLowerCase()
        .contains(selectedDistrict.toLowerCase());
  }).toList();

  final highRiskCases = districtCases.where(
    (healthCase) =>
        healthCase.severity == CaseSeverity.high ||
        healthCase.severity == CaseSeverity.critical,
  ).length;

  final confirmedCases = districtCases.where(
    (healthCase) =>
        healthCase.status == CaseStatus.diagnosisConfirmed,
  ).length;

  final pendingCases = districtCases.where(
    (healthCase) =>
        healthCase.status == CaseStatus.reported ||
        healthCase.status == CaseStatus.underReview,
  ).length;

  final Map<String, int> diseaseCounts = {};

  for (final healthCase in districtCases) {
    final disease =
        healthCase.disease ?? 'Under investigation';

    diseaseCounts[disease] =
        (diseaseCounts[disease] ?? 0) + 1;
  }

  String topDisease = 'No disease data';

  if (diseaseCounts.isNotEmpty) {
    topDisease = diseaseCounts.entries.reduce(
      (a, b) => a.value >= b.value ? a : b,
    ).key;
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Disease Analytics',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),

      const SizedBox(height: 6),

      Text(
        '$selectedDistrict case overview',
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 12,
        ),
      ),

      const SizedBox(height: 12),

      Row(
        children: [
          Expanded(
            child: _statCard(
              'Total Cases',
              '${districtCases.length}',
              Icons.assignment_outlined,
              Colors.orange,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _statCard(
              'High Risk',
              '$highRiskCases',
              Icons.warning_amber_rounded,
              Colors.red,
            ),
          ),
        ],
      ),

      const SizedBox(height: 10),

      Row(
        children: [
          Expanded(
            child: _statCard(
              'Confirmed',
              '$confirmedCases',
              Icons.verified_outlined,
              Colors.green,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _statCard(
              'Pending',
              '$pendingCases',
              Icons.pending_actions_outlined,
              Colors.orange,
            ),
          ),
        ],
      ),

      const SizedBox(height: 12),

      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.coronavirus_outlined,
                color: Colors.red,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Most Reported Disease',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    topDisease,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget _buildAlerts() {
  final allCases = CaseRepository.instance.cases;

  final districtCases = allCases.where((healthCase) {
    return healthCase.location
        .toLowerCase()
        .contains(selectedDistrict.toLowerCase());
  }).toList();

  final highRiskCases = districtCases.where(
    (healthCase) =>
        healthCase.severity == CaseSeverity.high ||
        healthCase.severity == CaseSeverity.critical,
  ).length;

  final pendingCases = districtCases.where(
    (healthCase) =>
        healthCase.status == CaseStatus.reported ||
        healthCase.status == CaseStatus.underReview,
  ).length;

  final alerts = <Map<String, dynamic>>[];

  if (highRiskCases > 0) {
    alerts.add({
      'title': 'High-risk cases require attention',
      'description':
          '$highRiskCases high-risk case(s) detected in $selectedDistrict.',
      'icon': Icons.warning_amber_rounded,
      'color': Colors.red,
    });
  }

  if (districtCases.length >= 3) {
    alerts.add({
      'title': 'Potential outbreak risk',
      'description':
          'Multiple cases are currently reported in $selectedDistrict.',
      'icon': Icons.hub_outlined,
      'color': Colors.orange,
    });
  }

  if (pendingCases > 0) {
    alerts.add({
      'title': 'Veterinary review pending',
      'description':
          '$pendingCases case(s) require further review.',
      'icon': Icons.medical_services_outlined,
      'color': Colors.blue,
    });
  }

  if (alerts.isEmpty) {
    alerts.add({
      'title': 'No critical alerts',
      'description':
          'No immediate surveillance action is required.',
      'icon': Icons.check_circle_outline,
      'color': Colors.green,
    });
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Government Alerts',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),

      const SizedBox(height: 6),

      const Text(
        'Potential risks requiring surveillance attention.',
        style: TextStyle(
          color: Colors.grey,
          fontSize: 12,
        ),
      ),

      const SizedBox(height: 12),

      ...alerts.map(
        (alert) {
          final Color color = alert['color'] as Color;

          return Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: color.withValues(alpha: 0.15),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    alert['icon'] as IconData,
                    color: color,
                    size: 21,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        alert['title'] as String,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        alert['description'] as String,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ],
  );
}

  Widget _buildRoleInformation() {
    if (isFarmer) {
      return _informationCard(
        title: 'Nearby Services',
        items: const [
          'Veterinary clinic • 2.4 km',
          'Government veterinary center • 4.1 km',
          'Vaccination camp • 6.8 km',
        ],
        icon: Icons.local_hospital_outlined,
        color: AppTheme.primary,
      );
    }

    if (isVet) {
      return _informationCard(
        title: 'Nearby Field Cases',
        items: const [
          'Case #MH-NK-00124 • High risk',
          'Case #MH-NK-00121 • Medium risk',
          'Case #MH-NK-00118 • Low risk',
        ],
        icon: Icons.medical_information_outlined,
        color: Colors.orange,
      );
    }

    if (isGovernment) {
  final allCases = CaseRepository.instance.cases;

  final districtCases = allCases.where((healthCase) {
    return healthCase.location
        .toLowerCase()
        .contains(selectedDistrict.toLowerCase());
  }).toList();

  final highRiskCases = districtCases.where(
    (healthCase) =>
        healthCase.severity == CaseSeverity.high ||
        healthCase.severity == CaseSeverity.critical,
  ).length;

  final pendingCases = districtCases.where(
    (healthCase) =>
        healthCase.status == CaseStatus.reported ||
        healthCase.status == CaseStatus.underReview ||
        healthCase.status == CaseStatus.vetAssessment,
  ).length;

  final confirmedCases = districtCases.where(
    (healthCase) =>
        healthCase.status == CaseStatus.diagnosisConfirmed,
  ).length;

  return _informationCard(
    title: 'Surveillance Insights',
    items: [
      highRiskCases > 0
          ? '$selectedDistrict has $highRiskCases high-risk case(s) requiring attention'
          : 'No high-risk cases currently detected in $selectedDistrict',

      pendingCases > 0
          ? '$pendingCases case(s) are currently under review'
          : 'No cases are currently awaiting veterinary review',

      confirmedCases > 0
          ? '$confirmedCases confirmed diagnosis(es) recorded'
          : 'No confirmed diagnoses recorded yet',
    ],
    icon: Icons.analytics_outlined,
    color: Colors.red,
  );
}

    return _informationCard(
      title: 'Platform Coverage',
      items: const [
        '4,286 registered farmers',
        '86 active veterinarians',
        '24,800+ livestock records',
      ],
      icon: Icons.insights_outlined,
      color: AppTheme.primary,
    );
  }

  Widget _informationCard({
    required String title,
    required List<String> items,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
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
                color: color,
                size: 21,
              ),
              const SizedBox(width: 9),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...items.map(
            (item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 9),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: Text(
                        item,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  static const Map<String, Map<String, int>> _districtData = {
    'Nashik': {
      'cases': 34,
      'highRisk': 8,
      'animals': 5820,
      'vets': 14,
    },
    'Pune': {
      'cases': 21,
      'highRisk': 4,
      'animals': 4310,
      'vets': 12,
    },
    'Latur': {
      'cases': 16,
      'highRisk': 3,
      'animals': 3650,
      'vets': 9,
    },
    'Nagpur': {
      'cases': 9,
      'highRisk': 1,
      'animals': 2980,
      'vets': 11,
    },
    'Kolhapur': {
      'cases': 6,
      'highRisk': 1,
      'animals': 2470,
      'vets': 8,
    },
  };
}

class _LegendRow extends StatelessWidget {
  final Color color;
  final String text;

  const _LegendRow({
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.65)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    for (double x = 0; x < size.width; x += 35) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    for (double y = 0; y < size.height; y += 35) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(
    covariant CustomPainter oldDelegate,
  ) {
    return false;
  }
}

class _StateShapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFCBD8D0)
      ..style = PaintingStyle.fill;

    final outline = Paint()
      ..color = const Color(0xFF9FB2A6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();

    path.moveTo(size.width * 0.20, size.height * 0.20);
    path.lineTo(size.width * 0.42, size.height * 0.10);
    path.lineTo(size.width * 0.67, size.height * 0.19);
    path.lineTo(size.width * 0.79, size.height * 0.38);
    path.lineTo(size.width * 0.73, size.height * 0.62);
    path.lineTo(size.width * 0.60, size.height * 0.77);
    path.lineTo(size.width * 0.40, size.height * 0.84);
    path.lineTo(size.width * 0.25, size.height * 0.69);
    path.lineTo(size.width * 0.15, size.height * 0.48);
    path.close();

    canvas.drawPath(path, paint);
    canvas.drawPath(path, outline);

    final districtPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.75)
      ..strokeWidth = 1;

    canvas.drawLine(
      Offset(size.width * 0.20, size.height * 0.43),
      Offset(size.width * 0.68, size.height * 0.42),
      districtPaint,
    );

    canvas.drawLine(
      Offset(size.width * 0.36, size.height * 0.18),
      Offset(size.width * 0.43, size.height * 0.76),
      districtPaint,
    );

    canvas.drawLine(
      Offset(size.width * 0.58, size.height * 0.18),
      Offset(size.width * 0.57, size.height * 0.70),
      districtPaint,
    );
  }

  @override
  bool shouldRepaint(
    covariant CustomPainter oldDelegate,
  ) {
    return false;
  }
}