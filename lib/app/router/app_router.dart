import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/auth_page.dart';
import '../../features/chat/presentation/pages/chat_detail_page.dart';
import '../../features/chat/presentation/pages/chat_list_page.dart';
import '../../features/explore/presentation/pages/explore_page.dart';
import '../../features/favorites/presentation/pages/favorites_page.dart';
import '../../features/kos_detail/presentation/pages/kos_detail_page.dart';
import '../../features/listing_management/presentation/pages/kelola_listing_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/profile/presentation/pages/keamanan_page.dart';
import '../../features/profile/presentation/pages/kelola_data_pribadi_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import 'app_shell.dart';

/// go_router — disiapkan dari awal fase UI-first karena navigasi
/// antar halaman dibutuhkan sejak fase UI (AGENTS.md).
///
/// Tab utama (Explore, Peta, Favorit, Chat, Profil — prd.md §7.5) memakai
/// [StatefulShellRoute] + [AppShell] supaya SATU bottom nav permanen hidup
/// di luar konten yang dianimasikan: nav tidak ikut transisi pindah page
/// dan state tiap tab tetap terjaga. Onboarding/Auth/Detail tetap route
/// top-level (tanpa nav).
final appRouter = GoRouter(
  initialLocation: OnboardingPage.routeName,
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
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          AppShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: ExplorePage.routeName,
              builder: (context, state) => const ExplorePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: FavoritesPage.routeName,
              builder: (context, state) => const FavoritesPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: KelolaListingPage.routeName,
              builder: (context, state) => const KelolaListingPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: ChatListPage.routeName,
              builder: (context, state) => const ChatListPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: ProfilePage.routeName,
              builder: (context, state) => const ProfilePage(),
            ),
          ],
        ),
      ],
    ),
    // Drill-down di atas shell: tampil tanpa bottom nav, back kembali ke tab.
    GoRoute(
      path: KelolaDataPribadiPage.routeName,
      builder: (context, state) => const KelolaDataPribadiPage(),
    ),
    GoRoute(
      path: KeamananPage.routeName,
      builder: (context, state) => const KeamananPage(),
    ),
    GoRoute(
      path: KosDetailPage.routeName,
      builder: (context, state) => const KosDetailPage(),
    ),
    // Thread satu conversation — id dikirim via `extra` dari inbox.
    GoRoute(
      path: ChatDetailPage.routeName,
      builder: (context, state) => ChatDetailPage(
        conversationId: state.extra as String?,
      ),
    ),
  ],
);
