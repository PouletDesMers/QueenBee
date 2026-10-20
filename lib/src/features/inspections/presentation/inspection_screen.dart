import 'package:flutter/material.dart';

import '../../../data/fake_queenbee_repository.dart';
import '../../../domain/models/hive.dart';

class InspectionScreen extends StatefulWidget {
  const InspectionScreen({required this.hive, required this.repository, super.key});

  final HiveModel hive;
  final FakeQueenBeeRepository repository;

  @override
  State<InspectionScreen> createState() => _InspectionScreenState();
}

class _InspectionScreenState extends State<InspectionScreen> {
  final observationController = TextEditingController();
  bool queenPresent = true;
  bool broodPresent = true;

  @override
  void dispose() {
    observationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nouvelle inspection')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(widget.hive.name, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 20),
          SwitchListTile(
            value: queenPresent,
            onChanged: (value) => setState(() => queenPresent = value),
            title: const Text('Reine présente'),
          ),
          SwitchListTile(
            value: broodPresent,
            onChanged: (value) => setState(() => broodPresent = value),
            title: const Text('Couvain présent'),
          ),
          TextField(
            controller: observationController,
            minLines: 4,
            maxLines: 6,
            decoration: const InputDecoration(
              labelText: 'Observations',
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Ajout de photo à connecter à image_picker.')),
            ),
            icon: const Icon(Icons.camera_alt_outlined),
            label: const Text('Ajouter une photo'),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () async {
              await widget.repository.saveInspection(
                hiveId: widget.hive.id,
                observation: observationController.text,
              );
              if (context.mounted) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Inspection enregistrée sur le téléphone')),
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
