import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/features/chat/presentation/pages/chat_detail_page.dart';
import 'package:mobile/features/chat/presentation/pages/chat_list_page.dart';

/// UI-first: inbox render header, search, filter, tile; thread render
/// header, quick action, bubble, dan input bar.
void main() {
  Future<void> pumpInbox(WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ChatListPage()));
    // Tunggu skeleton loading (kMockNetworkDelay) selesai.
    await tester.pumpAndSettle();
  }

  Future<void> pumpThread(WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ChatDetailPage()));
    await tester.pumpAndSettle();
  }

  testWidgets('Render header, filter, dan daftar percakapan',
      (WidgetTester tester) async {
    await pumpInbox(tester);

    expect(find.text('Pesan & Interaksi'), findsOneWidget);
    expect(find.text('4 percakapan aktif terhubung'), findsOneWidget);
    expect(find.text('Ibu Ratna Dewi'), findsOneWidget);
    expect(find.text('Budi Santoso'), findsOneWidget);
    expect(find.textContaining('end-to-end'), findsOneWidget);
  });

  testWidgets('Filter Belum Dibaca menyaring hasil',
      (WidgetTester tester) async {
    await pumpInbox(tester);

    await tester.tap(find.text('Belum Dibaca'));
    await tester.pump();

    expect(find.text('Budi Santoso'), findsOneWidget);
    expect(find.text('Ibu Ratna Dewi'), findsNothing);
  });

  testWidgets('Thread render header, quick action, dan input',
      (WidgetTester tester) async {
    await pumpThread(tester);

    expect(find.text('Ibu Ratna Dewi'), findsOneWidget);
    expect(find.text('Info Kamar'), findsOneWidget);
    expect(find.text('Ajukan Observasi'), findsOneWidget);
    expect(find.text('Ajukan Sewa'), findsOneWidget);
    expect(find.text('Pilih Kamar Ini  →'), findsOneWidget);
    expect(find.text('Ketik pesan atau pertanyaan...'), findsOneWidget);
  });

  testWidgets('Quick action Info Kamar menyisipkan kartu kamar',
      (WidgetTester tester) async {
    await pumpThread(tester);

    await tester.tap(find.text('Info Kamar'));
    await tester.pump();

    expect(find.text('Pilih Kamar Ini  →'), findsNWidgets(2));
  });

  testWidgets('Kirim pesan menambahkan bubble milikku',
      (WidgetTester tester) async {
    await pumpThread(tester);

    await tester.enterText(
      find.byType(TextField),
      'Apakah bisa survei Sabtu?',
    );
    await tester.pump();
    final sendButton = find.byWidgetPredicate(
      (w) =>
          w is FaIcon &&
          w.icon?.codePoint == FontAwesomeIcons.paperPlane.codePoint,
    );
    await tester.tap(sendButton);
    await tester.pump();

    expect(find.text('Apakah bisa survei Sabtu?'), findsOneWidget);
  });
}
