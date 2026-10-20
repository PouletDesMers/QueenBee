import 'package:flutter/material.dart';

import '../../../data/fake_queenbee_repository.dart';
import '../../../domain/models/alert.dart';
import '../../../domain/models/harvest.dart';
import '../../../domain/models/hive.dart';
import '../../hives/presentation/hive_detail_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({required this.repository, required this.onLogout, super.key});

  final FakeQueenBeeRepository repository;
  final VoidCallback onLogout;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      _HivesPage(
        repository: widget.repository,
        onHiveTap: (hive) => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => HiveDetailScreen(
              hive: hive,
              repository: widget.repository,
            ),
          ),
        ),
      ),
      _AlertsPage(repository: widget.repository),
      _HarvestsPage(repository: widget.repository),
      _ProfilePage(repository: widget.repository, onLogout: widget.onLogout),
    ];

    return Scaffold(
      body: IndexedStack(index: selectedIndex, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) => setState(() => selectedIndex = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.hive_outlined), selectedIcon: Icon(Icons.hive), label: 'Mes ruches'),
          NavigationDestination(icon: Icon(Icons.notifications_outlined), selectedIcon: Icon(Icons.notifications), label: 'Alertes'),
          NavigationDestination(icon: Icon(Icons.water_drop_outlined), selectedIcon: Icon(Icons.water_drop), label: 'Récoltes'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}

class _HivesPage extends StatelessWidget {
  const _HivesPage({required this.repository, required this.onHiveTap});

  final FakeQueenBeeRepository repository;
  final ValueChanged<HiveModel> onHiveTap;

  @override
  Widget build(BuildContext context) {
    final hives = repository.getHives().toList()
      ..sort((a, b) => b.risk.index.compareTo(a.risk.index));
    return _PageScaffold(
      title: 'Mes ruches',
      subtitle: 'Dakar - Keur Massar · Données du 14/03 à 08:15',
      actions: [
        IconButton(
          tooltip: 'Scanner un QR code',
          onPressed: () => _showMessage(context, 'Le scanner QR sera connecté à mobile_scanner.'),
          icon: const Icon(Icons.qr_code_scanner),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _OfflineBanner(),
          const SizedBox(height: 16),
          Text(
            '${repository.pendingOperations} saisies en attente de synchronisation',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 12),
          ...hives.map(
            (hive) => _HiveCard(hive: hive, onTap: () => onHiveTap(hive)),
          ),
        ],
      ),
    );
  }
}

class _AlertsPage extends StatelessWidget {
  const _AlertsPage({required this.repository});

  final FakeQueenBeeRepository repository;

  @override
  Widget build(BuildContext context) {
    return _PageScaffold(
      title: 'Alertes',
      subtitle: 'Risques nécessitant votre attention',
      child: Column(
        children: repository
            .getAlerts()
            .map((alert) => _AlertCard(alert: alert))
            .toList(),
      ),
    );
  }
}

class _HarvestsPage extends StatelessWidget {
  const _HarvestsPage({required this.repository});

  final FakeQueenBeeRepository repository;

  @override
  Widget build(BuildContext context) {
    return _PageScaffold(
      title: 'Mes récoltes',
      subtitle: 'Historique et statut de validation',
      child: Column(
        children: [
          FilledButton.icon(
            onPressed: () => _showMessage(context, 'Sélectionnez une ruche depuis son détail pour déclarer une récolte.'),
            icon: const Icon(Icons.add),
            label: const Text('Nouvelle déclaration'),
          ),
          const SizedBox(height: 16),
          ...repository.getHarvests().map((harvest) => _HarvestCard(harvest: harvest)),
        ],
      ),
    );
  }
}

class _ProfilePage extends StatelessWidget {
  const _ProfilePage({required this.repository, required this.onLogout});

  final FakeQueenBeeRepository repository;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return _PageScaffold(
      title: 'Synchronisation & profil',
      subtitle: 'Apiculteur · Coopérative Keur Massar',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.cloud_off, color: Colors.orange),
              title: const Text('Mode hors ligne'),
              subtitle: Text('${repository.pendingOperations} opération(s) dans la file d’envoi'),
              trailing: FilledButton(
                onPressed: () async {
                  await repository.synchronize();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Synchronisation terminée')),
                    );
                  }
                },
                child: const Text('Synchroniser'),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.schedule),
              title: const Text('Dernière synchronisation'),
              subtitle: Text(repository.lastSync?.toString() ?? 'Jamais'),
            ),
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: onLogout,
            icon: const Icon(Icons.logout),
            label: const Text('Se déconnecter'),
          ),
        ],
      ),
    );
  }
}

class _PageScaffold extends StatelessWidget {
  const _PageScaffold({
    required this.title,
    required this.subtitle,
    required this.child,
    this.actions = const [],
  });

  final String title;
  final String subtitle;
  final Widget child;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title),
                Text(subtitle, style: Theme.of(context).textTheme.labelSmall),
              ],
            ),
            actions: actions,
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            sliver: SliverToBoxAdapter(child: child),
          ),
        ],
      ),
    );
  }
}

class _OfflineBanner extends StatelessWidget {
  const _OfflineBanner();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.orange.shade50,
      child: const ListTile(
        leading: Icon(Icons.cloud_off, color: Colors.orange),
        title: Text('Hors ligne'),
        subtitle: Text('Les saisies sont conservées sur cet appareil.'),
      ),
    );
  }
}

class _HiveCard extends StatelessWidget {
  const _HiveCard({required this.hive, required this.onTap});

  final HiveModel hive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = switch (hive.risk) {
      HiveRisk.low => Colors.green,
      HiveRisk.medium => Colors.orange,
      HiveRisk.high => Colors.red,
    };
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: color.withValues(alpha: 0.12),
                foregroundColor: color,
                child: const Icon(Icons.hive),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(hive.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text('${hive.weightKg} kg · ${hive.temperature} °C'),
                  ],
                ),
              ),
              Text('${hive.healthScore}%', style: TextStyle(color: color, fontWeight: FontWeight.bold)),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

class _AlertCard extends StatelessWidget {
  const _AlertCard({required this.alert});

  final AlertModel alert;

  @override
  Widget build(BuildContext context) {
    final color = alert.severity == AlertSeverity.critical ? Colors.red : Colors.orange;
    return Card(
      child: ListTile(
        leading: Icon(Icons.warning_amber_rounded, color: color),
        title: Text(alert.title),
        subtitle: Text('${alert.hiveName}\n${alert.description}'),
        isThreeLine: true,
      ),
    );
  }
}

class _HarvestCard extends StatelessWidget {
  const _HarvestCard({required this.harvest});

  final HarvestModel harvest;

  @override
  Widget build(BuildContext context) {
    final status = switch (harvest.status) {
      HarvestStatus.validated => 'Validée',
      HarvestStatus.declared => 'Déclarée',
      HarvestStatus.rejected => 'Refusée',
    };
    return Card(
      child: ListTile(
        leading: const Icon(Icons.water_drop, color: Colors.amber),
        title: Text('${harvest.quantityKg} kg · ${harvest.hiveName}'),
        subtitle: Text(harvest.date.toString().split(' ').first),
        trailing: Chip(label: Text(status)),
      ),
    );
  }
}

void _showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
