import 'package:flutter/material.dart';

import '../users/users_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  void _openUsers(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const UsersPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FactoryFlow'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _DashboardCard(
              title: 'Usuários',
              icon: Icons.people_outline,
              onTap: () => _openUsers(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  const _DashboardCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 140,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 42,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}