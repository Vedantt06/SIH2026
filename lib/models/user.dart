enum UserRole {
  farmer,
  veterinarian,
  government,
  admin,
}

class AppUser {
  final String id;
  final String name;
  final String email;
  final String password;
  final UserRole role;
  final String location;
  final String? governmentLevel;
  final bool isActive;

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    required this.location,
    this.governmentLevel,
    this.isActive = true,
  });
}