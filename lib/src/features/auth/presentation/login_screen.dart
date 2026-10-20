import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({required this.onLogin, super.key});

  final VoidCallback onLogin;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  bool rememberDevice = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(Icons.hive, size: 72, color: AppTheme.honey),
                    const SizedBox(height: 16),
                    Text(
                      'QueenBee',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.ink,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Veiller sur chaque ruche, même hors réseau.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 40),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Adresse email',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Email requis' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Mot de passe',
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Mot de passe requis'
                          : null,
                    ),
                    const SizedBox(height: 8),
                    CheckboxListTile(
                      value: rememberDevice,
                      onChanged: (value) =>
                          setState(() => rememberDevice = value ?? false),
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Se souvenir de cet appareil'),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () {
                        if (formKey.currentState!.validate()) widget.onLogin();
                      },
                      icon: const Icon(Icons.login),
                      label: const Padding(
                        padding: EdgeInsets.all(14),
                        child: Text('Se connecter'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Le déverrouillage PIN / biométrie et le MFA seront branchés au service d’authentification.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
