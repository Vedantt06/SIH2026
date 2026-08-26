import 'package:flutter_test/flutter_test.dart';

import 'package:mahapashu_suraksha/main.dart';

void main() {
  testWidgets(
    'MahaPashu Suraksha app starts',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MahaPashuSurakshaApp(),
      );

      expect(
        find.text('MahaPashu Suraksha'),
        findsOneWidget,
      );
    },
  );
}