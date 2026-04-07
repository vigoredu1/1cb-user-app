import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:one_click_builder/main.dart';

void main() {
  testWidgets('MyApp renders the injected home widget', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MyApp(
        home: Scaffold(
          body: Center(
            child: Text('test-home'),
          ),
        ),
      ),
    );

    expect(find.text('test-home'), findsOneWidget);
    expect(find.byType(GetMaterialApp), findsOneWidget);
  });
}
