import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:hugo_portfolio/app/app.dart';

void main() {
  testWidgets('intro presents Hugo and the primary action', (tester) async {
    await tester.pumpWidget(const PortfolioApp());
    await tester.pump(const Duration(milliseconds: 900));

    expect(find.text('Hugo Henrique\nMartins.'), findsOneWidget);
    expect(find.text('DESENVOLVEDOR FULL STACK'), findsOneWidget);
    expect(find.text('Vamos começar'), findsOneWidget);
    expect(find.text('PT'), findsOneWidget);

    await tester.tap(find.text('PT'));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('FULL STACK DEVELOPER'), findsOneWidget);
    expect(find.text('Let’s begin'), findsOneWidget);
    expect(find.text('EN'), findsOneWidget);
  });

  testWidgets('primary action opens Hugo OS with social and project apps', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const PortfolioApp());
    await tester.pump(const Duration(milliseconds: 900));

    await tester.tap(find.text('Vamos começar'));
    await tester.pumpAndSettle();

    expect(find.text('HUGO OS'), findsOneWidget);
    expect(find.text('LinkedIn'), findsWidgets);
    expect(find.text('GitHub'), findsWidgets);
    expect(find.text('Nexus'), findsOneWidget);
    expect(find.text('Pulse'), findsOneWidget);

    await tester.tap(find.text('Nexus'));
    await tester.pumpAndSettle();

    expect(find.text('PROJETO EM BREVE'), findsOneWidget);
    expect(find.textContaining('plataforma conectada'), findsOneWidget);

    await tester.tap(find.byTooltip('Voltar à tela inicial'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Contato'));
    await tester.pumpAndSettle();

    expect(find.text('Araçoiaba da Serra · SP'), findsOneWidget);
    expect(find.text('hhugomts@gmail.com'), findsOneWidget);
    expect(find.text('(15) 99610-6082'), findsOneWidget);
  });
}
