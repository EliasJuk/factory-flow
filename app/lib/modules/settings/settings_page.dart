import 'package:factory_flow/modules/settings/widgets/database_settings_tab.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Configurações'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.storage_outlined), text: 'Banco de dados'),
            ],
          ),
        ),
        body: const TabBarView(children: [DatabaseSettingsTab()]),
      ),
    );
  }
}
