import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:artflowrise/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:artflowrise/features/tutorials/presentation/bloc/tutorials_bloc.dart';

final getIt = GetIt.instance;

Future<void> initializeDependencies() async {
  debugPrint('Initializing dependency injection...');

  // Register AuthBloc
  getIt.registerFactory<AuthBloc>(() => AuthBloc());

  // Register TutorialsBloc
  getIt.registerFactory<TutorialsBloc>(() => TutorialsBloc());

  debugPrint('Dependency injection initialized successfully');
}