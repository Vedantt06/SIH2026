import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../models/animal.dart';

class RegisterAnimalScreen extends StatefulWidget {
  const RegisterAnimalScreen({super.key});

  @override
  State<RegisterAnimalScreen> createState() =>
      _RegisterAnimalScreenState();
}

class _RegisterAnimalScreenState
    extends State<RegisterAnimalScreen> {
  final formKey = GlobalKey<FormState>();

  final idController = TextEditingController();
  final nameController = TextEditingController();
  final breedController = TextEditingController();

  String species = 'Cattle';
  String gender = 'Female';
  int age = 3;

  @override
  void dispose() {
    idController.dispose();
    nameController.dispose();
    breedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Register Animal',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
          children: [
            _intro(),

            const SizedBox(height: 22),

            _field(
              controller: idController,
              label: 'Animal ID',
              hint: 'Example: AN-MH-00301',
              icon: Icons.badge_outlined,
            ),

            const SizedBox(height: 15),

            _field(
              controller: nameController,
              label: 'Animal Name / Number',
              hint: 'Example: Cow #301',
              icon: Icons.pets_outlined,
            ),

            const SizedBox(height: 15),

            _dropdown(
              label: 'Species',
              value: species,
              icon: Icons.category_outlined,
              items: const [
                'Cattle',
                'Buffalo',
                'Goat',
                'Sheep',
              ],
              onChanged: (value) {
                setState(() {
                  species = value!;
                });
              },
            ),

            const SizedBox(height: 15),

            _field(
              controller: breedController,
              label: 'Breed',
              hint: 'Example: Gir',
              icon: Icons.agriculture_outlined,
            ),

            const SizedBox(height: 15),

            _dropdown(
              label: 'Gender',
              value: gender,
              icon: Icons.wc_outlined,
              items: const [
                'Female',
                'Male',
              ],
              onChanged: (value) {
                setState(() {
                  gender = value!;
                });
              },
            ),

            const SizedBox(height: 15),

            _ageSelector(),

            const SizedBox(height: 28),

            SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.check),
                label: const Text(
                  'Register Animal',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              'For prototype purposes, this animal will be stored locally using mock data.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _intro() {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: AppTheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(17),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            color: AppTheme.primary,
          ),
          SizedBox(width: 11),
          Expanded(
            child: Text(
              'Register your livestock to maintain their health and vaccination history.',
              style: TextStyle(
                fontSize: 12,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  Widget _dropdown({
    required String label,
    required String value,
    required IconData icon,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
      ),
      items: items.map(
        (item) {
          return DropdownMenuItem(
            value: item,
            child: Text(item),
          );
        },
      ).toList(),
      onChanged: onChanged,
    );
  }

  Widget _ageSelector() {
    return InputDecorator(
      decoration: const InputDecoration(
        labelText: 'Age',
        prefixIcon: Icon(Icons.cake_outlined),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: age > 1
                ? () {
                    setState(() {
                      age--;
                    });
                  }
                : null,
            icon: const Icon(Icons.remove_circle_outline),
          ),
          Expanded(
            child: Center(
              child: Text(
                '$age years',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: age < 20
                ? () {
                    setState(() {
                      age++;
                    });
                  }
                : null,
            icon: const Icon(Icons.add_circle_outline),
          ),
        ],
      ),
    );
  }

  void _submit() {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final animal = Animal(
      id: idController.text.trim(),
      name: nameController.text.trim(),
      species: species,
      breed: breedController.text.trim(),
      gender: gender,
      age: age,
      location: 'Nashik, Maharashtra',
      vaccinationStatus: 'Not recorded',
      healthStatus: 'Healthy',
      lastCheckup: 'Not checked yet',
      ownerId: 'FARM-001',
    );

    Navigator.pop(context, animal);
  }
}