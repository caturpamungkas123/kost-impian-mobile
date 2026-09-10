import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/features/auth/presentation/pages/auth_page.dart';
import 'package:mobile/features/explore/presentation/pages/explore_page.dart';

/// UI-first: halaman auth render tab, pilih peran, dan form.
void main() {
  Future<void> pumpAuth(WidgetTester tester, {bool login = false}) async {
    await tester.pumpWidget(
      MaterialApp(home: AuthPage(initialIsLogin: login)),
    );
  }

  testWidgets('Register mode default: ada nama, WA, dan CTA daftar',
      (WidgetTester tester) async {
    await pumpAuth(tester);

    expect(find.text('Daftar Akun'), findsOneWidget);
    expect(find.text('Pencari Kos'), findsWidgets);
    expect(find.text('Pemilik Kos'), findsWidgets);
    expect(find.text('Nama Lengkap'), findsOneWidget);
    expect(find.text('Nomor WhatsApp Aktif'), findsOneWidget);
    expect(find.text('Daftar Sebagai Pencari Kos'), findsOneWidget);
    expect(find.text('Lupa Password?'), findsNothing);
  });

  testWidgets('Login mode: tanpa nama/WA, ada Lupa Password',
      (WidgetTester tester) async {
    await pumpAuth(tester, login: true);

    expect(find.text('Nama Lengkap'), findsNothing);
    expect(find.text('Nomor WhatsApp Aktif'), findsNothing);
    expect(find.text('Lupa Password?'), findsOneWidget);
    expect(find.textContaining('Masuk ke Akun'), findsOneWidget);
  });

  testWidgets('Ganti peran mengubah label CTA', (WidgetTester tester) async {
    await pumpAuth(tester);

    await tester.tap(find.text('Pemilik Kos'));
    await tester.pump();

    expect(find.text('Daftar Sebagai Pemilik Kos'), findsOneWidget);
  });

  testWidgets('Submit kosong menampilkan error wajib isi',
      (WidgetTester tester) async {
    await pumpAuth(tester);

    final cta = find.text('Daftar Sebagai Pencari Kos');
    await tester.ensureVisible(cta);
    await tester.pumpAndSettle();
    await tester.tap(cta);
    await tester.pump();

    expect(find.text('Nama Lengkap wajib diisi'), findsOneWidget);
    expect(find.text('Nomor WhatsApp wajib diisi'), findsOneWidget);
    expect(find.text('Email wajib diisi'), findsOneWidget);
    expect(find.text('Kata sandi wajib diisi'), findsOneWidget);
  });

  testWidgets('Tipe data salah menampilkan error format',
      (WidgetTester tester) async {
    await pumpAuth(tester);
    final fields = find.byType(TextFormField);

    await tester.enterText(fields.at(0), 'Rian Pratama');
    await tester.enterText(fields.at(1), 'abc');
    await tester.enterText(fields.at(2), 'bukan-email');
    await tester.enterText(fields.at(3), '123');
    final cta = find.text('Daftar Sebagai Pencari Kos');
    await tester.ensureVisible(cta);
    await tester.pumpAndSettle();
    await tester.tap(cta);
    await tester.pump();

    expect(find.text('Nomor WhatsApp tidak valid'), findsOneWidget);
    expect(find.text('Format email tidak valid'), findsOneWidget);
    expect(find.text('Kata sandi minimal 8 karakter'), findsOneWidget);
    expect(find.text('Nama Lengkap wajib diisi'), findsNothing);
  });

  testWidgets('Input valid tidak menampilkan error',
      (WidgetTester tester) async {
    await pumpAuth(tester);
    final fields = find.byType(TextFormField);

    await tester.enterText(fields.at(0), 'Rian Pratama');
    await tester.enterText(fields.at(1), '081234567890');
    await tester.enterText(fields.at(2), 'rian@email.com');
    await tester.enterText(fields.at(3), 'rahasia123');
    final cta = find.text('Daftar Sebagai Pencari Kos');
    await tester.ensureVisible(cta);
    await tester.pumpAndSettle();
    await tester.tap(cta);
    await tester.pump();

    expect(find.textContaining('wajib diisi'), findsNothing);
    expect(find.textContaining('tidak valid'), findsNothing);
    expect(find.textContaining('minimal 8 karakter'), findsNothing);
  });

  testWidgets('Login valid redirect ke Explore', (WidgetTester tester) async {
    final router = GoRouter(
      initialLocation: AuthPage.loginRoute,
      routes: [
        GoRoute(
          path: AuthPage.loginRoute,
          builder: (_, _) => const AuthPage(initialIsLogin: true),
        ),
        GoRoute(
          path: ExplorePage.routeName,
          builder: (_, _) => const ExplorePage(),
        ),
      ],
    );
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'rian@email.com');
    await tester.enterText(fields.at(1), 'rahasia123');

    final cta = find.textContaining('Masuk ke Akun');
    await tester.ensureVisible(cta);
    await tester.pumpAndSettle();
    await tester.tap(cta);
    await tester.pumpAndSettle();

    expect(find.text('Explore Kos'), findsOneWidget);
  });
}
