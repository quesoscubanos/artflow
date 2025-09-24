import 'package:get_it/get_it.dart';
import 'package:artflowrise/features/auth/presentation/bloc/auth_bloc.dart';

final getIt = GetIt.instance;

Future<void> initializeDependencies() async {
  print('Initializing dependency injection...');

  // Register AuthBloc
  getIt.registerFactory<AuthBloc>(() => AuthBloc());

  print('Dependency injection initialized successfully');
}