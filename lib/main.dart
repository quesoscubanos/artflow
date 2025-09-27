import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:artflowrise/core/di/injection_container.dart';
import 'package:artflowrise/core/router/app_router.dart';
import 'package:artflowrise/core/theme/app_theme.dart';
import 'package:artflowrise/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:artflowrise/features/tutorials/presentation/bloc/tutorials_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await initializeDependencies();
  } catch (e) {
    // Fallback to basic app without dependencies
    runApp(const MaterialApp(home: Scaffold(body: Center(child: Text('Error loading dependencies')))));
    return;
  }

  runApp(const ArtFlowRiseApp());
}

class ArtFlowRiseApp extends StatelessWidget {
  const ArtFlowRiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<AuthBloc>()..add(AuthCheckRequested()),
        ),
        BlocProvider(
          create: (_) => getIt<TutorialsBloc>()..add(LoadTutorials()),
        ),
      ],
      child: MaterialApp.router(
        title: 'ArtFlowRise',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
