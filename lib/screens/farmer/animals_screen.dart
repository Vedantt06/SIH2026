import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../data/mock_animals.dart';
import '../../models/animal.dart';
import 'animal_profile_screen.dart';
import 'register_animal_screen.dart';

class AnimalsScreen extends StatefulWidget {
  const AnimalsScreen({super.key});

  @override
  State<AnimalsScreen> createState() => _AnimalsScreenState();
}

class _AnimalsScreenState extends State<AnimalsScreen> {
  final List<Animal> animals = List<Animal>.from(mockAnimals);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Animals',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: animals.isEmpty
          ? _emptyState()
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
              children: [
                _summaryCard(),

                const SizedBox(height: 22),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Registered Animals',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${animals.length} animals',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                ...animals.map(_animalCard),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _registerAnimal,
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Register Animal'),
      ),
    );
  }

  Widget _summaryCard() {
    final healthy = animals
        .where((animal) => animal.healthStatus == 'Healthy')
        .length;

    final attention = animals.length - healthy;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: _summaryItem(
              Icons.pets,
              '${animals.length}',
              'Total',
            ),
          ),
          Container(
            width: 1,
            height: 45,
            color: Colors.white24,
          ),
          Expanded(
            child: _summaryItem(
              Icons.check_circle_outline,
              '$healthy',
              'Healthy',
            ),
          ),
          Container(
            width: 1,
            height: 45,
            color: Colors.white24,
          ),
          Expanded(
            child: _summaryItem(
              Icons.warning_amber_rounded,
              '$attention',
              'Attention',
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryItem(
    IconData icon,
    String value,
    String label,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white70,
          size: 20,
        ),
        const SizedBox(height: 7),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _animalCard(Animal animal) {
    final isHealthy = animal.healthStatus == 'Healthy';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => _openProfile(animal),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.09),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  animal.species == 'Buffalo'
                      ? Icons.agriculture
                      : Icons.pets,
                  color: AppTheme.primary,
                  size: 28,
                ),
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      animal.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${animal.breed} • ${animal.gender} • ${animal.age} years',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color:
                                isHealthy ? Colors.green : Colors.orange,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          animal.healthStatus,
                          style: TextStyle(
                            color:
                                isHealthy ? Colors.green : Colors.orange,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
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

  void _openProfile(Animal animal) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AnimalProfileScreen(
          animal: animal,
        ),
      ),
    );
  }

  Future<void> _registerAnimal() async {
    final animal = await Navigator.push<Animal>(
      context,
      MaterialPageRoute(
        builder: (_) => const RegisterAnimalScreen(),
      ),
    );

    if (animal != null) {
      setState(() {
        animals.add(animal);
      });
    }
  }

  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.pets_outlined,
              size: 65,
              color: AppTheme.primary.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 18),
            const Text(
              'No animals registered',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Register your first animal to start tracking its health.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}