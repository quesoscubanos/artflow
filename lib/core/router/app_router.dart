import 'package:go_router/go_router.dart';
import 'package:artflowrise/features/auth/presentation/pages/login_page.dart';
import 'package:artflowrise/features/auth/presentation/pages/register_page.dart';
import 'package:artflowrise/features/auth/presentation/pages/splash_page.dart';
import 'package:artflowrise/features/auth/presentation/pages/welcome_page.dart';
import 'package:artflowrise/features/dashboard/presentation/pages/main_navigation_page.dart';
import 'package:artflowrise/features/profile/presentation/pages/profile_page.dart';
import 'package:artflowrise/features/gallery/presentation/pages/gallery_page.dart';
import 'package:artflowrise/features/tutorials/presentation/pages/tutorials_page.dart';
import 'package:artflowrise/features/tutorials/presentation/pages/tutorial_detail_page.dart';
import 'package:artflowrise/features/challenges/presentation/pages/challenges_page.dart';
import 'package:artflowrise/features/admin/presentation/pages/admin_main_navigation_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/',
        redirect: (context, state) => '/splash',
      ),
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomePage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainNavigationPage(child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => const DashboardPage(),
          ),
          GoRoute(
            path: '/gallery',
            builder: (context, state) => const GalleryPage(),
          ),
          GoRoute(
            path: '/tutorials',
            builder: (context, state) => const TutorialsPage(),
          ),
          GoRoute(
            path: '/tutorial/:tutorialId',
            builder: (context, state) {
              final tutorialId = state.pathParameters['tutorialId'] ?? '';
              final stepParam = state.uri.queryParameters['step'];
              final initialStep = stepParam != null ? int.tryParse(stepParam) ?? 0 : 0;
              return TutorialDetailPage(
                tutorialId: tutorialId,
                initialStep: initialStep,
              );
            },
          ),
          GoRoute(
            path: '/challenges',
            builder: (context, state) => const ChallengesPage(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfilePage(),
          ),
        ],
      ),
      GoRoute(
        path: '/admin',
        builder: (context, state) => const AdminMainNavigationPage(),
      ),
    ],
  );
}
