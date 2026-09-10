import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/auth_page.dart';
import '../../features/explore/presentation/pages/explore_page.dart';
import '../../features/favorites/presentation/pages/favorites_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';

/// go_router — disiapkan dari awal fase UI-first karena navigasi
/// antar halaman dibutuhkan sejak fase UI (AGENTS.md).
final appRouter = GoRouter(
  initialLocation: FavoritesPage.routeName, // TEMP screenshot
  routes: [
    GoRoute(
      path: OnboardingPage.routeName,
      builder: (context, state) => const OnboardingPage(),
    ),
    GoRoute(
      path: AuthPage.loginRoute,
      builder: (context, state) => const AuthPage(initialIsLogin: true),
    ),
    GoRoute(
      path: AuthPage.registerRoute,
      builder: (context, state) => const AuthPage(initialIsLogin: false),
    ),
    GoRoute(
      path: ExplorePage.routeName,
      builder: (context, state) => const ExplorePage(),
    ),
    GoRoute(
      path: FavoritesPage.routeName,
      builder: (context, state) => const FavoritesPage(),
    ),
  ],
);
