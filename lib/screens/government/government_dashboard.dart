import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../models/user.dart';
import '../../widgets/dashboard_card.dart';
import '../../widgets/role_badge.dart';

import '../gis/gis_screen.dart';
import '../../core/utils/logout.dart';


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
            onPressed: () {},
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

            const Text(
              'Recent Alerts',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            _alertCard(
              'High-risk cluster detected',
              'Nashik district • 8 suspected cases',
              Colors.red,
              Icons.warning_amber_rounded,
            ),

            const SizedBox(height: 10),

            _alertCard(
              'Increased case reports',
              'Pune district • Last 7 days',
              Colors.orange,
              Icons.trending_up,
            ),

            const SizedBox(height: 20),

SizedBox(
  width: double.infinity,
  height: 50,
  child: OutlinedButton.icon(
    onPressed: () {
      logout(context);
    },
    icon: const Icon(
      Icons.logout,
      color: Colors.red,
    ),
    label: const Text(
      'Logout',
      style: TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
),
          ],
        ),
      ),
    );
  }

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
          RoleBadge(role: widget.user.role),
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
      child: Stack(
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
          _mapMarker(0.58, 0.30, Colors.red),
          _mapMarker(0.43, 0.56, Colors.orange),
          _mapMarker(0.69, 0.62, Colors.green),
          _mapMarker(0.30, 0.72, Colors.orange),
          Positioned(
            bottom: 14,
            right: 14,
            child: ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  currentIndex = 1;
                });
              },
              icon: const Icon(Icons.open_in_full, size: 16),
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
      ),
    );
  }

  Widget _mapMarker(
    double x,
    double y,
    Color color,
  ) {
    return Positioned(
      left: MediaQuery.of(context).size.width * x,
      top: 220 * y,
      child: Container(
        width: 18,
        height: 18,
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
      contentPadding: const EdgeInsets.symmetric(vertical: 3),
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

  String _firstName(String name) {
    final parts = name.trim().split(' ');
    return parts.isEmpty ? name : parts.first;
  }
}


class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
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