import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/features/explore/presentation/pages/explore_page.dart';

/// UI-first: explore render header, search, filter, cards, bottom nav.
void main() {
  Future<void> pumpExplore(WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ExplorePage()));
  }

  testWidgets('Render header, search, filter, dan section',
      (WidgetTester tester) async {
    await pumpExplore(tester);

    expect(find.text('Explore Kos'), findsOneWidget);
    expect(find.text('Jakarta Selatan'), findsOneWidget);
    expect(find.text('Cari nama kos, area, kampus...'), findsOneWidget);
    expect(find.text('Semua Tipe'), findsOneWidget);
    expect(find.text('Kos Unggulan'), findsOneWidget);
    expect(find.text('Rekomendasi Terdekat'), findsOneWidget);
    expect(find.text('Unggulan'), findsOneWidget);
  });

  testWidgets('Featured tampil, filter Putri menyaring hasil',
      (WidgetTester tester) async {
    await pumpExplore(tester);

    expect(find.text('KosanKu Urban Kemang'), findsOneWidget);

    await tester.tap(find.text('Putri'));
    await tester.pump();

    expect(find.text('Pavilion Asri Tebet'), findsOneWidget);
    expect(find.text('KosanKu Urban Kemang'), findsNothing);
    expect(find.text('Kos Unggulan'), findsNothing);
  });

  testWidgets('Search menyaring berdasarkan nama', (WidgetTester tester) async {
    await pumpExplore(tester);

    await tester.enterText(
      find.byType(TextField),
      'tebet',
    );
    await tester.pump();

    expect(find.text('Pavilion Asri Tebet'), findsOneWidget);
    expect(find.text('Kost Griya Melati'), findsNothing);
  });

  testWidgets('Toggle favorit mengisi ikon hati', (WidgetTester tester) async {
    await pumpExplore(tester);
    Finder faIcon(FaIconData icon) => find.byWidgetPredicate(
          (w) =>
              w is FaIcon &&
              w.icon?.codePoint == icon.codePoint &&
              w.icon?.fontFamily == icon.fontFamily,
        );

    expect(faIcon(FontAwesomeIcons.solidHeart), findsNothing);
    await tester.tap(faIcon(FontAwesomeIcons.heart).first);
    await tester.pump();

    expect(faIcon(FontAwesomeIcons.solidHeart), findsOneWidget);
  });
}
