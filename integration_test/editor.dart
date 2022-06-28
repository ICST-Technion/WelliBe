import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:wellibe_proj/screens/card.dart' as card;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('add text, verify change in text',
            (tester) async {
          card.test();
          await tester.pumpAndSettle();

          // Finds the textbox and button
          final Finder fab = find.byTooltip('textbox');
          final Finder button = find.byTooltip('color_red');

          // Verify no text at start.
          //expect(tester.testTextInput, '');

          //verify start color was black
          expect((fab as TextField).style?.color, Colors.black);

          // Emulate a tap on the textbox and insert text.
          await tester.tap(button);
          //await tester.enterText(fab, 'thank you!');

          // Verify text
          //expect(tester.testTextInput, 'thank you!');
          // Verify text color
          expect((fab as TextField).style?.color, Colors.red);
        });
  });
}
