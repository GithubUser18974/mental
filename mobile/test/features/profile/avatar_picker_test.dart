import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindful/core/avatar/avatar_catalog.dart';
import 'package:mindful/core/avatar/avatar_view.dart';
import 'package:mindful/features/profile/presentation/widgets/avatar_picker.dart';

import '../../helpers/pump_app.dart';
import '../../helpers/pump_y_app.dart';

void main() {
  testWidgets('lays options out in rows, not one per line (regression)', (tester) async {
    usePhoneViewport(tester);
    await tester.pumpApp(
      SingleChildScrollView(
        child: AvatarPicker(value: 'lotus-lavender', onChanged: (_) {}),
      ),
    );

    // 1 preview + 12 icons + 8 colors.
    final views = find.byType(AvatarView);
    expect(views, findsNWidgets(1 + AvatarCatalog.icons.length + AvatarCatalog.colors.length));

    final firstIcon = tester.getRect(views.at(1));
    final secondIcon = tester.getRect(views.at(2));
    expect(secondIcon.top, firstIcon.top, reason: 'icons share a row');
    expect(tester.getSize(find.byType(Wrap).first).height, lessThan(200));
  });

  testWidgets('picking an icon keeps the color, picking a color keeps the icon', (tester) async {
    final picked = <String>[];
    await tester.pumpApp(
      SingleChildScrollView(
        child: AvatarPicker(value: 'lotus-lavender', onChanged: picked.add),
      ),
    );

    await tester.tap(find.bySemanticsLabel('Avatar 4').first); // 4th icon: moon
    await tester.tap(find.bySemanticsLabel('Avatar 3').last); // 3rd color: sky
    expect(picked, ['moon-lavender', 'lotus-sky']);
  });
}
