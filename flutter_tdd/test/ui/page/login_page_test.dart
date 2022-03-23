import 'package:flutter/material.dart';
import 'package:flutter_tdd/ui/pages/login_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Should load with correct initial state', (WidgetTester tester) async {
    final loginPage = MaterialApp(home: LoginPage());
    await tester.pumpWidget(loginPage);

    /// If textFormField has only one string label, means has no one error mensagem on screen
    final emailTextChildren = find.descendant(of: find.bySemanticsLabel('Email'), matching: find.byType(Text));
    expect(emailTextChildren, findsOneWidget);

    final passwordPage = MaterialApp(home: LoginPage());
    await tester.pumpWidget(passwordPage);

    /// If textFormField has only one string label, means has no one error mensagem on screen
    final passwordTextChildren = find.descendant(of: find.bySemanticsLabel('Senha'), matching: find.byType(Text));
    expect(passwordTextChildren, findsOneWidget);

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, null);
  });
}
