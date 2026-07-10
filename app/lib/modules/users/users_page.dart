import 'package:flutter/material.dart';

import 'models/temporary_user.dart';
import 'widgets/user_form_dialog.dart';
import 'widgets/users_table.dart';
import 'widgets/users_toolbar.dart';
import '../../shared/widgets/app_summary_card.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  static const int _pageSize = 5;

  final _searchController = TextEditingController();

  final List<TemporaryUser> _users = [
    const TemporaryUser(
      id: '1',
      name: 'Administrador',
      username: 'admin',
      profile: UserProfile.admin,
      active: true,
    ),
    const TemporaryUser(
      id: '2',
      name: 'Elias Juk',
      username: 'jukelias',
      profile: UserProfile.quality,
      active: true,
    ),
    const TemporaryUser(
      id: '3',
      name: 'Usuário de Teste',
      username: 'teste',
      profile: UserProfile.user,
      active: false,
    ),
    const TemporaryUser(
      id: '4',
      name: 'Ana Souza',
      username: 'anasouza',
      profile: UserProfile.user,
      active: true,
    ),
    const TemporaryUser(
      id: '5',
      name: 'Carlos Silva',
      username: 'carlossilva',
      profile: UserProfile.user,
      active: true,
    ),
    const TemporaryUser(
      id: '6',
      name: 'Fernanda Lima',
      username: 'fernandalima',
      profile: UserProfile.quality,
      active: true,
    ),
    const TemporaryUser(
      id: '7',
      name: 'João Pereira',
      username: 'joaopereira',
      profile: UserProfile.user,
      active: true,
    ),
    const TemporaryUser(
      id: '8',
      name: 'Marcos Oliveira',
      username: 'marcosoliveira',
      profile: UserProfile.user,
      active: true,
    ),
    const TemporaryUser(
      id: '9',
      name: 'Patrícia Rocha',
      username: 'patriciarocha',
      profile: UserProfile.user,
      active: false,
    ),
    const TemporaryUser(
      id: '10',
      name: 'Roberto Alves',
      username: 'robertoalves',
      profile: UserProfile.user,
      active: false,
    ),
    const TemporaryUser(
      id: '11',
      name: 'Juliana Costa',
      username: 'julianacosta',
      profile: UserProfile.quality,
      active: true,
    ),
    const TemporaryUser(
      id: '12',
      name: 'Lucas Martins',
      username: 'lucasmartins',
      profile: UserProfile.user,
      active: false,
    ),
  ];

  UserProfile? _selectedProfile;

  int _activePage = 0;
  int _inactivePage = 0;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<TemporaryUser> get _filteredUsers {
    final search = _searchController.text.trim().toLowerCase();

    return _users.where((user) {
      final matchesSearch =
          search.isEmpty ||
          user.name.toLowerCase().contains(search) ||
          user.username.toLowerCase().contains(search);

      final matchesProfile =
          _selectedProfile == null || user.profile == _selectedProfile;

      return matchesSearch && matchesProfile;
    }).toList();
  }

  int get _activeUsersCount {
    return _users.where((user) => user.active).length;
  }

  int get _inactiveUsersCount {
    return _users.where((user) => !user.active).length;
  }

  int get _adminUsersCount {
    return _users
        .where((user) => user.profile == UserProfile.admin)
        .length;
  }

  int _lastPage(int itemCount) {
    if (itemCount == 0) {
      return 0;
    }

    return (itemCount - 1) ~/ _pageSize;
  }

  List<TemporaryUser> _paginate(
    List<TemporaryUser> users,
    int page,
  ) {
    if (users.isEmpty) {
      return [];
    }

    final safePage = page.clamp(
      0,
      _lastPage(users.length),
    );

    final start = safePage * _pageSize;
    final calculatedEnd = start + _pageSize;
    final end = calculatedEnd > users.length
        ? users.length
        : calculatedEnd;

    return users.sublist(start, end);
  }

  void _resetPagination() {
    _activePage = 0;
    _inactivePage = 0;
  }

  bool _usernameExists(
    String username,
    String? ignoredUserId,
  ) {
    final normalizedUsername = username.trim().toLowerCase();

    return _users.any(
      (user) =>
          user.id != ignoredUserId &&
          user.username.toLowerCase() == normalizedUsername,
    );
  }

  Future<void> _openUserForm([
    TemporaryUser? user,
  ]) async {
    final result = await showUserFormDialog(
      context: context,
      user: user,
      usernameExists: _usernameExists,
    );

    if (result == null || !mounted) {
      return;
    }

    setState(() {
      if (user == null) {
        _users.add(
          TemporaryUser(
            id: DateTime.now().microsecondsSinceEpoch.toString(),
            name: result.name,
            username: result.username,
            profile: result.profile,
            active: result.active,
          ),
        );
      } else {
        final index = _users.indexWhere(
          (existingUser) => existingUser.id == user.id,
        );

        if (index >= 0) {
          _users[index] = user.copyWith(
            name: result.name,
            username: result.username,
            profile: result.profile,
            active: result.active,
          );
        }
      }

      _resetPagination();
    });

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            user == null
                ? 'Usuário cadastrado temporariamente.'
                : 'Usuário atualizado temporariamente.',
          ),
        ),
      );
  }

  Future<void> _confirmDelete(
    TemporaryUser user,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          icon: const Icon(Icons.delete_outline),
          title: const Text('Excluir usuário'),
          content: Text(
            'Deseja excluir o usuário "${user.name}"?\n\n'
            'Nesta versão temporária, o registro será removido '
            'apenas da memória da aplicação.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Cancelar'),
            ),
            FilledButton.tonal(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) {
      return;
    }

    setState(() {
      _users.removeWhere(
        (existingUser) => existingUser.id == user.id,
      );

      _resetPagination();
    });

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Usuário removido temporariamente.'),
        ),
      );
  }

  void _toggleStatus(
    TemporaryUser user,
  ) {
    final index = _users.indexWhere(
      (existingUser) => existingUser.id == user.id,
    );

    if (index < 0) {
      return;
    }

    final updatedUser = user.copyWith(
      active: !user.active,
    );

    setState(() {
      _users[index] = updatedUser;
      _resetPagination();
    });

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            updatedUser.active
                ? 'Usuário ativado temporariamente.'
                : 'Usuário desativado temporariamente.',
          ),
        ),
      );
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _selectedProfile = null;
      _resetPagination();
    });
  }

  void _refreshUsers() {
    setState(() {});

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Listagem atualizada.'),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final filteredUsers = _filteredUsers;

    final activeUsers = filteredUsers
        .where((user) => user.active)
        .toList();

    final inactiveUsers = filteredUsers
        .where((user) => !user.active)
        .toList();

    final safeActivePage = _activePage
        .clamp(0, _lastPage(activeUsers.length));

    final safeInactivePage = _inactivePage
        .clamp(0, _lastPage(inactiveUsers.length));

    final paginatedActiveUsers = _paginate(
      activeUsers,
      safeActivePage,
    );

    final paginatedInactiveUsers = _paginate(
      inactiveUsers,
      safeInactivePage,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuários'),
        actions: [
          IconButton(
            tooltip: 'Atualizar',
            onPressed: _refreshUsers,
            icon: const Icon(Icons.refresh),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _UsersPageHeader(
              onNewUser: _openUserForm,
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                SizedBox(
                  width: 230,
                  child: AppSummaryCard(
                    title: 'Total',
                    value: _users.length.toString(),
                    icon: Icons.people_outline,
                  ),
                ),
                SizedBox(
                  width: 230,
                  child: AppSummaryCard(
                    title: 'Ativos',
                    value: _activeUsersCount.toString(),
                    icon: Icons.person_outline,
                  ),
                ),
                SizedBox(
                  width: 230,
                  child: AppSummaryCard(
                    title: 'Inativos',
                    value: _inactiveUsersCount.toString(),
                    icon: Icons.person_off_outlined,
                  ),
                ),
                SizedBox(
                  width: 230,
                  child: AppSummaryCard(
                    title: 'Administradores',
                    value: _adminUsersCount.toString(),
                    icon: Icons.admin_panel_settings_outlined,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            UsersToolbar(
              searchController: _searchController,
              selectedProfile: _selectedProfile,
              onSearchChanged: (_) {
                setState(() {
                  _resetPagination();
                });
              },
              onProfileChanged: (profile) {
                setState(() {
                  _selectedProfile = profile;
                  _resetPagination();
                });
              },
              onClear: _clearFilters,
            ),
            const SizedBox(height: 24),
            UsersTable(
              key: const PageStorageKey<String>('active-users-table'),
              title: 'Usuários ativos',
              initiallyExpanded: true,
              emptyTitle: 'Nenhum usuário ativo',
              emptyMessage: 'Altere os filtros ou cadastre um novo usuário.',
              users: paginatedActiveUsers,
              currentPage: safeActivePage,
              pageSize: _pageSize,
              totalItems: activeUsers.length,
              onPageChanged: (page) {
                setState(() {
                  _activePage = page;
                });
              },
              onEdit: _openUserForm,
              onDelete: _confirmDelete,
              onToggleStatus: _toggleStatus,
            ),

            const SizedBox(height: 24),
            UsersTable(
              key: const PageStorageKey<String>('inactive-users-table'),
              title: 'Usuários inativos',
              initiallyExpanded: false,
              emptyTitle: 'Nenhum usuário inativo',
              emptyMessage: 'Usuários desativados aparecerão nesta lista.',
              users: paginatedInactiveUsers,
              currentPage: safeInactivePage,
              pageSize: _pageSize,
              totalItems: inactiveUsers.length,
              onPageChanged: (page) {
                setState(() {
                  _inactivePage = page;
                });
              },
              onEdit: _openUserForm,
              onDelete: _confirmDelete,
              onToggleStatus: _toggleStatus,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _UsersPageHeader extends StatelessWidget {
  const _UsersPageHeader({
    required this.onNewUser,
  });

  final VoidCallback onNewUser;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Gerenciamento de usuários',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                'Cadastre, edite e controle o acesso dos usuários.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        FilledButton.icon(
          onPressed: onNewUser,
          icon: const Icon(Icons.person_add_outlined),
          label: const Text('Novo usuário'),
        ),
      ],
    );
  }
}