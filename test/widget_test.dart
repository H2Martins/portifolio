import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hugo_portfolio/app/app.dart';
import 'package:hugo_portfolio/features/experience/presentation/experience_section.dart';

void main() {
  for (final size in [
    const Size(360, 640),
    const Size(390, 844),
    const Size(800, 600),
    const Size(1440, 900),
  ]) {
    testWidgets('home fits $size without scrolling or overflow', (
      tester,
    ) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const PortfolioApp());
      await tester.pump(const Duration(milliseconds: 900));

      expect(
        find.descendant(
          of: find.byKey(const ValueKey('hero-section')),
          matching: find.byType(Scrollable),
        ),
        findsNothing,
      );
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('intro presents Hugo and the primary action', (tester) async {
    await tester.pumpWidget(const PortfolioApp());
    await tester.pump(const Duration(milliseconds: 900));

    expect(find.text('Hugo Henrique\nMartins.'), findsOneWidget);
    expect(find.text('DESENVOLVEDOR FULL STACK'), findsOneWidget);
    expect(find.text('Vamos começar'), findsOneWidget);
    expect(find.text('Experiência profissional'), findsOneWidget);
    expect(find.text('PT'), findsOneWidget);

    await tester.tap(find.text('PT'));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('FULL STACK DEVELOPER'), findsOneWidget);
    expect(find.text('Let’s begin'), findsOneWidget);
    expect(find.text('Professional experience'), findsOneWidget);
    expect(find.text('EN'), findsOneWidget);
  });

  testWidgets('experience timeline presents roles and technologies', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const PortfolioApp());
    await tester.pump(const Duration(milliseconds: 900));
    await tester.tap(find.text('Experiência profissional'));
    await tester.pumpAndSettle();

    expect(find.text('Experiência Profissional'), findsOneWidget);
    expect(find.text('Desenvolvedor Full Stack'), findsOneWidget);
    expect(find.text('Consultor SAP WM / EWM'), findsOneWidget);
    expect(find.text('Ludare Bank'), findsOneWidget);
    expect(find.byType(ExperienceCard), findsNWidgets(2));
    expect(find.byType(ExperienceChip), findsNWidgets(14));
    expect(tester.takeException(), isNull);
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

    final phoneSize = tester.getSize(
      find.byKey(const ValueKey('hugo-phone-frame')),
    );
    expect(phoneSize, const Size(500, 900));
    expect(find.text('HUGO OS'), findsOneWidget);
    expect(find.text('LinkedIn'), findsWidgets);
    expect(find.text('GitHub'), findsWidgets);
    expect(find.text('Ludare'), findsOneWidget);
    expect(find.text('Barbearia'), findsOneWidget);

    await tester.tap(find.text('Ludare'));
    await tester.pumpAndSettle();

    final ludareContent = find.descendant(
      of: find.byKey(const ValueKey('ludare')),
      matching: find.byType(ListView),
    );
    await tester.drag(ludareContent, const Offset(0, -620));
    await tester.pumpAndSettle();

    expect(find.text('LudareApp'), findsOneWidget);
    expect(find.textContaining('comunicação em tempo real'), findsOneWidget);

    await tester.drag(ludareContent, const Offset(0, -520));
    await tester.pumpAndSettle();

    expect(find.text('Visitar site da Ludare'), findsOneWidget);

    await tester.tap(find.byTooltip('Voltar à tela inicial'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Barbearia'));
    await tester.pumpAndSettle();

    expect(find.text('Barbearia Carvalho'), findsOneWidget);
    expect(find.text('Flutter · SQLite · Windows'), findsOneWidget);

    final barbeariaContent = find.descendant(
      of: find.byKey(const ValueKey('barbearia')),
      matching: find.byType(ListView),
    );
    await tester.drag(barbeariaContent, const Offset(0, -420));
    await tester.pumpAndSettle();

    expect(find.text('Ver código no GitHub'), findsOneWidget);

    await tester.tap(find.byTooltip('Voltar à tela inicial'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Sobre'));
    await tester.pumpAndSettle();

    expect(find.text('Sobre mim'), findsOneWidget);
    expect(
      find.textContaining('transformar ideias em soluções digitais'),
      findsOneWidget,
    );

    await tester.tap(find.byTooltip('Voltar à tela inicial'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Contato'));
    await tester.pumpAndSettle();

    expect(find.text('Araçoiaba da Serra · SP'), findsOneWidget);
    expect(find.text('hhugomts@gmail.com'), findsOneWidget);
    expect(find.text('(15) 99610-6082'), findsOneWidget);
  });
}
