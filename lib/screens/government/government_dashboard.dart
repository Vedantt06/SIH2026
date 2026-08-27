import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../models/user.dart';
import '../../widgets/dashboard_card.dart';
import '../../widgets/role_badge.dart';
import '../gis/gis_screen.dart';
import '../../models/health_case.dart';
import '../../models/disease_cluster.dart';
import '../../services/cluster_detection_service.dart';
import 'vaccination_priority_screen.dart';
import 'outbreak_prediction_screen.dart';
import '../../services/veterinary-response_priority_service.dart';

class GovernmentDashboard extends StatefulWidget {
  final AppUser user;

  const GovernmentDashboard({
    super.key,
    required this.user,
  });

  @override
  State<GovernmentDashboard> createState() => _GovernmentDashboardState();
}

class _GovernmentDashboardState extends State<GovernmentDashboard> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: const Text(
          'MahaPashu Suraksha',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 19,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                currentIndex = 2;
              });
            },
            icon: const Icon(Icons.notifications_none_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Overview',
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map),
            label: 'GIS',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_none),
            selectedIcon: Icon(Icons.notifications),
            label: 'Alerts',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // BODY NAVIGATION
  // ---------------------------------------------------------------------------

  Widget _buildBody() {
    switch (currentIndex) {
      case 1:
        return GisScreen(
          role: widget.user.role,
        );

      case 2:
        return _alertsPage();

      case 3:
        return _profilePage();

      default:
        return _overviewPage();
    }
  }

  // ---------------------------------------------------------------------------
  // OVERVIEW PAGE
  // ---------------------------------------------------------------------------

  Widget _overviewPage() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(),

            const SizedBox(height: 22),

            const Text(
              'Maharashtra Surveillance',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: DashboardCard(
                    title: 'Active Cases',
                    value: '142',
                    subtitle: 'Across Maharashtra',
                    icon: Icons.assignment_outlined,
                    iconColor: Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DashboardCard(
                    title: 'High Risk',
                    value: '18',
                    subtitle: 'Require attention',
                    icon: Icons.warning_amber_rounded,
                    iconColor: Colors.red,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: DashboardCard(
                    title: 'Animals Tracked',
                    value: '24.8K',
                    subtitle: 'Registered livestock',
                    icon: Icons.pets_outlined,
                    iconColor: AppTheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DashboardCard(
                    title: 'Veterinarians',
                    value: '86',
                    subtitle: 'Active officers',
                    icon: Icons.medical_services_outlined,
                    iconColor: Colors.blue,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // -----------------------------------------------------------------
            // DISEASE SURVEILLANCE
            // -----------------------------------------------------------------

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Disease Surveillance',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      currentIndex = 1;
                    });
                  },
                  child: const Text('Open GIS'),
                ),
              ],
            ),

            const SizedBox(height: 12),

            _mapPreview(),

            const SizedBox(height: 28),

            // -----------------------------------------------------------------
            // DISTRICT OVERVIEW
            // -----------------------------------------------------------------

            const Text(
              'District Overview',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            _districtCard(
              'Nashik',
              '34 active cases',
              0.76,
              Colors.red,
            ),

            const SizedBox(height: 10),

            _districtCard(
              'Pune',
              '21 active cases',
              0.48,
              Colors.orange,
            ),

            const SizedBox(height: 10),

            _districtCard(
              'Latur',
              '16 active cases',
              0.35,
              Colors.orange,
            ),

            const SizedBox(height: 10),

            _districtCard(
              'Nagpur',
              '9 active cases',
              0.22,
              Colors.green,
            ),

            const SizedBox(height: 28),

            const SizedBox(height: 28),

const Text(
  'Outbreak Prediction',
  style: TextStyle(
    fontSize: 19,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 12),

GestureDetector(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const OutbreakPredictionScreen(),
      ),
    );
  },
  child: Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppTheme.primary.withValues(alpha: 0.07),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: AppTheme.primary.withValues(alpha: 0.15),
      ),
    ),
    child: Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: AppTheme.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(13),
          ),
          child: const Icon(
            Icons.analytics_outlined,
            color: AppTheme.primary,
          ),
        ),

        const SizedBox(width: 12),

        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'AI Outbreak Prediction',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Predict emerging disease risks using surveillance data.',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 10,
                ),
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

            // -----------------------------------------------------------------
            // AI DISEASE CLUSTER DETECTION
            // -----------------------------------------------------------------

            const Text(
              'AI Disease Cluster Detection',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            _clusterCard(
              'Nashik',
              'High-risk cluster',
              '8 suspected cases within nearby villages',
              'Foot-and-Mouth Disease',
              Colors.red,
              Icons.hub_outlined,
            ),

            const SizedBox(height: 10),

            _clusterCard(
              'Pune',
              'Emerging cluster',
              '5 cases reported in the last 7 days',
              'Suspected infectious disease',
              Colors.orange,
              Icons.hub_outlined,
            ),

            const SizedBox(height: 10),

            _clusterCard(
              'Latur',
              'Low-risk cluster',
              '3 geographically linked reports',
              'Monitoring recommended',
              Colors.blue,
              Icons.hub_outlined,
            ),

            const SizedBox(height: 28),

            // -----------------------------------------------------------------
            // VACCINATION PRIORITIZATION
            // -----------------------------------------------------------------

            InkWell(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const VaccinationPriorityScreen(),
      ),
    );
  },
  borderRadius: BorderRadius.circular(10),
  child: const Padding(
    padding: EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Vaccination Prioritization',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
        Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
        ),
      ],
    ),
  ),
),

            const SizedBox(height: 12),

            _vaccinationPriorityCard(
              'Nashik',
              'Priority 1',
              'High disease risk • 62% coverage',
              Colors.red,
            ),

            const SizedBox(height: 10),

            _vaccinationPriorityCard(
              'Latur',
              'Priority 2',
              'Moderate disease risk • 68% coverage',
              Colors.orange,
            ),

            const SizedBox(height: 10),

            _vaccinationPriorityCard(
              'Pune',
              'Priority 3',
              'Moderate disease risk • 74% coverage',
              Colors.blue,
            ),

            const SizedBox(height: 28),

            // -----------------------------------------------------------------
// VETERINARY RESPONSE PRIORITIZATION
// -----------------------------------------------------------------
const Text(
  'Veterinary Response Prioritization',
  style: TextStyle(
    fontSize: 19,
    fontWeight: FontWeight.bold,
  ),
),
const SizedBox(height: 12),
_buildVeterinaryPrioritySection(),
const SizedBox(height: 28),

            // -----------------------------------------------------------------
            // DETECTED DISEASE CLUSTERS
            // -----------------------------------------------------------------

            const Text(
              'Detected Disease Clusters',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            _buildClusterSection(),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // AI CLUSTER DETECTION
  // ---------------------------------------------------------------------------

  Widget _buildClusterSection() {
    final List<DiseaseCluster> clusters =
        ClusterDetectionService.instance.detectClusters();

    if (clusters.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
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
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'No significant disease clusters detected.',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        for (final cluster in clusters)
          _diseaseClusterCard(cluster),
      ],
    );
  }

  Widget _buildVeterinaryPrioritySection() {
  final priorities =
      VeterinaryResponsePriorityService.instance.calculatePriorities();

  if (priorities.isEmpty) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Text(
        'No veterinary response priorities identified.',
        style: TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  return Column(
    children: [
      for (final item in priorities.take(4))
        _veterinaryPriorityCard(item),
    ],
  );
}

Widget _veterinaryPriorityCard(
  VeterinaryResponsePriority item,
) {
  final Color color;

  switch (item.priority) {
    case 'Critical':
      color = Colors.red;
      break;
    case 'High':
      color = Colors.orange;
      break;
    case 'Moderate':
      color = Colors.blue;
      break;
    default:
      color = Colors.green;
  }

  return Container(
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.07),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: color.withValues(alpha: 0.15),
      ),
    ),
    child: Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.medical_services_outlined,
            color: color,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.healthCase.animal.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.healthCase.location,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.reason,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 9,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            item.priority,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}

  Widget _diseaseClusterCard(DiseaseCluster cluster) {
    final Color color;

switch (cluster.severity) {
  case CaseSeverity.low:
    color = Colors.green;
    break;
  case CaseSeverity.moderate:
    color = Colors.orange;
    break;
  case CaseSeverity.high:
    color = Colors.red;
    break;
  case CaseSeverity.critical:
    color = Colors.red.shade900;
    break;
}

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.hub_outlined,
                  color: color,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cluster.disease,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      cluster.location,
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
                  horizontal: 9,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  cluster.severityLabel,
                  style: TextStyle(
                    color: color,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              const Icon(
                Icons.assignment_outlined,
                size: 17,
                color: Colors.grey,
              ),

              const SizedBox(width: 7),

              Text(
                '${cluster.caseCount} related cases',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            '${cluster.highRiskCases} high-risk cases detected among '
            '${cluster.caseCount} related cases.',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // STATIC CLUSTER CARD
  // ---------------------------------------------------------------------------

  Widget _clusterCard(
    String district,
    String riskLevel,
    String details,
    String disease,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              icon,
              color: color,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        district,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),

                    Text(
                      riskLevel,
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                Text(
                  disease,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  details,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // VACCINATION PRIORITY
  // ---------------------------------------------------------------------------

  Widget _vaccinationPriorityCard(
    String district,
    String priority,
    String details,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.vaccines_outlined,
              color: color,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  district,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  details,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
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
              color: color.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              priority,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // HEADER
  // ---------------------------------------------------------------------------

  Widget _header() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.primary,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RoleBadge(
            role: widget.user.role,
          ),

          const SizedBox(height: 16),

          Text(
            'Namaskar, ${_firstName(widget.user.name)} 👋',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            widget.user.governmentLevel ?? 'Government Officer',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            widget.user.location,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // MAP PREVIEW
  // ---------------------------------------------------------------------------

  Widget _mapPreview() {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFE5ECE8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.06),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: _MapPainter(),
                  ),
                ),

                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.map_outlined,
                          size: 17,
                          color: AppTheme.primary,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Disease Risk Map',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                _mapMarker(
                  constraints.maxWidth,
                  constraints.maxHeight,
                  0.58,
                  0.30,
                  Colors.red,
                ),

                _mapMarker(
                  constraints.maxWidth,
                  constraints.maxHeight,
                  0.43,
                  0.56,
                  Colors.orange,
                ),

                _mapMarker(
                  constraints.maxWidth,
                  constraints.maxHeight,
                  0.69,
                  0.62,
                  Colors.green,
                ),

                _mapMarker(
                  constraints.maxWidth,
                  constraints.maxHeight,
                  0.30,
                  0.72,
                  Colors.orange,
                ),

                Positioned(
                  bottom: 14,
                  right: 14,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        currentIndex = 1;
                      });
                    },
                    icon: const Icon(
                      Icons.open_in_full,
                      size: 16,
                    ),
                    label: const Text('View Map'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(0, 42),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _mapMarker(
    double width,
    double height,
    double x,
    double y,
    Color color,
  ) {
    const double markerSize = 18;

    return Positioned(
      left: (width * x) - (markerSize / 2),
      top: (height * y) - (markerSize / 2),
      child: Container(
        width: markerSize,
        height: markerSize,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 3,
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // DISTRICT CARD
  // ---------------------------------------------------------------------------

  Widget _districtCard(
    String name,
    String subtitle,
    double progress,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.location_city_outlined,
                color: AppTheme.primary,
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 11,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          LinearProgressIndicator(
            value: progress,
            minHeight: 7,
            borderRadius: BorderRadius.circular(10),
            color: color,
            backgroundColor: color.withValues(alpha: 0.10),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // ALERTS
  // ---------------------------------------------------------------------------

  Widget _alertCard(
    String title,
    String subtitle,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: 0.12),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              icon,
              color: color,
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
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 11,
                  ),
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
    );
  }

  Widget _alertsPage() {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Alerts',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'Disease surveillance alerts requiring attention.',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 22),

          _alertCard(
            'High-risk cluster detected',
            'Nashik • 8 suspected cases',
            Colors.red,
            Icons.warning_amber_rounded,
          ),

          const SizedBox(height: 12),

          _alertCard(
            'Case reports increasing',
            'Pune • 7-day trend',
            Colors.orange,
            Icons.trending_up,
          ),

          const SizedBox(height: 12),

          _alertCard(
            'Vaccination coverage below target',
            'Latur • 68% coverage',
            Colors.blue,
            Icons.vaccines_outlined,
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // PROFILE
  // ---------------------------------------------------------------------------

  Widget _profilePage() {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Profile',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 24),

          Center(
            child: CircleAvatar(
              radius: 44,
              backgroundColor:
                  AppTheme.primary.withValues(alpha: 0.10),
              child: const Icon(
                Icons.account_balance,
                size: 42,
                color: AppTheme.primary,
              ),
            ),
          ),

          const SizedBox(height: 14),

          Center(
            child: Text(
              widget.user.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 5),

          Center(
            child: Text(
              widget.user.governmentLevel ??
                  'Government Officer',
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ),

          const SizedBox(height: 25),

          _profileTile(
            Icons.badge_outlined,
            'Officer ID',
            widget.user.id,
          ),

          _profileTile(
            Icons.email_outlined,
            'Email',
            widget.user.email,
          ),

          _profileTile(
            Icons.location_on_outlined,
            'Jurisdiction',
            widget.user.location,
          ),

          _profileTile(
            Icons.language,
            'Language',
            'English / मराठी',
          ),
        ],
      ),
    );
  }

  Widget _profileTile(
    IconData icon,
    String title,
    String value,
  ) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        vertical: 3,
      ),
      leading: Icon(
        icon,
        color: AppTheme.primary,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(value),
    );
  }

  // ---------------------------------------------------------------------------
  // HELPERS
  // ---------------------------------------------------------------------------

  String _firstName(String name) {
    final String trimmed = name.trim();

    if (trimmed.isEmpty) {
      return name;
    }

    final List<String> parts = trimmed.split(RegExp(r'\s+'));

    return parts.first;
  }
}

// -----------------------------------------------------------------------------
// MAP PAINTER
// -----------------------------------------------------------------------------

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.7)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    for (double x = 0; x < size.width; x += 42) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    for (double y = 0; y < size.height; y += 42) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}