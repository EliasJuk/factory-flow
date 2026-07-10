import 'package:factory_flow/modules/users/models/temporary_user.dart';
import 'package:factory_flow/shared/widgets/app_badge.dart';
import 'package:factory_flow/shared/widgets/app_empty_state.dart';
import 'package:factory_flow/shared/widgets/app_expandable_card.dart';
import 'package:factory_flow/shared/widgets/app_pagination.dart';
import 'package:flutter/material.dart';

class UsersTable extends StatelessWidget {
  const UsersTable({
    required this.title,
    required this.emptyTitle,
    required this.emptyMessage,
    required this.users,
    required this.currentPage,
    required this.pageSize,
    required this.totalItems,
    required this.onPageChanged,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleStatus,
    this.initiallyExpanded = true,
    super.key,
  });

  final String title;
  final String emptyTitle;
  final String emptyMessage;

  final List<TemporaryUser> users;

  final int currentPage;
  final int pageSize;
  final int totalItems;

  final bool initiallyExpanded;

  final ValueChanged<int> onPageChanged;
  final ValueChanged<TemporaryUser> onEdit;
  final ValueChanged<TemporaryUser> onDelete;
  final ValueChanged<TemporaryUser> onToggleStatus;

  @override
  Widget build(BuildContext context) {
    return AppExpandableCard(
      title: title,
      subtitle: '$totalItems registro(s)',
      icon: Icons.people_outline,
      initiallyExpanded: initiallyExpanded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (users.isEmpty)
            AppEmptyState(
              title: emptyTitle,
              message: emptyMessage,
              icon: Icons.people_outline,
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                final tableWidth =
                    constraints.maxWidth < 980 ? 980.0 : constraints.maxWidth;

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: tableWidth,
                    child: Column(
                      children: [
                        const _UsersTableHeader(),
                        const Divider(height: 1),
                        for (var index = 0;
                            index < users.length;
                            index++) ...[
                          _UserRow(
                            user: users[index],
                            onEdit: () => onEdit(users[index]),
                            onDelete: () => onDelete(users[index]),
                            onToggleStatus: () {
                              onToggleStatus(users[index]);
                            },
                          ),
                          if (index < users.length - 1)
                            const Divider(
                              height: 1,
                              indent: 20,
                              endIndent: 20,
                            ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          if (users.isNotEmpty) ...[
            const Divider(height: 1),
            AppPagination(
              currentPage: currentPage,
              pageSize: pageSize,
              totalItems: totalItems,
              onPageChanged: onPageChanged,
            ),
          ],
        ],
      ),
    );
  }
}

class _UsersTableHeader extends StatelessWidget {
  const _UsersTableHeader();

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.bold,
        );

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 14,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text('Nome', style: textStyle),
          ),
          Expanded(
            flex: 3,
            child: Text('Usuário', style: textStyle),
          ),
          Expanded(
            flex: 3,
            child: Text('Perfil', style: textStyle),
          ),
          Expanded(
            flex: 2,
            child: Text('Status', style: textStyle),
          ),
          SizedBox(
            width: 156,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Ações',
                style: textStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _UserRow extends StatelessWidget {
  const _UserRow({
    required this.user,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleStatus,
  });

  final TemporaryUser user;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleStatus;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: colorScheme.primaryContainer,
                  foregroundColor: colorScheme.onPrimaryContainer,
                  child: Text(
                    user.name.isEmpty
                        ? '?'
                        : user.name.substring(0, 1).toUpperCase(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    user.name,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              user.username,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 3,
            child: Align(
              alignment: Alignment.centerLeft,
              child: _UserProfileBadge(
                profile: user.profile,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: _UserStatusBadge(
                active: user.active,
              ),
            ),
          ),
          SizedBox(
            width: 156,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  tooltip: 'Editar usuário',
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_outlined),
                ),
                IconButton(
                  tooltip: user.active
                      ? 'Desativar usuário'
                      : 'Ativar usuário',
                  onPressed: onToggleStatus,
                  icon: Icon(
                    user.active
                        ? Icons.person_off_outlined
                        : Icons.person_add_alt_1_outlined,
                  ),
                ),
                IconButton(
                  tooltip: 'Excluir usuário',
                  onPressed: onDelete,
                  style: IconButton.styleFrom(
                    foregroundColor: colorScheme.onSurfaceVariant,
                  ),
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UserProfileBadge extends StatelessWidget {
  const _UserProfileBadge({
    required this.profile,
  });

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    switch (profile) {
      case UserProfile.admin:
        return AppBadge(
          label: profile.label,
          icon: Icons.admin_panel_settings_outlined,
          backgroundColor: colorScheme.primaryContainer,
          foregroundColor: colorScheme.onPrimaryContainer,
        );

      case UserProfile.quality:
        return AppBadge(
          label: profile.label,
          icon: Icons.verified_user_outlined,
          backgroundColor: colorScheme.tertiaryContainer,
          foregroundColor: colorScheme.onTertiaryContainer,
        );

      case UserProfile.user:
        return AppBadge(
          label: profile.label,
          icon: Icons.person_outline,
          backgroundColor: colorScheme.secondaryContainer,
          foregroundColor: colorScheme.onSecondaryContainer,
        );
    }
  }
}

class _UserStatusBadge extends StatelessWidget {
  const _UserStatusBadge({
    required this.active,
  });

  final bool active;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (active) {
      return AppBadge(
        label: 'Ativo',
        icon: Icons.check_circle_outline,
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
      );
    }

    return AppBadge(
      label: 'Inativo',
      icon: Icons.pause_circle_outline,
      backgroundColor: colorScheme.surfaceContainerHighest,
      foregroundColor: colorScheme.onSurfaceVariant,
    );
  }
}