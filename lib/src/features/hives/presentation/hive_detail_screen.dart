import 'package:flutter/material.dart';

import '../../../data/fake_queenbee_repository.dart';
import '../../../domain/models/hive.dart';
import '../../harvests/presentation/harvest_screen.dart';
import '../../inspections/presentation/inspection_screen.dart';

class HiveDetailScreen extends StatelessWidget {
  const HiveDetailScreen({required this.hive, required this.repository, super.key});

  final HiveModel hive;
  final FakeQueenBeeRepository repository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(hive.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(hive.site, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 16),
                  Text('${hive.healthScore}%', style: Theme.of(context).textTheme.displaySmall),
                  const Text('Score de santé'),
                  const Divider(height: 32),
                  Text('Poids : ${hive.weightKg} kg'),
                  Text('Température : ${hive.temperature} °C'),
                  const Text('Activité : stable · Données des 7 derniers jours'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => InspectionScreen(hive: hive, repository: repository),
              ),
            ),
            icon: const Icon(Icons.fact_check),
            label: const Text('Nouvelle inspection'),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => HarvestScreen(hive: hive, repository: repository),
              ),
            ),
            icon: const Icon(Icons.water_drop),
            label: const Text('Déclarer une récolte'),
          ),
          const SizedBox(height: 24),
          Text('Historique', style: Theme.of(context).textTheme.titleLarge),
          const ListTile(
            leading: Icon(Icons.assignment_turned_in_outlined),
            title: Text('Dernière inspection'),
            subtitle: Text('Données locales disponibles hors connexion'),
          ),
        ],
      ),
    );
  }
}
