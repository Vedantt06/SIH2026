import 'package:flutter/material.dart';

import '../models/user.dart';

class RoleBadge extends StatelessWidget {
  final UserRole role;

  const RoleBadge({
    super.key,
    required this.role,
  });

  String get label {
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

  IconData get icon {
    switch (role) {
      case UserRole.farmer:
        return Icons.agriculture_outlined;
      case UserRole.veterinarian:
        return Icons.medical_services_outlined;
      case UserRole.government:
        return Icons.account_balance_outlined;
      case UserRole.admin:
        return Icons.admin_panel_settings_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 15,
            color: Colors.white,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}