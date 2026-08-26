import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../models/user.dart';
import '../../widgets/dashboard_card.dart';
import '../../widgets/role_badge.dart';

import '../gis/gis_screen.dart';
import 'vet_cases_screen.dart';
import '../../core/utils/logout.dart';


class VetDashboard extends StatefulWidget {
  final AppUser user;

  const VetDashboard({
    super.key,
    required this.user,
  });

  @override
  State<VetDashboard> createState() => _VetDashboardState();
}

class _VetDashboardState extends State<VetDashboard> {
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
                label: 'Dashboard',
            ),
            NavigationDestination(
                icon: Icon(Icons.assignment_outlined),
                selectedIcon: Icon(Icons.assignment),
                label: 'Cases',
            ),
            NavigationDestination(
                icon: Icon(Icons.map_outlined),
                selectedIcon: Icon(Icons.map),
                label: 'Map',
            ),
            NavigationDestination(
                icon: Icon(Icons.location_on_outlined),
                selectedIcon: Icon(Icons.location_on),
                label: 'Visits',
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
      return const VetCasesScreen();

    case 2:
      return GisScreen(
        role: widget.user.role,
      );

    case 3:
      return _fieldPage();

    case 4:
      return _profilePage();

    default:
      return _dashboardPage();
  }
}

  Widget _dashboardPage() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _welcomeHeader(),

            const SizedBox(height: 22),

            Row(
              children: [
                Expanded(
                  child: DashboardCard(
                    title: 'High Risk',
                    value: '3',
                    subtitle: 'Priority cases',
                    icon: Icons.warning_amber_rounded,
                    iconColor: Colors.red,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DashboardCard(
                    title: 'Under Review',
                    value: '7',
                    subtitle: 'Cases awaiting action',
                    icon: Icons.pending_actions_outlined,
                    iconColor: Colors.orange,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: DashboardCard(
                    title: 'Visits Today',
                    value: '4',
                    subtitle: 'Scheduled visits',
                    icon: Icons.event_available_outlined,
                    iconColor: Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DashboardCard(
                    title: 'Lab Results',
                    value: '5',
                    subtitle: 'Awaiting review',
                    icon: Icons.science_outlined,
                    iconColor: Colors.purple,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Priority Cases',
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
                  child: const Text('View All'),
                ),
              ],
            ),

            const SizedBox(height: 8),

            _caseCard(
              caseId: 'MH-NK-00124',
              animal: 'Cow #102',
              breed: 'Khillari',
              location: 'Nashik',
              symptoms: 'Fever • Excessive salivation',
              risk: 'HIGH',
              riskColor: Colors.red,
            ),

            const SizedBox(height: 12),

            _caseCard(
              caseId: 'MH-NK-00121',
              animal: 'Goat #034',
              breed: 'Osmanabadi',
              location: 'Nashik',
              symptoms: 'Reduced appetite • Lethargy',
              risk: 'MEDIUM',
              riskColor: Colors.orange,
            ),

            const SizedBox(height: 28),

            const Text(
              'Today\'s Field Visits',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            _visitCard(
              time: '10:30 AM',
              farmer: 'Ramesh Patil',
              location: 'Nashik Rural',
              animal: 'Cow #102',
            ),

            const SizedBox(height: 10),

            _visitCard(
              time: '02:00 PM',
              farmer: 'Suresh Jadhav',
              location: 'Dindori',
              animal: 'Goat #034',
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
            'Good morning, ${_firstName(widget.user.name)} 👋',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
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
              Expanded(
                child: Text(
                  widget.user.location,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          const Text(
            'Your assigned livestock cases and field activities are shown below.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _caseCard({
    required String caseId,
    required String animal,
    required String breed,
    required String location,
    required String symptoms,
    required String risk,
    required Color riskColor,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: () {
          _showCaseDetails(
            caseId: caseId,
            animal: animal,
            breed: breed,
            location: location,
            symptoms: symptoms,
            risk: risk,
            riskColor: riskColor,
          );
        },
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: riskColor.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Icons.pets,
                      color: riskColor,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          caseId,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$animal • $breed',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  _riskBadge(
                    risk,
                    riskColor,
                  ),
                ],
              ),

              const SizedBox(height: 14),

              const Divider(height: 1),

              const SizedBox(height: 12),

              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    location,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 7),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.medical_information_outlined,
                    size: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      symptoms,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    color: Colors.grey,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _riskBadge(
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

  Widget _visitCard({
    required String time,
    required String farmer,
    required String location,
    required String animal,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.schedule,
                  size: 18,
                  color: AppTheme.primary,
                ),
                const SizedBox(height: 3),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  farmer,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$animal • $location',
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
    );
  }

  

 

  Widget _fieldPage() {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Field Activities',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'Your scheduled visits and field assignments.',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 22),

          _visitCard(
            time: '10:30 AM',
            farmer: 'Ramesh Patil',
            location: 'Nashik Rural',
            animal: 'Cow #102',
          ),

          const SizedBox(height: 12),

          _visitCard(
            time: '02:00 PM',
            farmer: 'Suresh Jadhav',
            location: 'Dindori',
            animal: 'Goat #034',
          ),

          const SizedBox(height: 12),

          _visitCard(
            time: '04:30 PM',
            farmer: 'Anil Shinde',
            location: 'Sinnar',
            animal: 'Cow #087',
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
                Icons.medical_services_outlined,
                size: 43,
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

          const Center(
            child: Text(
              'Veterinarian / Field Staff',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),

          const SizedBox(height: 5),

          Center(
            child: Text(
              widget.user.location,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ),

          const SizedBox(height: 30),

          _profileTile(
            Icons.badge_outlined,
            'Staff ID',
            widget.user.id,
          ),

          _profileTile(
            Icons.email_outlined,
            'Email',
            widget.user.email,
          ),

          _profileTile(
            Icons.language,
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
      subtitle: Text(subtitle),
      trailing: const Icon(
        Icons.chevron_right,
        color: Colors.grey,
      ),
    );
  }

  void _showCaseDetails({
    required String caseId,
    required String animal,
    required String breed,
    required String location,
    required String symptoms,
    required String risk,
    required Color riskColor,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(
            20,
            8,
            20,
            30,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      caseId,
                      style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _riskBadge(
                    risk,
                    riskColor,
                  ),
                ],
              ),

              const SizedBox(height: 18),

              _detailRow(
                'Animal',
                '$animal • $breed',
              ),

              _detailRow(
                'Location',
                location,
              ),

              _detailRow(
                'Reported Symptoms',
                symptoms,
              ),

              _detailRow(
                'Case Status',
                'Awaiting clinical examination',
              ),

              const SizedBox(height: 18),

              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.medical_information_outlined,
                ),
                label: const Text(
                  'Open Case',
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _detailRow(
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 125,
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _firstName(String name) {
    final parts = name.trim().split(' ');
    return parts.isEmpty ? name : parts.first;
  }
}