import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../models/animal.dart';
import '../../models/health_case.dart';
import 'report_health_screen.dart';


class AnimalProfileScreen extends StatelessWidget {
  final Animal animal;

  const AnimalProfileScreen({
    super.key,
    required this.animal,
  });

  @override
  Widget build(BuildContext context) {
    final isHealthy = animal.healthStatus == 'Healthy';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Animal Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
        child: Column(
          children: [
            _heroCard(),

            const SizedBox(height: 20),

            _section(
              'Basic Information',
              [
                _infoRow(
                  Icons.badge_outlined,
                  'Animal ID',
                  animal.id,
                ),
                _infoRow(
                  Icons.pets_outlined,
                  'Species',
                  animal.species,
                ),
                _infoRow(
                  Icons.category_outlined,
                  'Breed',
                  animal.breed,
                ),
                _infoRow(
                  Icons.wc_outlined,
                  'Gender',
                  animal.gender,
                ),
                _infoRow(
                  Icons.cake_outlined,
                  'Age',
                  '${animal.age} years',
                ),
                _infoRow(
                  Icons.location_on_outlined,
                  'Location',
                  animal.location,
                ),
              ],
            ),

            const SizedBox(height: 15),

            _section(
              'Health Information',
              [
                _infoRow(
                  Icons.health_and_safety_outlined,
                  'Health Status',
                  animal.healthStatus,
                  valueColor:
                      isHealthy ? Colors.green : Colors.orange,
                ),
                _infoRow(
                  Icons.vaccines_outlined,
                  'Vaccination',
                  animal.vaccinationStatus,
                  valueColor:
                      animal.vaccinationStatus == 'Up to date'
                          ? Colors.green
                          : Colors.orange,
                ),
                _infoRow(
                  Icons.calendar_month_outlined,
                  'Last Checkup',
                  animal.lastCheckup,
                ),
              ],
            ),

            const SizedBox(height: 15),

            _section(
              'Health History',
              [
                _historyItem(
                  'Routine health check',
                  animal.lastCheckup,
                  'No abnormal findings',
                  Colors.green,
                ),
                _historyItem(
                  'Vaccination recorded',
                  '02 Jul 2026',
                  'Vaccination completed',
                  Colors.blue,
                ),
                _historyItem(
                  'Animal registered',
                  '14 Jun 2026',
                  'Added to MahaPashu Suraksha',
                  AppTheme.primary,
                ),
              ],
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                    final healthCase = await Navigator.push<HealthCase>(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ReportHealthScreen(
                        animal: animal,
                        ),
                    ),
                    );

                    if (healthCase != null && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                        content: Text(
                            'Case ${healthCase.id} created successfully.',
                        ),
                        ),
                    );
                    }
                },
                icon: const Icon(
                    Icons.medical_information_outlined,
                ),
                label: const Text('Report Health Issue'),
                ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _heroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppTheme.primary,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.13),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.pets,
              size: 42,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            animal.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            '${animal.breed} • ${animal.species}',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 13,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              animal.healthStatus,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _section(
    String title,
    List<Widget> children,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }

  Widget _infoRow(
    IconData icon,
    String title,
    String value, {
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        children: [
          Icon(
            icon,
            size: 19,
            color: AppTheme.primary,
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _historyItem(
    String title,
    String date,
    String description,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 4),
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  date,
                  style: TextStyle(
                    color: color,
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}