import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:queenbee_mobile/src/app.dart';

void main() {
  testWidgets('displays the QueenBee login screen', (tester) async {
    await tester.pumpWidget(const QueenBeeApp());

    expect(find.text('QueenBee'), findsOneWidget);
    expect(find.text('Se connecter'), findsOneWidget);
  });

  testWidgets('logs in to the hive dashboard', (tester) async {
    await tester.pumpWidget(const QueenBeeApp());
    await tester.enterText(find.byType(TextFormField).first, 'apiculteur@beeafrica.org');
    await tester.enterText(find.byType(TextFormField).last, 'password');
    await tester.tap(find.text('Se connecter'));
    await tester.pumpAndSettle();

    expect(find.text('Mes ruches'), findsWidgets);
    expect(find.text('Ruche A-01'), findsOneWidget);
  });
}
