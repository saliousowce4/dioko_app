
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/responsive_center.dart';
import '../manager/auth_providers.dart';
import '../manager/auth_state.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      if (next is AuthError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.message), backgroundColor: Colors.red),
        );
      }
      // The router handles successful navigation
    });

    return Scaffold(
      // Use a SafeArea to avoid system UI (like notches)
      body: SafeArea(
        child: ResponsiveCenter(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // --- Logo ---
                Image.asset(
                  'assets/images/dioko_logo.png', // Make sure this path is correct
                  height: 90,
                ),
                const SizedBox(height: 48),

                // --- Title ---
                const Text(
                  'Se connecter',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),

                // --- Text Fields ---
                CustomTextField(
                  controller: emailController,
                  labelText: 'Votre email',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => value!.isEmpty ? 'Veuillez entrer un email' : null,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: passwordController,
                  labelText: 'Mot de passe',
                  obscureText: true,
                  validator: (value) => value!.isEmpty ? 'Veuillez entrer un mot de passe' : null,
                ),
                const SizedBox(height: 32),

                // --- Button ---
                Consumer(
                  builder: (context, ref, child) {
                    final authState = ref.watch(authNotifierProvider);
                    return PrimaryButton(
                      text: 'Connexion',
                      isLoading: authState is AuthLoading,
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          ref.read(authNotifierProvider.notifier).login(
                            emailController.text.trim(),
                            passwordController.text.trim(),
                          );
                        }
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),

                // --- Link to Register Page ---
                TextButton(
                  onPressed: () => context.go('/register'),
                  child: const Text('Pas de compte ? Créer un compte'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}