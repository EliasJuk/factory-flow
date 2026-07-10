import 'package:factory_flow/modules/users/models/temporary_user.dart';
import 'package:flutter/material.dart';

class UsersToolbar extends StatelessWidget {
  const UsersToolbar({
    required this.searchController,
    required this.selectedProfile,
    required this.onSearchChanged,
    required this.onProfileChanged,
    required this.onClear,
    super.key,
  });

  final TextEditingController searchController;
  final UserProfile? selectedProfile;

  final ValueChanged<String> onSearchChanged;
  final ValueChanged<UserProfile?> onProfileChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final searchField = TextField(
              controller: searchController,
              onChanged: onSearchChanged,
              decoration: const InputDecoration(
                labelText: 'Pesquisar',
                hintText: 'Nome ou usuário',
                prefixIcon: Icon(Icons.search),
              ),
            );

            final profileField = DropdownButtonFormField<UserProfile?>(
              key: ValueKey(selectedProfile),
              initialValue: selectedProfile,
              decoration: const InputDecoration(
                labelText: 'Perfil',
                prefixIcon: Icon(Icons.security_outlined),
              ),
              items: [
                const DropdownMenuItem<UserProfile?>(
                  value: null,
                  child: Text('Todos'),
                ),
                ...UserProfile.values.map(
                  (profile) => DropdownMenuItem<UserProfile?>(
                    value: profile,
                    child: Text(profile.label),
                  ),
                ),
              ],
              onChanged: onProfileChanged,
            );

            final clearButton = OutlinedButton.icon(
              onPressed: onClear,
              icon: const Icon(Icons.filter_alt_off_outlined),
              label: const Text('Limpar'),
            );

            if (constraints.maxWidth < 760) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  searchField,
                  const SizedBox(height: 12),
                  profileField,
                  const SizedBox(height: 12),
                  clearButton,
                ],
              );
            }

            return Row(
              children: [
                Expanded(
                  flex: 3,
                  child: searchField,
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: profileField,
                ),
                const SizedBox(width: 12),
                clearButton,
              ],
            );
          },
        ),
      ),
    );
  }
}