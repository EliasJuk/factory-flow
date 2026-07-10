import 'package:factory_flow/modules/users/models/temporary_user.dart';
import 'package:flutter/material.dart';

typedef UsernameExists = bool Function(
  String username,
  String? ignoredUserId,
);

class TemporaryUserFormResult {
  const TemporaryUserFormResult({
    required this.name,
    required this.username,
    required this.profile,
    required this.active,
  });

  final String name;
  final String username;
  final UserProfile profile;
  final bool active;
}

Future<TemporaryUserFormResult?> showUserFormDialog({
  required BuildContext context,
  required UsernameExists usernameExists,
  TemporaryUser? user,
}) async {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController(
    text: user?.name ?? '',
  );

  final usernameController = TextEditingController(
    text: user?.username ?? '',
  );

  var selectedProfile = user?.profile ?? UserProfile.user;
  var active = user?.active ?? true;

  final result = await showDialog<TemporaryUserFormResult>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Text(
              user == null ? 'Novo usuário' : 'Editar usuário',
            ),
            content: SizedBox(
              width: 520,
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: nameController,
                        autofocus: true,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Nome completo',
                          prefixIcon: Icon(Icons.badge_outlined),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Informe o nome completo.';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: usernameController,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Nome de usuário',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        validator: (value) {
                          final username = value?.trim() ?? '';

                          if (username.isEmpty) {
                            return 'Informe o nome de usuário.';
                          }

                          if (usernameExists(username, user?.id)) {
                            return 'Este nome de usuário já está em uso.';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<UserProfile>(
                        initialValue: selectedProfile,
                        decoration: const InputDecoration(
                          labelText: 'Perfil de acesso',
                          prefixIcon: Icon(Icons.security_outlined),
                        ),
                        items: UserProfile.values.map((profile) {
                          return DropdownMenuItem<UserProfile>(
                            value: profile,
                            child: Text(profile.label),
                          );
                        }).toList(),
                        onChanged: (profile) {
                          if (profile == null) {
                            return;
                          }

                          setDialogState(() {
                            selectedProfile = profile;
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Usuário ativo'),
                        subtitle: Text(
                          active
                              ? 'O usuário pode acessar o sistema.'
                              : 'O acesso ao sistema está bloqueado.',
                        ),
                        value: active,
                        onChanged: (value) {
                          setDialogState(() {
                            active = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
                child: const Text('Cancelar'),
              ),
              FilledButton.icon(
                onPressed: () {
                  final isValid =
                      formKey.currentState?.validate() ?? false;

                  if (!isValid) {
                    return;
                  }

                  Navigator.of(dialogContext).pop(
                    TemporaryUserFormResult(
                      name: nameController.text.trim(),
                      username: usernameController.text.trim(),
                      profile: selectedProfile,
                      active: active,
                    ),
                  );
                },
                icon: const Icon(Icons.save_outlined),
                label: const Text('Salvar'),
              ),
            ],
          );
        },
      );
    },
  );

  nameController.dispose();
  usernameController.dispose();

  return result;
}