import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tollywood_quiz/data/score_store.dart';
import 'package:tollywood_quiz/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await ScoreStore.initialize();
  });

  testWidgets('Tollywood Quiz application renders',
      (WidgetTester tester) async {
    await tester.pumpWidget(const TollywoodQuizApp());
    await tester.pump();

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
