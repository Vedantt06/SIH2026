import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../services/outbreak_prediction_service.dart';

class OutbreakPredictionScreen extends StatelessWidget {
  const OutbreakPredictionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final predictions =
        OutbreakPredictionService.instance.predictOutbreaks();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Outbreak Prediction',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.analytics_outlined,
                  color: Colors.white,
                  size: 42,
                ),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI-assisted outbreak prediction',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Combines disease trends, recent cases, clusters and vaccination coverage.',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          const Text(
            'Early Warning Assessment',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'Districts are ranked according to their estimated outbreak risk.',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 18),

          for (final prediction in predictions)
            _predictionCard(prediction),
        ],
      ),
    );
  }

  Widget _predictionCard(
    OutbreakPrediction prediction,
  ) {
    final Color color;

    if (prediction.riskLevel == 'High') {
      color = Colors.red;
    } else if (prediction.riskLevel == 'Moderate') {
      color = Colors.orange;
    } else {
      color = Colors.green;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: color.withValues(alpha: 0.18),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  Icons.warning_amber_rounded,
                  color: color,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      prediction.location,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      prediction.disease,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  prediction.riskLevel,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              const Icon(
                Icons.speed,
                size: 18,
                color: Colors.grey,
              ),
              const SizedBox(width: 7),
              Text(
                'Risk score: ${prediction.riskScore}/100',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: _infoChip(
                  Icons.trending_up,
                  'Trend',
                  prediction.trend,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _infoChip(
                  Icons.assignment_outlined,
                  'Recent cases',
                  '${prediction.recentCases}',
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              Expanded(
                child: _infoChip(
                  Icons.vaccines_outlined,
                  'Vaccination',
                  '${prediction.vaccinationCoverage}%',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _infoChip(
                  Icons.hub_outlined,
                  'Cluster',
                  prediction.clusterDetected
                      ? 'Detected'
                      : 'None',
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.auto_awesome,
                  size: 17,
                  color: color,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    prediction.prediction,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          Text(
            prediction.recommendation,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoChip(
    IconData icon,
    String label,
    String value,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 15,
            color: Colors.grey,
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              '$label: $value',
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}