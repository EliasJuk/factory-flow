import 'package:factory_flow/modules/settings/models/database_settings.dart';
import 'package:flutter/material.dart';

class RemoteConnectionSettings extends StatelessWidget {
  const RemoteConnectionSettings({
    required this.destination,
    required this.postgresHostController,
    required this.postgresPortController,
    required this.postgresDatabaseController,
    required this.postgresUserController,
    required this.postgresPasswordController,
    required this.apiUrlController,
    required this.apiVersionController,
    required this.apiCredentialController,
    required this.timeoutController,
    required this.useSsl,
    required this.onUseSslChanged,
    required this.apiAuthenticationMode,
    required this.onApiAuthenticationModeChanged,
    required this.validateApiCertificate,
    required this.onValidateApiCertificateChanged,
    required this.retryApiRequests,
    required this.onRetryApiRequestsChanged,
    super.key,
  });

  final SyncDestination destination;

  final TextEditingController postgresHostController;
  final TextEditingController postgresPortController;
  final TextEditingController postgresDatabaseController;
  final TextEditingController postgresUserController;
  final TextEditingController postgresPasswordController;

  final TextEditingController apiUrlController;
  final TextEditingController apiVersionController;
  final TextEditingController apiCredentialController;

  final TextEditingController timeoutController;

  final bool useSsl;
  final ValueChanged<bool> onUseSslChanged;

  final ApiAuthenticationMode apiAuthenticationMode;

  final ValueChanged<ApiAuthenticationMode>
      onApiAuthenticationModeChanged;

  final bool validateApiCertificate;
  final ValueChanged<bool> onValidateApiCertificateChanged;

  final bool retryApiRequests;
  final ValueChanged<bool> onRetryApiRequestsChanged;

  @override
  Widget build(BuildContext context) {
    switch (destination) {
      case SyncDestination.postgresDirect:
        return _PostgresSettings(
          hostController: postgresHostController,
          portController: postgresPortController,
          databaseController: postgresDatabaseController,
          userController: postgresUserController,
          passwordController: postgresPasswordController,
          timeoutController: timeoutController,
          useSsl: useSsl,
          onUseSslChanged: onUseSslChanged,
        );

      case SyncDestination.api:
        return _ApiSettings(
          urlController: apiUrlController,
          versionController: apiVersionController,
          credentialController: apiCredentialController,
          timeoutController: timeoutController,
          authenticationMode: apiAuthenticationMode,
          onAuthenticationModeChanged:
              onApiAuthenticationModeChanged,
          validateCertificate: validateApiCertificate,
          onValidateCertificateChanged:
              onValidateApiCertificateChanged,
          retryRequests: retryApiRequests,
          onRetryRequestsChanged: onRetryApiRequestsChanged,
        );
    }
  }
}

class _PostgresSettings extends StatefulWidget {
  const _PostgresSettings({
    required this.hostController,
    required this.portController,
    required this.databaseController,
    required this.userController,
    required this.passwordController,
    required this.timeoutController,
    required this.useSsl,
    required this.onUseSslChanged,
  });

  final TextEditingController hostController;
  final TextEditingController portController;
  final TextEditingController databaseController;
  final TextEditingController userController;
  final TextEditingController passwordController;
  final TextEditingController timeoutController;

  final bool useSsl;
  final ValueChanged<bool> onUseSslChanged;

  @override
  State<_PostgresSettings> createState() =>
      _PostgresSettingsState();
}

class _PostgresSettingsState extends State<_PostgresSettings> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Conexão PostgreSQL',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 700;

            final hostField = TextFormField(
              controller: widget.hostController,
              decoration: const InputDecoration(
                labelText: 'Host',
                hintText: '192.168.0.10 ou servidor.empresa.local',
                prefixIcon: Icon(Icons.dns_outlined),
              ),
            );

            final portField = TextFormField(
              controller: widget.portController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Porta',
                hintText: '5432',
                prefixIcon: Icon(Icons.numbers),
              ),
            );

            if (compact) {
              return Column(
                children: [
                  hostField,
                  const SizedBox(height: 16),
                  portField,
                ],
              );
            }

            return Row(
              children: [
                Expanded(
                  flex: 3,
                  child: hostField,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: portField,
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: widget.databaseController,
          decoration: const InputDecoration(
            labelText: 'Banco de dados',
            hintText: 'factoryflow',
            prefixIcon: Icon(Icons.storage_outlined),
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 700;

            final userField = TextFormField(
              controller: widget.userController,
              decoration: const InputDecoration(
                labelText: 'Usuário',
                prefixIcon: Icon(Icons.person_outline),
              ),
            );

            final passwordField = TextFormField(
              controller: widget.passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: 'Senha',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  tooltip: _obscurePassword
                      ? 'Mostrar senha'
                      : 'Ocultar senha',
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                ),
              ),
            );

            if (compact) {
              return Column(
                children: [
                  userField,
                  const SizedBox(height: 16),
                  passwordField,
                ],
              );
            }

            return Row(
              children: [
                Expanded(child: userField),
                const SizedBox(width: 16),
                Expanded(child: passwordField),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: widget.timeoutController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Timeout',
            hintText: '15',
            suffixText: 'segundos',
            prefixIcon: Icon(Icons.timer_outlined),
          ),
        ),
        const SizedBox(height: 8),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Usar conexão SSL'),
          subtitle: const Text(
            'Protege a comunicação entre o aplicativo e o banco.',
          ),
          value: widget.useSsl,
          onChanged: widget.onUseSslChanged,
        ),
      ],
    );
  }
}

class _ApiSettings extends StatefulWidget {
  const _ApiSettings({
    required this.urlController,
    required this.versionController,
    required this.credentialController,
    required this.timeoutController,
    required this.authenticationMode,
    required this.onAuthenticationModeChanged,
    required this.validateCertificate,
    required this.onValidateCertificateChanged,
    required this.retryRequests,
    required this.onRetryRequestsChanged,
  });

  final TextEditingController urlController;
  final TextEditingController versionController;
  final TextEditingController credentialController;
  final TextEditingController timeoutController;

  final ApiAuthenticationMode authenticationMode;

  final ValueChanged<ApiAuthenticationMode>
      onAuthenticationModeChanged;

  final bool validateCertificate;
  final ValueChanged<bool> onValidateCertificateChanged;

  final bool retryRequests;
  final ValueChanged<bool> onRetryRequestsChanged;

  @override
  State<_ApiSettings> createState() => _ApiSettingsState();
}

class _ApiSettingsState extends State<_ApiSettings> {
  bool _obscureCredential = true;

  bool get _usesCredential {
    return widget.authenticationMode !=
        ApiAuthenticationMode.none;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Conexão via API',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 700;

            final urlField = TextFormField(
              controller: widget.urlController,
              decoration: const InputDecoration(
                labelText: 'URL base da API',
                hintText: 'http://localhost:8080',
                prefixIcon: Icon(Icons.link),
              ),
            );

            final versionField = TextFormField(
              controller: widget.versionController,
              decoration: const InputDecoration(
                labelText: 'Versão',
                hintText: 'v1',
                prefixIcon: Icon(Icons.numbers_outlined),
              ),
            );

            if (compact) {
              return Column(
                children: [
                  urlField,
                  const SizedBox(height: 16),
                  versionField,
                ],
              );
            }

            return Row(
              children: [
                Expanded(
                  flex: 3,
                  child: urlField,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: versionField,
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<ApiAuthenticationMode>(
          initialValue: widget.authenticationMode,
          decoration: const InputDecoration(
            labelText: 'Método de autenticação',
            prefixIcon: Icon(Icons.security_outlined),
          ),
          items: ApiAuthenticationMode.values.map((mode) {
            return DropdownMenuItem<ApiAuthenticationMode>(
              value: mode,
              child: Text(mode.label),
            );
          }).toList(),
          onChanged: (mode) {
            if (mode == null) {
              return;
            }

            widget.onAuthenticationModeChanged(mode);
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: widget.credentialController,
          enabled: _usesCredential,
          obscureText: _usesCredential && _obscureCredential,
          decoration: InputDecoration(
            labelText:
                widget.authenticationMode.credentialLabel,
            hintText:
                widget.authenticationMode.credentialHint,
            prefixIcon: const Icon(Icons.key_outlined),
            suffixIcon: !_usesCredential
                ? null
                : IconButton(
                    tooltip: _obscureCredential
                        ? 'Mostrar credencial'
                        : 'Ocultar credencial',
                    onPressed: () {
                      setState(() {
                        _obscureCredential =
                            !_obscureCredential;
                      });
                    },
                    icon: Icon(
                      _obscureCredential
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: widget.timeoutController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Timeout',
            hintText: '15',
            suffixText: 'segundos',
            prefixIcon: Icon(Icons.timer_outlined),
          ),
        ),
        const SizedBox(height: 8),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Validar certificado SSL'),
          subtitle: const Text(
            'Verifica se o certificado HTTPS da API é confiável.',
          ),
          value: widget.validateCertificate,
          onChanged: widget.onValidateCertificateChanged,
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Repetir requisições com erro'),
          subtitle: const Text(
            'Repete automaticamente requisições que falharem.',
          ),
          value: widget.retryRequests,
          onChanged: widget.onRetryRequestsChanged,
        ),
        const SizedBox(height: 12),
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
                    'Esta interface está preparada para a futura '
                    'integração com a API. Os campos ainda não são '
                    'salvos e nenhuma requisição será realizada.',
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}