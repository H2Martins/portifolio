import 'package:flutter/material.dart';

@immutable
class AppStrings {
  const AppStrings._({
    required this.role,
    required this.description,
    required this.contact,
    required this.contactSemantics,
    required this.capabilities,
    required this.themeTooltip,
    required this.languageTooltip,
    required this.emailSubject,
  });

  final String role;
  final String description;
  final String contact;
  final String contactSemantics;
  final List<String> capabilities;
  final String themeTooltip;
  final String languageTooltip;
  final String emailSubject;

  static const ptBr = AppStrings._(
    role: 'DESENVOLVEDOR FULL STACK',
    description:
        'Crio produtos digitais resilientes onde interfaces bem pensadas encontram arquitetura de verdade — de experiências mobile em tempo real a APIs de alta performance.',
    contact: 'Vamos começar',
    contactSemantics: 'Abrir o Hugo OS',
    capabilities: [
      'MOBILE',
      'SISTEMAS EM TEMPO REAL',
      'ARQUITETURA LIMPA',
      'OFFLINE-FIRST',
    ],
    themeTooltip: 'Alterar tema',
    languageTooltip: 'Mudar para inglês',
    emailSubject: 'Vamos construir algo incrível',
  );

  static const en = AppStrings._(
    role: 'FULL STACK DEVELOPER',
    description:
        'I engineer resilient digital products where thoughtful interfaces meet serious architecture — from real-time mobile experiences to high-performance APIs.',
    contact: 'Let’s begin',
    contactSemantics: 'Open Hugo OS',
    capabilities: [
      'MOBILE',
      'REAL-TIME SYSTEMS',
      'CLEAN ARCHITECTURE',
      'OFFLINE-FIRST',
    ],
    themeTooltip: 'Change theme',
    languageTooltip: 'Mudar para português',
    emailSubject: 'Let’s build something remarkable',
  );

  static AppStrings of(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'pt' ? ptBr : en;
}
