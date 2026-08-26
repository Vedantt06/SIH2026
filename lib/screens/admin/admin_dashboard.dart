import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../models/user.dart';
import '../../widgets/dashboard_card.dart';
import '../../widgets/role_badge.dart';

import '../gis/gis_screen.dart';
import '../../core/utils/logout.dart';
import '../../data/user_repository.dart';

class AdminDashboard extends StatefulWidget {
  final AppUser user;

  const AdminDashboard({
    super.key,
    required this.user,
  });

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
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
    icon: Icon(Icons.people_outline),
    selectedIcon: Icon(Icons.people),
    label: 'Users',
  ),
  NavigationDestination(
    icon: Icon(Icons.map_outlined),
    selectedIcon: Icon(Icons.map),
    label: 'GIS',
  ),
  NavigationDestination(
    icon: Icon(Icons.analytics_outlined),
    selectedIcon: Icon(Icons.analytics),
    label: 'Activity',
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
      return _usersPage();

    case 2:
      return GisScreen(
        role: widget.user.role,
      );

    case 3:
      return _activityPage();

    case 4:
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

            const SizedBox(height: 24),

            const Text(
              'System Overview',
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
                    title: 'Farmers',
                    value: '4,286',
                    subtitle: 'Registered users',
                    icon: Icons.agriculture_outlined,
                    iconColor: AppTheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DashboardCard(
                    title: 'Veterinarians',
                    value: '86',
                    subtitle: 'Active users',
                    icon: Icons.medical_services_outlined,
                    iconColor: Colors.blue,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: DashboardCard(
                    title: 'Cases',
                    value: '1,842',
                    subtitle: 'All-time reports',
                    icon: Icons.assignment_outlined,
                    iconColor: Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DashboardCard(
                    title: 'High Risk',
                    value: '18',
                    subtitle: 'Active cases',
                    icon: Icons.warning_amber_rounded,
                    iconColor: Colors.red,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            const Text(
              'System Health',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            _systemHealthCard(),

            const SizedBox(height: 28),

            const Text(
              'Quick Administration',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            _adminAction(
              Icons.person_add_alt_1_outlined,
              'Manage Users',
              'View and manage platform users',
              () {
                setState(() {
                  currentIndex = 1;
                });
              },
            ),

            const SizedBox(height: 10),

            _adminAction(
  Icons.security_outlined,
  'Roles & Permissions',
  'Manage access levels',
  () {
    _showPermissionsDialog();
  },
),

            const SizedBox(height: 10),

            _adminAction(
  Icons.storage_outlined,
  'Master Data',
  'Manage diseases, locations and reference data',
  () {
    _showMasterDataDialog();
  },
),

const SizedBox(height: 10),

_adminAction(
  Icons.menu_book_outlined,
  'Disease Knowledge Base',
  'Manage disease information and response guidance',
  () {
    _showDiseaseKnowledgeDialog();
  },
),

const SizedBox(height: 10),

_adminAction(
  Icons.history_outlined,
  'Audit Logs',
  'View important system activity',
  () {
    _showAuditLogsDialog();
  },
),

const SizedBox(height: 10),

_adminAction(
  Icons.monitor_heart_outlined,
  'System Monitoring',
  'Monitor platform health and services',
  () {
    _showSystemMonitoringDialog();
  },
),

const SizedBox(height: 10),

            _adminAction(
              Icons.settings_outlined,
              'System Settings',
              'Configure platform settings',
              () {},
            ),

            const SizedBox(height: 28),

            const Text(
              'Recent Activity',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            _activityTile(
              Icons.person_add_outlined,
              'New farmer registered',
              'Nashik • 8 minutes ago',
              Colors.green,
            ),

            _activityTile(
              Icons.assignment_outlined,
              'New health case submitted',
              'Pune • 21 minutes ago',
              Colors.orange,
            ),

            _activityTile(
              Icons.medical_services_outlined,
              'Veterinarian account updated',
              'Latur • 1 hour ago',
              Colors.blue,
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

  void _showPermissionsDialog() {
  String selectedRole = 'Farmer';

  final permissions = {
    'Farmer': [
      'View own animals',
      'Report sick animals',
      'Track submitted cases',
    ],
    'Veterinarian': [
      'View assigned cases',
      'Perform clinical assessment',
      'Request laboratory tests',
      'Confirm diagnosis',
    ],
    'Government': [
      'View surveillance dashboard',
      'Access GIS map',
      'View disease analytics',
      'View alerts and clusters',
    ],
    'Admin': [
      'Manage users',
      'Manage roles and permissions',
      'Manage master data',
      'View audit logs',
      'Monitor system health',
    ],
  };

  showDialog(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text(
              'Roles & Permissions',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select a role to view its access levels.',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 16),

                  DropdownButtonFormField<String>(
                    value: selectedRole,
                    decoration: const InputDecoration(
                      labelText: 'Role',
                      border: OutlineInputBorder(),
                    ),
                    items: permissions.keys.map((role) {
                      return DropdownMenuItem(
                        value: role,
                        child: Text(role),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setDialogState(() {
                          selectedRole = value;
                        });
                      }
                    },
                  ),

                  const SizedBox(height: 18),

                  const Text(
                    'Permissions',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 8),

                  ...permissions[selectedRole]!.map(
                    (permission) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 7),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.check_circle_outline,
                              color: Colors.green,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                permission,
                                style: const TextStyle(
                                  fontSize: 13,
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
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
    },
  );
}

void _showMasterDataDialog() {
  String selectedCategory = 'Diseases';

  final masterData = {
    'Diseases': [
      'Foot-and-Mouth Disease',
      'Hemorrhagic Septicemia',
      'Brucellosis',
      'Anthrax',
    ],
    'Animal Types': [
      'Cattle',
      'Buffalo',
      'Goat',
      'Sheep',
    ],
    'Districts': [
      'Nashik',
      'Pune',
      'Latur',
      'Nagpur',
      'Kolhapur',
    ],
    'Severity Levels': [
      'Low',
      'Moderate',
      'High',
      'Critical',
    ],
  };

  showDialog(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          final items = masterData[selectedCategory]!;

          return AlertDialog(
            title: const Text(
              'Master Data',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Manage platform reference data.',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 16),

                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                    items: masterData.keys.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setDialogState(() {
                          selectedCategory = value;
                        });
                      }
                    },
                  ),

                  const SizedBox(height: 16),

                  Text(
                    selectedCategory,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 8),

                  ...items.map(
                    (item) {
                      return ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(
                          Icons.circle,
                          size: 8,
                        ),
                        title: Text(
                          item,
                          style: const TextStyle(
                            fontSize: 13,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.edit_outlined,
                          size: 18,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
    },
  );
}

void _showDiseaseKnowledgeDialog() {
  String selectedDisease = 'Foot-and-Mouth Disease';

  final diseaseData = {
    'Foot-and-Mouth Disease': {
      'Risk Level': 'High',
      'Symptoms':
          'Fever, mouth lesions, excessive salivation and difficulty walking.',
      'Transmission':
          'Highly contagious through direct contact, contaminated equipment and animal movement.',
      'Recommended Response':
          'Isolate suspected animals and immediately notify a veterinarian.',
      'Status': 'Active',
    },
    'Hemorrhagic Septicemia': {
      'Risk Level': 'High',
      'Symptoms':
          'Fever, swelling of the throat region, breathing difficulty and sudden weakness.',
      'Transmission':
          'Spread through infected animals, contaminated water and close contact.',
      'Recommended Response':
          'Separate affected animals and arrange urgent veterinary assessment.',
      'Status': 'Active',
    },
    'Brucellosis': {
      'Risk Level': 'Medium',
      'Symptoms':
          'Reproductive problems, abortion and reduced fertility.',
      'Transmission':
          'Transmission can occur through contact with infected reproductive material.',
      'Recommended Response':
          'Report suspected cases and arrange veterinary testing.',
      'Status': 'Active',
    },
    'Anthrax': {
      'Risk Level': 'Critical',
      'Symptoms':
          'Sudden fever, weakness, bleeding and rapid deterioration.',
      'Transmission':
          'Spores can persist in contaminated soil and may infect animals through exposure.',
      'Recommended Response':
          'Avoid opening carcasses and immediately contact veterinary authorities.',
      'Status': 'Active',
    },
  };

  showDialog(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          final data = diseaseData[selectedDisease]!;

          return AlertDialog(
            title: const Text(
              'Disease Knowledge Base',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'View disease information and response guidance.',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(height: 16),

                    DropdownButtonFormField<String>(
                      value: selectedDisease,
                      decoration: const InputDecoration(
                        labelText: 'Disease',
                        border: OutlineInputBorder(),
                      ),
                      items: diseaseData.keys.map((disease) {
                        return DropdownMenuItem<String>(
                          value: disease,
                          child: Text(disease),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            selectedDisease = value;
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 18),

                    _knowledgeRow(
                      'Risk Level',
                      data['Risk Level']!,
                    ),

                    _knowledgeRow(
                      'Symptoms',
                      data['Symptoms']!,
                    ),

                    _knowledgeRow(
                      'Transmission',
                      data['Transmission']!,
                    ),

                    _knowledgeRow(
                      'Recommended Response',
                      data['Recommended Response']!,
                    ),

                    _knowledgeRow(
                      'Status',
                      data['Status']!,
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
    },
  );
}

void _showAuditLogsDialog() {
  final logs = [
    {
      'action': 'New farmer registered',
      'user': 'Ramesh Patil',
      'location': 'Nashik',
      'time': '8 minutes ago',
    },
    {
      'action': 'Health case submitted',
      'user': 'Farmer account',
      'location': 'Pune',
      'time': '21 minutes ago',
    },
    {
      'action': 'Veterinarian account updated',
      'user': 'Dr. Rahul Sharma',
      'location': 'Latur',
      'time': '1 hour ago',
    },
    {
      'action': 'Disease information updated',
      'user': 'Admin',
      'location': 'System',
      'time': '2 hours ago',
    },
    {
      'action': 'User permissions modified',
      'user': 'Admin',
      'location': 'System',
      'time': '3 hours ago',
    },
  ];

  showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text(
          'Audit Logs',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: ListView.separated(
            itemCount: logs.length,
            separatorBuilder: (_, __) {
              return const Divider(height: 18);
            },
            itemBuilder: (context, index) {
              final log = logs[index];

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 18,
                    backgroundColor: Color(0xFFE8F5E9),
                    child: Icon(
                      Icons.history,
                      size: 18,
                      color: Colors.green,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          log['action']!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          '${log['user']} • ${log['location']}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 11,
                          ),
                        ),

                        const SizedBox(height: 3),

                        Text(
                          log['time']!,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
            },
            child: const Text('Close'),
          ),
        ],
      );
    },
  );
}

void _showSystemMonitoringDialog() {
  final services = [
    {
      'name': 'Application',
      'status': 'Operational',
      'icon': Icons.apps_outlined,
    },
    {
      'name': 'Authentication',
      'status': 'Operational',
      'icon': Icons.lock_outline,
    },
    {
      'name': 'Case Management',
      'status': 'Operational',
      'icon': Icons.assignment_outlined,
    },
    {
      'name': 'Surveillance Data',
      'status': 'Operational',
      'icon': Icons.analytics_outlined,
    },
    {
      'name': 'Database',
      'status': 'Operational',
      'icon': Icons.storage_outlined,
    },
  ];

  showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text(
          'System Monitoring',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: Colors.green,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            'All Systems Operational',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            'No critical issues detected.',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              const Text(
                'Services',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 8),

              ...services.map(
                (service) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.black12,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            service['icon'] as IconData,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              service['name'] as String,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.circle,
                            size: 9,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            service['status'] as String,
                            style: const TextStyle(
                              color: Colors.green,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
            },
            child: const Text('Close'),
          ),
        ],
      );
    },
  );
}

Widget _knowledgeRow(
  String title,
  String value,
) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
            height: 1.4,
          ),
        ),
      ],
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
            'Welcome, ${widget.user.name.split(' ').first} 👋',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Platform Administration',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _systemHealthCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
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
                  color: Colors.green.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'All systems operational',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Prototype environment is running normally.',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const Text(
                'ONLINE',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Divider(height: 1),
          const SizedBox(height: 14),
          const Row(
            children: [
              Expanded(
                child: _HealthItem(
                  title: 'API',
                  status: 'Online',
                ),
              ),
              Expanded(
                child: _HealthItem(
                  title: 'Storage',
                  status: 'Online',
                ),
              ),
              Expanded(
                child: _HealthItem(
                  title: 'Auth',
                  status: 'Online',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _adminAction(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
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
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.09),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  icon,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(width: 13),
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
        ),
      ),
    );
  }

  Widget _usersPage() {
  final users = UserRepository.instance.users;

  return SafeArea(
    child: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'User Management',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 6),

        const Text(
          'Manage users and their platform roles.',
          style: TextStyle(
            color: Colors.grey,
          ),
        ),

        const SizedBox(height: 22),

        ...users.map(
          (user) {
            final roleInfo = _roleDisplayInfo(user.role);

            return _userCard(
              user.id,
              user.name,
              _roleLabel(user.role),
              user.location,
              roleInfo['icon'] as IconData,
              roleInfo['color'] as Color,
              user.isActive,
            );
          },
        ),
      ],
    ),
  );
}

String _roleLabel(UserRole role) {
  switch (role) {
    case UserRole.farmer:
      return 'Farmer';

    case UserRole.veterinarian:
      return 'Veterinarian';

    case UserRole.government:
      return 'Government Officer';

    case UserRole.admin:
      return 'Administrator';
  }
}

UserRole _roleFromLabel(String role) {
  switch (role) {
    case 'Farmer':
      return UserRole.farmer;

    case 'Veterinarian':
      return UserRole.veterinarian;

    case 'Government':
      return UserRole.government;

    case 'Admin':
      return UserRole.admin;

    default:
      return UserRole.farmer;
  }
}

Map<String, dynamic> _roleDisplayInfo(UserRole role) {
  switch (role) {
    case UserRole.farmer:
      return {
        'icon': Icons.agriculture_outlined,
        'color': Colors.green,
      };

    case UserRole.veterinarian:
      return {
        'icon': Icons.medical_services_outlined,
        'color': Colors.blue,
      };

    case UserRole.government:
      return {
        'icon': Icons.account_balance_outlined,
        'color': Colors.orange,
      };

    case UserRole.admin:
      return {
        'icon': Icons.admin_panel_settings_outlined,
        'color': Colors.purple,
      };
  }
}

  Widget _userCard(
  String userId,
  String name,
  String role,
  String location,
  IconData icon,
  Color color,
  bool isActive,
) {
  return Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: color.withValues(alpha: 0.10),
          child: Icon(
            icon,
            color: color,
            size: 23,
          ),
        ),

        const SizedBox(width: 13),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                role,
                style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                location,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 10,
                ),
              ),
              const SizedBox(height: 5),

Row(
  mainAxisSize: MainAxisSize.min,
  children: [
    Container(
      width: 7,
      height: 7,
      decoration: BoxDecoration(
        color: isActive
            ? Colors.green
            : Colors.red,
        shape: BoxShape.circle,
      ),
    ),

    const SizedBox(width: 5),

    Text(
      isActive ? 'Active' : 'Disabled',
      style: TextStyle(
        color: isActive
            ? Colors.green
            : Colors.red,
        fontSize: 10,
        fontWeight: FontWeight.w600,
      ),
    ),
  ],
),
            ],
          ),
        ),

        IconButton(
          onPressed: () {
            _showUserManagementDialog(
              userId: userId,  
              name: name,
              role: role,
              location: location,
              color: color,
            );
          },
          icon: const Icon(
            Icons.more_vert,
          ),
        ),
      ],
    ),
  );
}

void _showUserManagementDialog({
  required String userId,  
  required String name,
  required String role,
  required String location,
  required Color color,
}) {
  final existingUser =
    UserRepository.instance.findUser(userId);

bool isActive = existingUser?.isActive ?? true;
  String selectedRole = role;

  showDialog(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Text(name),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  location,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 18),

                const Text(
                  'Role',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 6),

                DropdownButtonFormField<String>(
                  value: selectedRole,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Farmer',
                      child: Text('Farmer'),
                    ),
                    DropdownMenuItem(
                      value: 'Veterinarian',
                      child: Text('Veterinarian'),
                    ),
                    DropdownMenuItem(
                      value: 'Government',
                      child: Text('Government'),
                    ),
                    DropdownMenuItem(
                      value: 'Admin',
                      child: Text('Admin'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setDialogState(() {
                        selectedRole = value;
                      });
                    }
                  },
                ),

                const SizedBox(height: 14),

                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Account Active',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    Switch(
                      value: isActive,
                      onChanged: (value) {
                        setDialogState(() {
                          isActive = value;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),

            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                child: const Text('Cancel'),
              ),

              ElevatedButton(
  onPressed: () {
    final existingUser =
        UserRepository.instance.findUser(userId);

    if (existingUser != null) {
      UserRepository.instance.updateUser(
        AppUser(
          id: existingUser.id,
          name: existingUser.name,
          email: existingUser.email,
          password: existingUser.password,
          role: _roleFromLabel(selectedRole),
          location: existingUser.location,
          governmentLevel: existingUser.governmentLevel,
          isActive: isActive,
        ),
      );
    }

    Navigator.pop(dialogContext);

    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$name updated successfully',
        ),
      ),
    );
  },
  child: const Text('Save'),
),
            ],
          );
        },
      );
    },
  );
}

  Widget _activityPage() {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'System Activity',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Recent activity across the platform.',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 22),
          _activityTile(
            Icons.person_add_outlined,
            'New farmer registered',
            'Ramesh Patil • Nashik • 8 minutes ago',
            Colors.green,
          ),
          _activityTile(
            Icons.assignment_outlined,
            'New health case submitted',
            'Case #MH-PN-00342 • 21 minutes ago',
            Colors.orange,
          ),
          _activityTile(
            Icons.medical_services_outlined,
            'Veterinarian account updated',
            'Dr. Priya Kulkarni • 1 hour ago',
            Colors.blue,
          ),
          _activityTile(
            Icons.warning_amber_rounded,
            'High-risk case flagged',
            'Case #MH-NK-00124 • 2 hours ago',
            Colors.red,
          ),
          _activityTile(
            Icons.vaccines_outlined,
            'Vaccination record updated',
            'Nashik district • 3 hours ago',
            Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _activityTile(
    IconData icon,
    String title,
    String subtitle,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 21,
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
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
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
                Icons.admin_panel_settings_outlined,
                size: 44,
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
              'System Administrator',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 25),
          _profileTile(
            Icons.badge_outlined,
            'Administrator ID',
            widget.user.id,
          ),
          _profileTile(
            Icons.email_outlined,
            'Email',
            widget.user.email,
          ),
          _profileTile(
            Icons.location_on_outlined,
            'Region',
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
}

class _HealthItem extends StatelessWidget {
  final String title;
  final String status;

  const _HealthItem({
    required this.title,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 7,
              height: 7,
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              status,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ],
    );
  }
}