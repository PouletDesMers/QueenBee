import 'package:flutter/material.dart';

import '../../../data/fake_queenbee_repository.dart';
import '../../../domain/models/hive.dart';

class HarvestScreen extends StatefulWidget {
  const HarvestScreen({required this.hive, required this.repository, super.key});

  final HiveModel hive;
  final FakeQueenBeeRepository repository;

  @override
  State<HarvestScreen> createState() => _HarvestScreenState();
}

class _HarvestScreenState extends State<HarvestScreen> {
  final quantityController = TextEditingController();
  DateTime date = DateTime.now();

  @override
  void dispose() {
    quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Déclarer une récolte')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(widget.hive.name, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 24),
          TextField(
            controller: quantityController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Quantité de miel (kg)',
              prefixIcon: Icon(Icons.scale_outlined),
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.calendar_today),
            title: const Text('Date de la récolte'),
            subtitle: Text('${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}'),
            onTap: () async {
              final selected = await showDatePicker(
                context: context,
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
                initialDate: date,
              );
              if (selected != null) setState(() => date = selected);
            },
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () async {
              final quantity = double.tryParse(quantityController.text.replaceAll(',', '.'));
              if (quantity == null || quantity <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Saisissez une quantité valide.')),
                );
                return;
              }
              await widget.repository.saveHarvest(
                hiveId: widget.hive.id,
                quantityKg: quantity,
                date: date,
              );
              if (context.mounted) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Récolte enregistrée sur le téléphone')),
                );
              }
            },
            child: const Padding(
              padding: EdgeInsets.all(14),
              child: Text('Enregistrer hors ligne'),
            ),
          ),
        ],
      ),
    );
  }
}
