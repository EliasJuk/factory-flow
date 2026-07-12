import 'package:factory_flow/modules/settings/models/database_settings.dart';
import 'package:factory_flow/modules/settings/widgets/database_mode_option.dart';
import 'package:factory_flow/modules/settings/widgets/remote_connection_settings.dart';
import 'package:flutter/material.dart';

class DatabaseSettingsTab extends StatefulWidget {
  const DatabaseSettingsTab({super.key});

  @override
  State<DatabaseSettingsTab> createState() =>
      _DatabaseSettingsTabState();
}

class _DatabaseSettingsTabState extends State<DatabaseSettingsTab> {
  final _sqlitePathController = TextEditingController(
    text: 'database/factoryflow.db',
  );

  final _postgresHostController = TextEditingController();
  final _postgresPortController = TextEditingController(
    text: '5432',
  );
  final _postgresDatabaseController = TextEditingController(
    text: 'factoryflow',
  );
  final _postgresUserController = TextEditingController();
  final _postgresPasswordController = TextEditingController();

  final _apiUrlController = TextEditingController(
    text: 'http://localhost:8080',
  );
  final _apiVersionController = TextEditingController(
    text: 'v1',
  );
  final _apiCredentialController = TextEditingController();

  final _timeoutController = TextEditingController(
    text: '15',
  );

  DatabaseOperationMode _operationMode =
      DatabaseOperationMode.sqlite;

  SyncDestination _syncDestination =
      SyncDestination.postgresDirect;

  ApiAuthenticationMode _apiAuthenticationMode =
      ApiAuthenticationMode.bearerToken;

  bool _syncEnabled = false;
  bool _syncOnStartup = true;
  bool _syncOnConnectionRestore = true;
  bool _automaticRetry = true;

  bool _useSsl = true;
  bool _validateApiCertificate = true;
  bool _retryApiRequests = true;

  @override
  void dispose() {
    _sqlitePathController.dispose();

    _postgresHostController.dispose();
    _postgresPortController.dispose();
    _postgresDatabaseController.dispose();
    _postgresUserController.dispose();
    _postgresPasswordController.dispose();

    _apiUrlController.dispose();
    _apiVersionController.dispose();
    _apiCredentialController.dispose();

    _timeoutController.dispose();

    super.dispose();
  }

  void _selectOperationMode(DatabaseOperationMode mode) {
    setState(() {
      _operationMode = mode;

      if (mode != DatabaseOperationMode.sqlite) {
        _syncEnabled = false;
      }
    });
  }

  void _showTemporaryMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
  }

  void _testLocalDatabase() {
    _showTemporaryMessage(
      'Teste do SQLite ainda não implementado.',
    );
  }

  void _testRemoteConnection() {
    _showTemporaryMessage(
      'Teste da conexão PostgreSQL ainda não implementado.',
    );
  }

  void _testApiConnection() {
    _showTemporaryMessage(
      'Teste da conexão com a API ainda não implementado.',
    );
  }

  void _saveSettings() {
    _showTemporaryMessage(
      'Configurações salvas temporariamente nesta tela.',
    );
  }

  void _restoreSettings() {
    setState(() {
      _operationMode = DatabaseOperationMode.sqlite;
      _syncDestination = SyncDestination.postgresDirect;
      _apiAuthenticationMode =
          ApiAuthenticationMode.bearerToken;

      _syncEnabled = false;
      _syncOnStartup = true;
      _syncOnConnectionRestore = true;
      _automaticRetry = true;

      _useSsl = true;
      _validateApiCertificate = true;
      _retryApiRequests = true;

      _sqlitePathController.text =
          'database/factoryflow.db';

      _postgresHostController.clear();
      _postgresPortController.text = '5432';
      _postgresDatabaseController.text = 'factoryflow';
      _postgresUserController.clear();
      _postgresPasswordController.clear();

      _apiUrlController.text = 'http://localhost:8080';
      _apiVersionController.text = 'v1';
      _apiCredentialController.clear();

      _timeoutController.text = '15';
    });
  }

  @override
  Widget build(BuildContext context) {
    final usingSqlite =
        _operationMode == DatabaseOperationMode.sqlite;

    final usingApi =
        _operationMode == DatabaseOperationMode.api;

    final usingPostgres =
        _operationMode == DatabaseOperationMode.postgresDirect;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 1100,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _SettingsHeader(),
              const SizedBox(height: 24),

              _SectionCard(
                title: 'Modo de armazenamento',
                description:
                    'Escolha onde a aplicação salvará os dados.',
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final compact = constraints.maxWidth < 760;

                    final sqliteOption = DatabaseModeOption(
                      title: DatabaseOperationMode.sqlite.label,
                      description:
                          DatabaseOperationMode.sqlite.description,
                      tooltip:
                          DatabaseOperationMode.sqlite.tooltip,
                      icon: Icons.computer_outlined,
                      selected: usingSqlite,
                      onTap: () {
                        _selectOperationMode(
                          DatabaseOperationMode.sqlite,
                        );
                      },
                    );

                    final apiOption = DatabaseModeOption(
                      title: DatabaseOperationMode.api.label,
                      description:
                          DatabaseOperationMode.api.description,
                      tooltip:
                          DatabaseOperationMode.api.tooltip,
                      icon: Icons.api_outlined,
                      selected: usingApi,
                      onTap: () {
                        _selectOperationMode(
                          DatabaseOperationMode.api,
                        );
                      },
                    );

                    final postgresOption = DatabaseModeOption(
                      title:
                          DatabaseOperationMode.postgresDirect.label,
                      description: DatabaseOperationMode
                          .postgresDirect.description,
                      tooltip: DatabaseOperationMode
                          .postgresDirect.tooltip,
                      icon: Icons.storage_outlined,
                      selected: usingPostgres,
                      onTap: () {
                        _selectOperationMode(
                          DatabaseOperationMode.postgresDirect,
                        );
                      },
                    );

                    if (compact) {
                      return Column(
                        children: [
                          sqliteOption,
                          const SizedBox(height: 12),
                          apiOption,
                          const SizedBox(height: 12),
                          postgresOption,
                        ],
                      );
                    }

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: sqliteOption),
                        const SizedBox(width: 16),
                        Expanded(child: apiOption),
                        const SizedBox(width: 16),
                        Expanded(child: postgresOption),
                      ],
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              if (usingSqlite)
                _buildSqliteSettings(context)
              else if (usingApi)
                _buildApiSettings(context)
              else
                _buildPostgresSettings(context),

              const SizedBox(height: 24),

              Card(
                color: Theme.of(context)
                    .colorScheme
                    .surfaceContainerHighest,
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Esta tela ainda utiliza configurações '
                          'temporárias. Nenhuma conexão ou banco '
                          'de dados será criado nesta etapa.',
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: _restoreSettings,
                    child: const Text('Restaurar'),
                  ),
                  const SizedBox(width: 12),
                  FilledButton.icon(
                    onPressed: _saveSettings,
                    icon: const Icon(Icons.save_outlined),
                    label: const Text(
                      'Salvar configurações',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSqliteSettings(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionCard(
          title: 'SQLite local',
          description:
              'Configuração do banco armazenado no computador.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _sqlitePathController,
                decoration: const InputDecoration(
                  labelText: 'Caminho do banco',
                  prefixIcon: Icon(Icons.folder_outlined),
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: OutlinedButton.icon(
                  onPressed: _testLocalDatabase,
                  icon: const Icon(
                    Icons.health_and_safety_outlined,
                  ),
                  label: const Text(
                    'Testar banco local',
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        _SectionCard(
          title: 'Sincronização',
          description:
              'Mantém o banco local sincronizado com um destino remoto.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Ativar sincronização'),
                subtitle: const Text(
                  'Os dados serão salvos no SQLite e enviados '
                  'ao destino remoto quando possível.',
                ),
                value: _syncEnabled,
                onChanged: (value) {
                  setState(() {
                    _syncEnabled = value;
                  });
                },
              ),

              if (_syncEnabled) ...[
                const SizedBox(height: 16),

                Text(
                  'Destino remoto',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),

                const SizedBox(height: 12),

                LayoutBuilder(
                  builder: (context, constraints) {
                    final compact =
                        constraints.maxWidth < 760;

                    final postgresOption =
                        DatabaseModeOption(
                      title: SyncDestination
                          .postgresDirect.label,
                      description: SyncDestination
                          .postgresDirect.description,
                      tooltip: SyncDestination
                          .postgresDirect.tooltip,
                      icon: Icons.storage_outlined,
                      selected: _syncDestination ==
                          SyncDestination.postgresDirect,
                      onTap: () {
                        setState(() {
                          _syncDestination =
                              SyncDestination.postgresDirect;
                        });
                      },
                    );

                    final apiOption =
                        DatabaseModeOption(
                      title: SyncDestination.api.label,
                      description:
                          SyncDestination.api.description,
                      tooltip:
                          SyncDestination.api.tooltip,
                      icon: Icons.api_outlined,
                      selected: _syncDestination ==
                          SyncDestination.api,
                      onTap: () {
                        setState(() {
                          _syncDestination =
                              SyncDestination.api;
                        });
                      },
                    );

                    if (compact) {
                      return Column(
                        children: [
                          postgresOption,
                          const SizedBox(height: 12),
                          apiOption,
                        ],
                      );
                    }

                    return Row(
                      children: [
                        Expanded(child: postgresOption),
                        const SizedBox(width: 16),
                        Expanded(child: apiOption),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 24),

                _buildRemoteConnectionSettings(),

                const SizedBox(height: 16),
                const Divider(),

                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    'Sincronizar ao iniciar',
                  ),
                  value: _syncOnStartup,
                  onChanged: (value) {
                    setState(() {
                      _syncOnStartup = value;
                    });
                  },
                ),

                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    'Sincronizar ao recuperar conexão',
                  ),
                  value: _syncOnConnectionRestore,
                  onChanged: (value) {
                    setState(() {
                      _syncOnConnectionRestore = value;
                    });
                  },
                ),

                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    'Repetir operações com erro',
                  ),
                  value: _automaticRetry,
                  onChanged: (value) {
                    setState(() {
                      _automaticRetry = value;
                    });
                  },
                ),

                const SizedBox(height: 16),

                Align(
                  alignment: Alignment.centerLeft,
                  child: OutlinedButton.icon(
                    onPressed: _syncDestination ==
                            SyncDestination.api
                        ? _testApiConnection
                        : _testRemoteConnection,
                    icon: const Icon(
                      Icons.cloud_done_outlined,
                    ),
                    label: const Text(
                      'Testar destino remoto',
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildApiSettings(BuildContext context) {
    return _SectionCard(
      title: 'API',
      description:
          'A aplicação utilizará uma API para comunicação com o servidor.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            color: Theme.of(context)
                .colorScheme
                .surfaceContainerHighest,
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'A interface está pronta para receber os dados '
                      'da API que será executada futuramente, inclusive '
                      'por meio de um container Docker.',
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          RemoteConnectionSettings(
            destination: SyncDestination.api,
            postgresHostController: _postgresHostController,
            postgresPortController: _postgresPortController,
            postgresDatabaseController:
                _postgresDatabaseController,
            postgresUserController: _postgresUserController,
            postgresPasswordController:
                _postgresPasswordController,
            apiUrlController: _apiUrlController,
            apiVersionController: _apiVersionController,
            apiCredentialController:
                _apiCredentialController,
            timeoutController: _timeoutController,
            useSsl: _useSsl,
            onUseSslChanged: (value) {
              setState(() {
                _useSsl = value;
              });
            },
            apiAuthenticationMode:
                _apiAuthenticationMode,
            onApiAuthenticationModeChanged: (value) {
              setState(() {
                _apiAuthenticationMode = value;
              });
            },
            validateApiCertificate:
                _validateApiCertificate,
            onValidateApiCertificateChanged: (value) {
              setState(() {
                _validateApiCertificate = value;
              });
            },
            retryApiRequests: _retryApiRequests,
            onRetryApiRequestsChanged: (value) {
              setState(() {
                _retryApiRequests = value;
              });
            },
          ),

          const SizedBox(height: 16),

          Align(
            alignment: Alignment.centerLeft,
            child: OutlinedButton.icon(
              onPressed: _testApiConnection,
              icon: const Icon(Icons.api_outlined),
              label: const Text('Testar conexão com a API'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostgresSettings(BuildContext context) {
    return _SectionCard(
      title: 'PostgreSQL direto',
      description:
          'A aplicação acessará diretamente o banco remoto.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            color: Theme.of(context)
                .colorScheme
                .surfaceContainerHighest,
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.warning_amber_outlined),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Neste modo, o aplicativo depende da '
                      'conexão com o PostgreSQL. '
                      'Não haverá funcionamento offline.',
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          _buildRemoteConnectionSettings(
            destination: SyncDestination.postgresDirect,
          ),

          const SizedBox(height: 16),

          Align(
            alignment: Alignment.centerLeft,
            child: OutlinedButton.icon(
              onPressed: _testRemoteConnection,
              icon: const Icon(
                Icons.cloud_done_outlined,
              ),
              label: const Text('Testar conexão'),
            ),
          ),
        ],
      ),
    );
  }

  RemoteConnectionSettings _buildRemoteConnectionSettings({
    SyncDestination? destination,
  }) {
    return RemoteConnectionSettings(
      destination: destination ?? _syncDestination,
      postgresHostController: _postgresHostController,
      postgresPortController: _postgresPortController,
      postgresDatabaseController:
          _postgresDatabaseController,
      postgresUserController: _postgresUserController,
      postgresPasswordController:
          _postgresPasswordController,
      apiUrlController: _apiUrlController,
      apiVersionController: _apiVersionController,
      apiCredentialController: _apiCredentialController,
      timeoutController: _timeoutController,
      useSsl: _useSsl,
      onUseSslChanged: (value) {
        setState(() {
          _useSsl = value;
        });
      },
      apiAuthenticationMode: _apiAuthenticationMode,
      onApiAuthenticationModeChanged: (value) {
        setState(() {
          _apiAuthenticationMode = value;
        });
      },
      validateApiCertificate: _validateApiCertificate,
      onValidateApiCertificateChanged: (value) {
        setState(() {
          _validateApiCertificate = value;
        });
      },
      retryApiRequests: _retryApiRequests,
      onRetryApiRequestsChanged: (value) {
        setState(() {
          _retryApiRequests = value;
        });
      },
    );
  }
}

class _SettingsHeader extends StatelessWidget {
  const _SettingsHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Configurações do banco de dados',
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 6),
        Text(
          'Defina como a aplicação armazenará e sincronizará os dados.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.description,
    required this.child,
  });

  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            child,
          ],
        ),
      ),
    );
  }
}