// UI-first smoke test: onboarding renders tagline + CTA.
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/app/app.dart';

void main() {
  testWidgets('Onboarding renders tagline and CTA', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const KosanKuApp());

    expect(find.textContaining('TEMUKAN'), findsOneWidget);
    expect(find.text('Mulai Sekarang'), findsOneWidget);
    expect(find.text('Masuk'), findsOneWidget);
  });
}
