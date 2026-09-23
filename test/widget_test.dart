import 'package:agg/widgets/dialog_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('dialog box shows three action buttons in the requested layout', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: DialogBox(
              title: 'Confirm action',
              message: 'Choose one option.',
              primaryButtonText: 'Cancel',
              secondaryButtonText: 'Continue',
              tertiaryButtonText: 'More info',
              onPrimaryPressed: () {},
              onSecondaryPressed: () {},
              onTertiaryPressed: () {},
            ),
          ),
        ),
      ),
    );

    expect(find.text('Confirm action'), findsOneWidget);
    expect(find.text('Choose one option.'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
    expect(find.text('More info'), findsOneWidget);
    expect(find.byType(TextButton), findsNWidgets(3));
  });
}
