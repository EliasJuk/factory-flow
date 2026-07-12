enum DatabaseOperationMode { sqlite, api, postgresDirect }

extension DatabaseOperationModeLabel on DatabaseOperationMode {
  String get label {
    switch (this) {
      case DatabaseOperationMode.sqlite:
        return 'SQLite local';

      case DatabaseOperationMode.api:
        return 'API';

      case DatabaseOperationMode.postgresDirect:
        return 'PostgreSQL direto';
    }
  }

  String get description {
    switch (this) {
      case DatabaseOperationMode.sqlite:
        return 'Salva os dados localmente neste computador.';

      case DatabaseOperationMode.api:
        return 'Envia e recebe os dados por meio de uma API.';

      case DatabaseOperationMode.postgresDirect:
        return 'Salva os dados diretamente em um servidor PostgreSQL.';
    }
  }

  String get tooltip {
    switch (this) {
      case DatabaseOperationMode.sqlite:
        return 'Utiliza um banco SQLite armazenado no computador.';

      case DatabaseOperationMode.api:
        return 'O aplicativo utiliza uma API intermediária para acessar os dados.';

      case DatabaseOperationMode.postgresDirect:
        return 'Conecta o aplicativo diretamente ao PostgreSQL, sem API.';
    }
  }
}

enum SyncDestination { postgresDirect, api }

extension SyncDestinationLabel on SyncDestination {
  String get label {
    switch (this) {
      case SyncDestination.postgresDirect:
        return 'PostgreSQL direto';

      case SyncDestination.api:
        return 'API';
    }
  }

  String get description {
    switch (this) {
      case SyncDestination.postgresDirect:
        return 'Envia as alterações diretamente ao PostgreSQL.';

      case SyncDestination.api:
        return 'Envia as alterações para uma API intermediária.';
    }
  }

  String get tooltip {
    switch (this) {
      case SyncDestination.postgresDirect:
        return 'O aplicativo acessa diretamente o banco remoto.';

      case SyncDestination.api:
        return 'O aplicativo envia os dados para um servidor próprio.';
    }
  }
}

enum ApiAuthenticationMode { bearerToken, apiKey, none }

extension ApiAuthenticationModeLabel on ApiAuthenticationMode {
  String get label {
    switch (this) {
      case ApiAuthenticationMode.bearerToken:
        return 'Bearer Token';

      case ApiAuthenticationMode.apiKey:
        return 'API Key';

      case ApiAuthenticationMode.none:
        return 'Sem autenticação';
    }
  }

  String get credentialLabel {
    switch (this) {
      case ApiAuthenticationMode.bearerToken:
        return 'Token de acesso';

      case ApiAuthenticationMode.apiKey:
        return 'Chave da API';

      case ApiAuthenticationMode.none:
        return 'Credencial';
    }
  }

  String get credentialHint {
    switch (this) {
      case ApiAuthenticationMode.bearerToken:
        return 'Informe o Bearer Token';

      case ApiAuthenticationMode.apiKey:
        return 'Informe a chave da API';

      case ApiAuthenticationMode.none:
        return 'Autenticação não utilizada';
    }
  }
}
