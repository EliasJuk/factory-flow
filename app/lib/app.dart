import 'package:flutter/material.dart';

import 'theme/app_theme.dart';

class FactoryFlowApp extends StatelessWidget {
  const FactoryFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FactoryFlow',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      home: const Scaffold(
        body: Center(
          child: Text('FactoryFlow'),
        ),
      ),
    );
  }
}