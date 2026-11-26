import 'dart:ui' show Tristate;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindful/app/localization/locale_controller.dart';
import 'package:mindful/app/theme/app_theme.dart';
import 'package:mindful/core/widgets/primary_button.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('calls onPressed when tapped', (tester) async {
    var taps = 0;
    await tester.pumpApp(PrimaryButton(label: 'Continue', onPressed: () => taps++));

    await tester.tap(find.text('Continue'));
    expect(taps, 1);
  });

  testWidgets('is disabled when onPressed is null', (tester) async {
    await tester.pumpApp(const PrimaryButton(label: 'Continue', onPressed: null));

    final semantics = tester.getSemantics(find.byType(PrimaryButton));
    expect(semantics.flagsCollection.isEnabled, Tristate.isFalse);
  });

  testWidgets('shows a spinner and ignores taps while loading', (tester) async {
    var taps = 0;
    await tester.pumpApp(PrimaryButton(label: 'Save', isLoading: true, onPressed: () => taps++));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Save'), findsNothing);
    await tester.tap(find.byType(PrimaryButton));
    expect(taps, 0);
  });

  testWidgets('places the trailing icon after the label in RTL', (tester) async {
    await tester.pumpApp(
      PrimaryButton(label: 'متابعة', trailingIcon: Icons.arrow_forward_rounded, onPressed: () {}),
      locale: AppLocales.ar,
    );

    final label = tester.getCenter(find.text('متابعة'));
    final icon = tester.getCenter(find.byIcon(Icons.arrow_forward_rounded));
    expect(icon.dx, lessThan(label.dx), reason: 'in RTL, "after" means to the left');
  });

  testWidgets('renders in dark theme', (tester) async {
    await tester.pumpApp(
      PrimaryButton(label: 'Continue', onPressed: () {}),
      theme: AppTheme.dark(),
    );
    expect(find.text('Continue'), findsOneWidget);
  });
}
