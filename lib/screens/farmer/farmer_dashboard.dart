import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/logout.dart';
import '../../models/user.dart';
import '../../widgets/dashboard_card.dart';
import '../../widgets/role_badge.dart';

import '../gis/gis_screen.dart';
import 'animals_screen.dart';
import 'farmer_cases_screen.dart';


class FarmerDashboard extends StatefulWidget {
  final AppUser user;

  const FarmerDashboard({
    super.key,
    required this.user,
  });

  @override
  State<FarmerDashboard> createState() => _FarmerDashboardState();
}

class _FarmerDashboardState extends State<FarmerDashboard> {
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
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: 'Home',
            ),
            NavigationDestination(
                icon: Icon(Icons.pets_outlined),
                selectedIcon: Icon(Icons.pets),
                label: 'Animals',
            ),
            NavigationDestination(
                icon: Icon(Icons.map_outlined),
                selectedIcon: Icon(Icons.map),
                label: 'Map',
            ),
            NavigationDestination(
                icon: Icon(Icons.assignment_outlined),
                selectedIcon: Icon(Icons.assignment),
                label: 'Cases',
            ),
            NavigationDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person),
                label: 'Profile',
            ),
        ],
      ),
      floatingActionButton: currentIndex == 0
          ? FloatingActionButton.extended(
              onPressed: () {},
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.mic_none_rounded),
              label: const Text('Report Health Issue'),
            )
          : null,
    );
  }

  Widget _buildBody() {
  switch (currentIndex) {
    case 1:
      return const AnimalsScreen();

    case 2:
      return GisScreen(
        role: widget.user.role,
      );

    case 3:
      return const FarmerCasesScreen();

    case 4:
      return _profilePage();

    default:
      return _homePage();
  }
}

  Widget _homePage() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _welcomeHeader(),

            const SizedBox(height: 22),

            Row(
              children: [
                Expanded(
                  child: DashboardCard(
                    title: 'Healthy Animals',
                    value: '8',
                    subtitle: 'No active concerns',
                    icon: Icons.favorite_outline,
                    iconColor: Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DashboardCard(
                    title: 'Under Observation',
                    value: '2',
                    subtitle: 'Needs monitoring',
                    icon: Icons.visibility_outlined,
                    iconColor: Colors.orange,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            _actionTile(
              icon: Icons.mic_none_rounded,
              title: 'Report an Animal Health Issue',
              subtitle: 'Describe symptoms using voice or text',
              onTap: () {},
            ),

            const SizedBox(height: 10),

            _actionTile(
              icon: Icons.add_circle_outline,
              title: 'Register New Animal',
              subtitle: 'Add an animal to your livestock records',
              onTap: () {},
            ),

            const SizedBox(height: 24),

            const Text(
              'Active Case',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            _caseCard(),

            const SizedBox(height: 24),

            const Text(
              'Health Reminder',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            _reminderCard(),

            const SizedBox(height: 25),

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

  Widget _welcomeHeader() {
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
            'Namaskar, ${widget.user.name.split(' ').first} 👋',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                color: Colors.white70,
                size: 16,
              ),
              const SizedBox(width: 5),
              Text(
                widget.user.location,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.09),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
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
    );
  }

  Widget _caseCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.medical_services_outlined,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Case #MH-NK-00124',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Cow #102 • Khillari',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              _statusBadge(
                'Under Review',
                Colors.orange,
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 14),
          const Row(
            children: [
              Icon(
                Icons.access_time,
                size: 16,
                color: Colors.grey,
              ),
              SizedBox(width: 7),
              Text(
                'Reported 2 hours ago',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _reminderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.blue.withValues(alpha: 0.12),
        ),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.vaccines_outlined,
            color: Colors.blue,
            size: 28,
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vaccination Reminder',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '2 animals are due for vaccination this month.',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(
    String text,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
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
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          CircleAvatar(
            radius: 42,
            backgroundColor: AppTheme.primary.withValues(alpha: 0.1),
            child: const Icon(
              Icons.person,
              size: 44,
              color: AppTheme.primary,
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
          const SizedBox(height: 4),
          Center(
            child: Text(
              widget.user.email,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 28),
          _profileTile(
            Icons.location_on_outlined,
            'Location',
            widget.user.location,
          ),
          _profileTile(
            Icons.translate,
            'Language',
            'English / मराठी',
          ),
          _profileTile(
            Icons.help_outline,
            'Help & Support',
            'Get assistance',
          ),
        ],
      ),
    );
  }

  Widget _profileTile(
    IconData icon,
    String title,
    String subtitle,
  ) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
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
      subtitle: Text(subtitle),
      trailing: const Icon(
        Icons.chevron_right,
        color: Colors.grey,
      ),
    );
  }
}