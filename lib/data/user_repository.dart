import '../models/user.dart';

class UserRepository {
  UserRepository._();

  static final UserRepository instance = UserRepository._();

  final List<AppUser> _users = [
    const AppUser(
      id: 'USR001',
      name: 'Ramesh Patil',
      email: 'ramesh@example.com',
      password: 'password',
      role: UserRole.farmer,
      location: 'Nashik',
    ),
    const AppUser(
      id: 'USR002',
      name: 'Dr. Priya Patil',
      email: 'priya@example.com',
      password: 'password',
      role: UserRole.veterinarian,
      location: 'Nashik',
    ),
    const AppUser(
      id: 'USR003',
      name: 'Amit Deshmukh',
      email: 'amit@example.com',
      password: 'password',
      role: UserRole.government,
      location: 'Pune',
      governmentLevel: 'District',
    ),
    const AppUser(
      id: 'USR004',
      name: 'Admin User',
      email: 'admin@example.com',
      password: 'password',
      role: UserRole.admin,
      location: 'Maharashtra',
    ),
  ];

  List<AppUser> get users => List.unmodifiable(_users);

  AppUser? findUser(String id) {
    for (final user in _users) {
      if (user.id == id) {
        return user;
      }
    }

    return null;
  }

  void updateUser(AppUser updatedUser) {
    final index = _users.indexWhere(
      (user) => user.id == updatedUser.id,
    );

    if (index != -1) {
      _users[index] = updatedUser;
    }
  }

  void addUser(AppUser user) {
    _users.add(user);
  }
}