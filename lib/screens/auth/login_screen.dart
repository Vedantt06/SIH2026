import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../data/mock_users.dart';
import '../../models/user.dart';

import '../admin/admin_dashboard.dart';
import '../farmer/farmer_dashboard.dart';
import '../government/government_dashboard.dart';
import '../veterinarian/vet_dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscurePassword = true;
  bool isLoading = false;
  String? errorMessage;

  Future<void> _login() async {
    FocusScope.of(context).unfocus();

    final email = emailController.text.trim().toLowerCase();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        errorMessage = 'Please enter your email and password.';
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    await Future.delayed(
      const Duration(milliseconds: 600),
    );

    AppUser? user;

    for (final item in mockUsers) {
      if (item.email.toLowerCase() == email &&
          item.password == password) {
        user = item;
        break;
      }
    }

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    if (user == null) {
      setState(() {
        errorMessage = 'Invalid email or password.';
      });
      return;
    }

    // Dashboard navigation will be connected in the next step.
    Widget destination;

switch (user.role) {
  case UserRole.farmer:
    destination = FarmerDashboard(user: user);
    break;

  case UserRole.veterinarian:
    destination = VetDashboard(user: user);
    break;

  case UserRole.government:
    destination = GovernmentDashboard(user: user);
    break;

  case UserRole.admin:
    destination = AdminDashboard(user: user);
    break;
}

Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (_) => destination,
  ),
);

  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              24,
              30,
              24,
              24,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 480,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 76,
                      height: 76,
                      decoration: BoxDecoration(
                        color: AppTheme.primary,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: const Icon(
                        Icons.pets,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Center(
                    child: Text(
                      'MahaPashu Suraksha',
                      style: TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 7),

                  const Center(
                    child: Text(
                      'Maharashtra Livestock Health & Disease Surveillance',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                    ),
                  ),

                  const SizedBox(height: 42),

                  const Text(
                    'Welcome back',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 7),

                  const Text(
                    'Sign in to access your MahaPashu dashboard.',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 28),

                  const Text(
                    'Email',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      hintText: 'Enter your email',
                      prefixIcon: Icon(
                        Icons.email_outlined,
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  const Text(
                    'Password',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextField(
                    controller: passwordController,
                    obscureText: obscurePassword,
                    onSubmitted: (_) => _login(),
                    decoration: InputDecoration(
                      hintText: 'Enter your password',
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            obscurePassword = !obscurePassword;
                          });
                        },
                        icon: Icon(
                          obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // Will be connected to Forgot Password screen.
                      },
                      child: const Text(
                        'Forgot password?',
                      ),
                    ),
                  ),

                  if (errorMessage != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(
                          alpha: 0.08,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              errorMessage!,
                              style: const TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: isLoading ? null : _login,
                    child: isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),

                  const SizedBox(height: 24),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withValues(
                        alpha: 0.06,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 18,
                              color: AppTheme.primary,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Prototype Demo Accounts',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 12),

                        Text(
                          'Farmer: demo.farmer@maha.com\n'
                          'Veterinarian: demo.vet@maha.com\n'
                          'Government: demo.gov@maha.com\n'
                          'Admin: demo.admin@maha.com\n\n'
                          'Password: 1234',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}