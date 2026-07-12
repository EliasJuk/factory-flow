import 'package:factory_flow/app.dart';
import 'package:factory_flow/core/config/app_paths.dart';
import 'package:factory_flow/core/database/database_manager.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppPaths.initialize();
  await DatabaseManager.initialize();

  runApp(const FactoryFlowApp());
}
