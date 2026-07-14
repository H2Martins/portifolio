import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/theme/app_theme.dart';

@immutable
class ProfessionalExperience {
  const ProfessionalExperience({
    required this.role,
    required this.company,
    required this.period,
    required this.description,
    required this.technologies,
    this.current = false,
  });

  final String role;
  final String company;
  final String period;
  final String description;
  final List<String> technologies;
  final bool current;
}

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  static const experiences = [
    ProfessionalExperience(
      role: 'Desenvolvedor Full Stack',
      company: 'Ludare Bank',
      period: 'Maio de 2025 – Presente',
      current: true,
      description:
          'Atuo no desenvolvimento de aplicações modernas utilizando Flutter e .NET, com foco em performance, escalabilidade e experiência do usuário. Participo da criação e evolução de funcionalidades para o LudareApp, desenvolvendo soluções voltadas para comunicação em tempo real, sincronização de dados, integrações com APIs e arquitetura de aplicações multiplataforma.',
      technologies: [
        'Flutter',
        'Dart',
        '.NET',
        'C#',
        'SignalR',
        'SQLite',
        'Firebase',
        'REST API',
        'WebRTC',
        'Python',
        'SQL',
        'Git',
      ],
    ),
    ProfessionalExperience(
      role: 'Consultor SAP WM / EWM',
      company: 'Ludare Tecnologia',
      period: 'Maio de 2025',
      description:
          'Iniciei minha trajetória na empresa atuando com os módulos SAP WM e SAP EWM, participando de atividades relacionadas à logística e processos empresariais. Essa experiência proporcionou uma visão sólida sobre regras de negócio e processos corporativos antes da minha migração para a área de desenvolvimento de software.',
      technologies: ['SAP WM', 'SAP EWM'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.portfolioColors.canvas,
      child: Stack(
        children: [
          const Positioned.fill(child: _ExperienceAtmosphere()),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final desktop = constraints.maxWidth >= 1100;
                final mobile = constraints.maxWidth < 650;
                final horizontal = desktop
                    ? 64.0
                    : mobile
                    ? 20.0
                    : 40.0;
                return SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    horizontal,
                    mobile ? 38 : 64,
                    horizontal,
                    mobile ? 48 : 72,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1180),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SectionHeader(mobile: mobile),
                          SizedBox(height: mobile ? 42 : 64),
                          const ExperienceTimeline(experiences: experiences),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ExperienceTimeline extends StatelessWidget {
  const ExperienceTimeline({super.key, required this.experiences});

  final List<ProfessionalExperience> experiences;

  @override
  Widget build(BuildContext context) {
    final desktop = MediaQuery.sizeOf(context).width >= 1100;
    final reducedMotion = MediaQuery.disableAnimationsOf(context);
    return Column(
      children: [
        for (var index = 0; index < experiences.length; index++)
          _TimelineEntry(
            experience: experiences[index],
            index: index,
            total: experiences.length,
            desktop: desktop,
            reducedMotion: reducedMotion,
          ),
      ],
    );
  }
}

class _TimelineEntry extends StatelessWidget {
  const _TimelineEntry({
    required this.experience,
    required this.index,
    required this.total,
    required this.desktop,
    required this.reducedMotion,
  });

  final ProfessionalExperience experience;
  final int index;
  final int total;
  final bool desktop;
  final bool reducedMotion;

  @override
  Widget build(BuildContext context) {
    Widget card = ExperienceCard(experience: experience);
    if (!reducedMotion) {
      card = card
          .animate()
          .fadeIn(delay: (160 + index * 160).ms, duration: 600.ms)
          .slideY(begin: .08, end: 0, curve: Curves.easeOutCubic);
    }

    if (!desktop) {
      return IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TimelineAxis(index: index, total: total),
            const SizedBox(width: 18),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(bottom: index == total - 1 ? 0 : 28),
                child: card,
              ),
            ),
          ],
        ),
      );
    }

    final cardSide = Expanded(child: card);
    const emptySide = Expanded(child: SizedBox());
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (index.isEven) cardSide else emptySide,
          const SizedBox(width: 28),
          _TimelineAxis(index: index, total: total),
          const SizedBox(width: 28),
          if (index.isEven) emptySide else cardSide,
        ],
      ),
    );
  }
}

class _TimelineAxis extends StatelessWidget {
  const _TimelineAxis({required this.index, required this.total});

  final int index;
  final int total;

  @override
  Widget build(BuildContext context) {
    final stroke = context.portfolioColors.stroke;
    return SizedBox(
      width: 20,
      child: Column(
        children: [
          Expanded(
            child: Container(
              width: 1,
              color: index == 0 ? Colors.transparent : stroke,
            ),
          ),
          Container(
            width: 11,
            height: 11,
            decoration: BoxDecoration(
              color: context.portfolioColors.accent,
              shape: BoxShape.circle,
              border: Border.all(
                color: context.portfolioColors.canvas,
                width: 3,
                strokeAlign: BorderSide.strokeAlignOutside,
              ),
              boxShadow: [
                BoxShadow(
                  color: context.portfolioColors.accent.withValues(alpha: .32),
                  blurRadius: 14,
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: 1,
              color: index == total - 1 ? Colors.transparent : stroke,
            ),
          ),
        ],
      ),
    );
  }
}

class ExperienceCard extends StatefulWidget {
  const ExperienceCard({super.key, required this.experience});

  final ProfessionalExperience experience;

  @override
  State<ExperienceCard> createState() => _ExperienceCardState();
}

class _ExperienceCardState extends State<ExperienceCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.portfolioColors;
    final reducedMotion = MediaQuery.disableAnimationsOf(context);
    final mobile = MediaQuery.sizeOf(context).width < 650;
    final duration = reducedMotion ? Duration.zero : 220.ms;
    return Semantics(
      container: true,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: AnimatedSlide(
          duration: duration,
          curve: Curves.easeOutCubic,
          offset: _hovered && !reducedMotion
              ? const Offset(0, -.012)
              : Offset.zero,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: AnimatedContainer(
                duration: duration,
                curve: Curves.easeOutCubic,
                padding: EdgeInsets.all(mobile ? 22 : 28),
                decoration: BoxDecoration(
                  color: colors.surface.withValues(alpha: _hovered ? .88 : .7),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: _hovered
                        ? colors.accent.withValues(alpha: .42)
                        : colors.stroke.withValues(alpha: .82),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: _hovered ? .12 : .06,
                      ),
                      blurRadius: _hovered ? 28 : 18,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _PeriodBadge(experience: widget.experience),
                    const SizedBox(height: 20),
                    Text(
                      widget.experience.role,
                      style: TextStyle(
                        fontSize: mobile ? 24 : 29,
                        height: 1.08,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.experience.company,
                      style: TextStyle(
                        color: colors.accent,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        letterSpacing: .1,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      widget.experience.description,
                      style: TextStyle(
                        color: colors.muted,
                        fontSize: mobile ? 13.5 : 14,
                        height: 1.62,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final technology in widget.experience.technologies)
                          ExperienceChip(label: technology),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ExperienceChip extends StatelessWidget {
  const ExperienceChip({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Tecnologia: $label',
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: context.portfolioColors.accent.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: context.portfolioColors.accent.withValues(alpha: .2),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: context.portfolioColors.accent,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: .25,
        ),
      ),
    ),
  );
}

class _PeriodBadge extends StatelessWidget {
  const _PeriodBadge({required this.experience});

  final ProfessionalExperience experience;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: context.portfolioColors.canvas.withValues(alpha: .52),
      borderRadius: BorderRadius.circular(100),
      border: Border.all(color: context.portfolioColors.stroke),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (experience.current) ...[
          Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              color: Color(0xFF6FE7A8),
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Color(0x806FE7A8), blurRadius: 8)],
            ),
          ),
          const SizedBox(width: 8),
        ],
        Text(
          experience.period.toUpperCase(),
          style: TextStyle(
            color: context.portfolioColors.muted,
            fontSize: 9,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.05,
          ),
        ),
      ],
    ),
  );
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.mobile});

  final bool mobile;

  @override
  Widget build(BuildContext context) {
    Widget header = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 28,
              height: 1,
              color: context.portfolioColors.accent,
            ),
            const SizedBox(width: 12),
            Text(
              'TRAJETÓRIA',
              style: TextStyle(
                color: context.portfolioColors.accent,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 2.1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Semantics(
          header: true,
          child: Text(
            'Experiência Profissional',
            style: TextStyle(
              fontSize: mobile ? 38 : 54,
              height: .98,
              fontWeight: FontWeight.w700,
              letterSpacing: mobile ? -2 : -2.8,
            ),
          ),
        ),
      ],
    );
    if (MediaQuery.disableAnimationsOf(context)) return header;
    return header
        .animate()
        .fadeIn(duration: 600.ms)
        .slideY(begin: .08, end: 0, curve: Curves.easeOutCubic);
  }
}

class _ExperienceAtmosphere extends StatelessWidget {
  const _ExperienceAtmosphere();

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      gradient: RadialGradient(
        center: const Alignment(-.82, -.72),
        radius: 1.15,
        colors: [
          context.portfolioColors.accent.withValues(alpha: .1),
          Colors.transparent,
        ],
      ),
    ),
  );
}
