import 'package:flutter/material.dart';

import '../../screens/auth/login_screen.dart';

void logout(BuildContext context) {
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(
      builder: (_) => const LoginScreen(),
    ),
    (route) => false,
  );
}