import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import 'router/app_router.dart';

/// Root widget — MaterialApp/router + ThemeData dari core/theme.
/// Light & dark mode mengikuti DESIGN.md (system preference).
class KosanKuApp extends StatelessWidget {
  const KosanKuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'KosanKu',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
    );
  }
}
