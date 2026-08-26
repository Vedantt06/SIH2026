import '../models/user.dart';

const List<AppUser> mockUsers = [
  AppUser(
    id: 'F001',
    name: 'Ramesh Patil',
    email: 'demo.farmer@maha.com',
    password: '1234',
    role: UserRole.farmer,
    location: 'Nashik, Maharashtra',
  ),

  AppUser(
    id: 'V001',
    name: 'Dr. Rahul Sharma',
    email: 'demo.vet@maha.com',
    password: '1234',
    role: UserRole.veterinarian,
    location: 'Nashik, Maharashtra',
  ),

  AppUser(
    id: 'G001',
    name: 'Amit Deshmukh',
    email: 'demo.gov@maha.com',
    password: '1234',
    role: UserRole.government,
    location: 'Nashik District, Maharashtra',
    governmentLevel: 'District Officer',
  ),

  AppUser(
    id: 'A001',
    name: 'System Administrator',
    email: 'demo.admin@maha.com',
    password: '1234',
    role: UserRole.admin,
    location: 'Maharashtra',
  ),
];