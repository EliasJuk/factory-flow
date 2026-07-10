import 'package:flutter/material.dart';

import 'widgets/login_branding_panel.dart';
import 'widgets/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: LoginBrandingPanel(),
          ),
          Expanded(
            flex: 2,
            child: LoginForm(),
          ),
        ],
      ),
    );
  }
}