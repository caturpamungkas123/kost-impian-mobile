import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/features/favorites/presentation/pages/favorites_page.dart';

/// UI-first: favorit render header, filter, kartu, banner, bottom nav.
void main() {
  Future<void> pumpFav(WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: FavoritesPage()));
  }

  Finder cardHearts() => find.byWidgetPredicate(
        (w) =>
            w is FaIcon &&
            w.icon?.codePoint == FontAwesomeIcons.solidHeart.codePoint &&
            w.icon?.fontFamily ==
                FontAwesomeIcons.solidHeart.fontFamily &&
            w.semanticLabel == 'Hapus dari favorit',
      );

  testWidgets('Render header, filter, kartu, dan banner',
      (WidgetTester tester) async {
    await pumpFav(tester);

    expect(find.text('Kos Favorit'), findsOneWidget);
    expect(find.text('3 kos idaman tersimpan'), findsOneWidget);
    expect(find.text('Semua (3)'), findsOneWidget);
    expect(find.text('KosanKu Urban Kemang'), findsOneWidget);
    expect(find.text('Sisa 2 Kamar'), findsOneWidget);
    expect(find.text('4.9'), findsOneWidget);
    expect(find.text('Lihat Detail'), findsNWidgets(3));
    expect(find.text('Chat Pemilik'), findsOneWidget);
    expect(find.text('Bandingkan'), findsOneWidget);
  });

  testWidgets('Filter Putri menyaring hasil', (WidgetTester tester) async {
    await pumpFav(tester);

    await tester.tap(find.text('Putri'));
    await tester.pump();

    expect(find.text('Pavilion Asri Tebet'), findsOneWidget);
    expect(find.text('KosanKu Urban Kemang'), findsNothing);
  });

  testWidgets('Tap hati menghapus dari favorit', (WidgetTester tester) async {
    await pumpFav(tester);

    final hearts = cardHearts();
    expect(hearts, findsNWidgets(3));
    await tester.tap(hearts.first);
    await tester.pumpAndSettle();

    expect(find.text('KosanKu Urban Kemang'), findsNothing);
    expect(find.text('2 kos idaman tersimpan'), findsOneWidget);
    expect(cardHearts(), findsNWidgets(2));
  });

  testWidgets('Hapus semua menampilkan empty state',
      (WidgetTester tester) async {
    await pumpFav(tester);

    for (var i = 0; i < 3; i++) {
      await tester.tap(cardHearts().first);
      await tester.pumpAndSettle();
    }

    expect(find.text('Belum ada favorit'), findsOneWidget);
  });
}
