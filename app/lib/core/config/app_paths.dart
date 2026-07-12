import 'dart:io';

class AppPaths {
  AppPaths._();

  static const String applicationFolderName = 'FactoryFlow';
  static const String databaseFileName = 'factoryflow.db';

  static late final Directory rootDirectory;
  static late final Directory databaseDirectory;
  static late final Directory backupDirectory;
  static late final Directory configDirectory;
  static late final Directory exportsDirectory;
  static late final Directory importsDirectory;
  static late final Directory logsDirectory;
  static late final Directory tempDirectory;

  static late final File databaseFile;

  static bool _initialized = false;

  static bool get isInitialized => _initialized;

  static Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    rootDirectory = Directory(_resolveRootPath());

    databaseDirectory = Directory(_join(rootDirectory.path, 'database'));

    backupDirectory = Directory(_join(rootDirectory.path, 'backup'));

    configDirectory = Directory(_join(rootDirectory.path, 'config'));

    exportsDirectory = Directory(_join(rootDirectory.path, 'exports'));

    importsDirectory = Directory(_join(rootDirectory.path, 'imports'));

    logsDirectory = Directory(_join(rootDirectory.path, 'logs'));

    tempDirectory = Directory(_join(rootDirectory.path, 'temp'));

    databaseFile = File(_join(databaseDirectory.path, databaseFileName));

    await _createDirectories();

    _initialized = true;
  }

  static String get databasePath {
    _ensureInitialized();
    return databaseFile.path;
  }

  static String get rootPath {
    _ensureInitialized();
    return rootDirectory.path;
  }

  static String get backupPath {
    _ensureInitialized();
    return backupDirectory.path;
  }

  static String get configPath {
    _ensureInitialized();
    return configDirectory.path;
  }

  static String get exportsPath {
    _ensureInitialized();
    return exportsDirectory.path;
  }

  static String get importsPath {
    _ensureInitialized();
    return importsDirectory.path;
  }

  static String get logsPath {
    _ensureInitialized();
    return logsDirectory.path;
  }

  static String get tempPath {
    _ensureInitialized();
    return tempDirectory.path;
  }

  static String _resolveRootPath() {
    if (Platform.isWindows) {
      final localAppData = Platform.environment['LOCALAPPDATA'];

      if (localAppData == null || localAppData.trim().isEmpty) {
        throw StateError(
          'Não foi possível localizar a pasta LOCALAPPDATA do Windows.',
        );
      }

      return _join(localAppData, applicationFolderName);
    }

    if (Platform.isLinux) {
      final home = Platform.environment['HOME'];

      if (home == null || home.trim().isEmpty) {
        throw StateError('Não foi possível localizar a pasta HOME no Linux.');
      }

      return _join(
        _join(home, '.local'),
        _join('share', applicationFolderName.toLowerCase()),
      );
    }

    if (Platform.isMacOS) {
      final home = Platform.environment['HOME'];

      if (home == null || home.trim().isEmpty) {
        throw StateError('Não foi possível localizar a pasta HOME no macOS.');
      }

      return _join(
        _join(home, 'Library'),
        _join('Application Support', applicationFolderName),
      );
    }

    throw UnsupportedError(
      'Sistema operacional não suportado para armazenamento local.',
    );
  }

  static Future<void> _createDirectories() async {
    final directories = <Directory>[
      rootDirectory,
      databaseDirectory,
      backupDirectory,
      configDirectory,
      exportsDirectory,
      importsDirectory,
      logsDirectory,
      tempDirectory,
    ];

    for (final directory in directories) {
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
    }
  }

  static String _join(String first, String second) {
    final separator = Platform.pathSeparator;

    final normalizedFirst = first.endsWith(separator)
        ? first.substring(0, first.length - 1)
        : first;

    final normalizedSecond = second.startsWith(separator)
        ? second.substring(1)
        : second;

    return '$normalizedFirst$separator$normalizedSecond';
  }

  static void _ensureInitialized() {
    if (!_initialized) {
      throw StateError(
        'AppPaths ainda não foi inicializado. '
        'Execute AppPaths.initialize() antes de utilizar os caminhos.',
      );
    }
  }
}
