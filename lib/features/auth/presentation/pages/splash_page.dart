import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:artflowrise/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:artflowrise/core/theme/app_theme.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          if (state.isAdmin) {
            context.go('/admin');
          } else {
            context.go('/dashboard');
          }
        } else if (state is AuthUnauthenticated) {
          // Navigate to welcome page instead of login directly
          context.go('/welcome');
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Image.asset(
                  'logo/logo.png',
                  width: 60,
                  height: 60,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 24),
              
              // App name
              const Text(
                'ArtFlowRise',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 8),
              
              // Tagline
              const Text(
                'Libera Tu Potencial Creativo',
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.textSecondary,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 48),
              
              // Loading indicator
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryBlue),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
