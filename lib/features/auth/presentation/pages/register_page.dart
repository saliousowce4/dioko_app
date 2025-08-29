
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/responsive_center.dart';
import '../manager/auth_providers.dart';
import '../manager/auth_state.dart';

class RegisterPage extends ConsumerWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      if (next is AuthError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.message), backgroundColor: Colors.red),
        );
      } else if (next is Authenticated) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Compte créé avec succès ! Bienvenue.'),
            backgroundColor: Colors.green,
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Theme.of(context).primaryColor,
          onPressed: () => context.go('/login'),
        ),

      ),

      body: SafeArea(
        child: ResponsiveCenter(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                const SizedBox(height: 48),
                const Text(
                  'Créer votre compte',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  controller: nameController,
                  labelText: 'Nom complet',
                  validator: (value) => value!.isEmpty ? 'Veuillez entrer votre nom' : null,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: emailController,
                  labelText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => value!.isEmpty ? 'Veuillez entrer un email' : null,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: passwordController,
                  labelText: 'Mot de passe',
                  obscureText: true,
                  validator: (value) => (value?.length ?? 0) < 8 ? 'Le mot de passe doit faire au moins 8 caractères' : null,
                ),
                const SizedBox(height: 32),
                Consumer(
                  builder: (context, ref, child) {
                    final authState = ref.watch(authNotifierProvider);
                    return PrimaryButton(
                      text: 'Créer le compte',
                      isLoading: authState is AuthLoading,
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          ref.read(authNotifierProvider.notifier).register(
                            name: nameController.text.trim(),
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                          );
                        }
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => context.go('/login'),
                  child: const Text('Déjà un compte ? Se connecter'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}