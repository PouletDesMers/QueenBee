import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'data/fake_queenbee_repository.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/home/presentation/home_shell.dart';

class QueenBeeApp extends StatefulWidget {
  const QueenBeeApp({super.key});

  @override
  State<QueenBeeApp> createState() => _QueenBeeAppState();
}

class _QueenBeeAppState extends State<QueenBeeApp> {
  final FakeQueenBeeRepository repository = FakeQueenBeeRepository();
  bool isAuthenticated = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QueenBee',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: isAuthenticated
          ? HomeShell(
              repository: repository,
              onLogout: () => setState(() => isAuthenticated = false),
            )
          : LoginScreen(
              onLogin: () => setState(() => isAuthenticated = true),
            ),
    );
  }
}
