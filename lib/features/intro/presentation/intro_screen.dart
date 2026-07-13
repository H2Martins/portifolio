import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/localization/app_strings.dart';
import '../../../core/theme/app_theme.dart';
import '../../phone/presentation/hugo_phone.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({
    super.key,
    required this.themeMode,
    required this.onThemeChanged,
    required this.onLocaleChanged,
  });

  final ThemeMode themeMode;
  final VoidCallback onThemeChanged;
  final VoidCallback onLocaleChanged;

  @override
  Widget build(BuildContext context) {
    final reducedMotion = MediaQuery.disableAnimationsOf(context);
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: _Atmosphere()),
          const Positioned.fill(child: _ResponsiveHeroImage()),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final wide = constraints.maxWidth >= 760;
                final horizontal = wide ? 64.0 : 24.0;
                return SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(horizontal, 20, horizontal, 28),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - 48,
                      maxWidth: 1180,
                    ),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _TopBar(
                            themeMode: themeMode,
                            onThemeChanged: onThemeChanged,
                            onLocaleChanged: onLocaleChanged,
                          ),
                          SizedBox(height: wide ? 92 : 54),
                          if (wide)
                            Row(
                              children: [
                                const Expanded(flex: 11, child: SizedBox()),
                                const SizedBox(width: 54),
                                Expanded(
                                  flex: 9,
                                  child: _HeroCopy(
                                    onContact: () => showHugoPhone(context),
                                  ),
                                ),
                              ],
                            )
                          else ...[
                            _HeroCopy(onContact: () => showHugoPhone(context)),
                            const SizedBox(height: 54),
                            const _MobilePortrait(),
                          ],
                          SizedBox(height: wide ? 76 : 52),
                          const _CapabilityRail(),
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
    ).animate(target: reducedMotion ? 0 : 1).fadeIn(duration: 500.ms);
  }
}

class _ResponsiveHeroImage extends StatelessWidget {
  const _ResponsiveHeroImage();

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      if (constraints.maxWidth < 760) return const SizedBox.shrink();
      return Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/hugo-hero.png',
            fit: BoxFit.cover,
            alignment: Alignment.centerLeft,
            filterQuality: FilterQuality.high,
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  context.portfolioColors.canvas.withValues(alpha: .88),
                  context.portfolioColors.canvas,
                ],
                stops: const [.28, .55, .76],
              ),
            ),
          ),
        ],
      );
    },
  );
}

class _MobilePortrait extends StatelessWidget {
  const _MobilePortrait();

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(24),
    child: AspectRatio(
      aspectRatio: 16 / 10,
      child: Image.asset(
        'assets/images/hugo-hero.png',
        fit: BoxFit.cover,
        alignment: Alignment.centerLeft,
        filterQuality: FilterQuality.high,
      ),
    ),
  );
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.themeMode,
    required this.onThemeChanged,
    required this.onLocaleChanged,
  });

  final ThemeMode themeMode;
  final VoidCallback onThemeChanged;
  final VoidCallback onLocaleChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
          children: [
            Container(
              width: 42,
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: context.portfolioColors.surface,
                borderRadius: BorderRadius.circular(13),
                border: Border.all(color: context.portfolioColors.stroke),
              ),
              child: const Text(
                'H',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
              ),
            ),
            const Spacer(),
            _HeaderButton(
              tooltip: AppStrings.of(context).themeTooltip,
              onPressed: onThemeChanged,
              child: AnimatedSwitcher(
                duration: 220.ms,
                child: Icon(
                  switch (themeMode) {
                    ThemeMode.system => Icons.brightness_auto_rounded,
                    ThemeMode.light => Icons.light_mode_rounded,
                    ThemeMode.dark => Icons.dark_mode_rounded,
                  },
                  key: ValueKey(themeMode),
                  size: 19,
                ),
              ),
            ),
            const SizedBox(width: 8),
            _HeaderButton(
              tooltip: AppStrings.of(context).languageTooltip,
              onPressed: onLocaleChanged,
              child: Text(
                Localizations.localeOf(context).languageCode == 'pt'
                    ? 'PT'
                    : 'EN',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        )
        .animate()
        .fadeIn(duration: 500.ms)
        .slideY(begin: -.25, end: 0, curve: Curves.easeOutCubic);
  }
}

class _HeaderButton extends StatelessWidget {
  const _HeaderButton({
    required this.tooltip,
    required this.onPressed,
    required this.child,
  });

  final String tooltip;
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) => Tooltip(
    message: tooltip,
    child: IconButton(
      onPressed: onPressed,
      style: IconButton.styleFrom(
        minimumSize: const Size.square(42),
        backgroundColor: context.portfolioColors.surface.withValues(alpha: .72),
        side: BorderSide(color: context.portfolioColors.stroke),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
      ),
      icon: child,
    ),
  );
}

class _HeroCopy extends StatelessWidget {
  const _HeroCopy({required this.onContact});

  final VoidCallback onContact;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final titleSize = width >= 900
        ? 70.0
        : width >= 400
        ? 54.0
        : 46.0;
    return Column(
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
            Expanded(
              child: Text(
                AppStrings.of(context).role,
                style: TextStyle(
                  color: context.portfolioColors.accent,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2.1,
                ),
              ),
            ),
          ],
        ).animate().fadeIn(delay: 180.ms).slideX(begin: -.08, end: 0),
        const SizedBox(height: 22),
        Text(
              'Hugo Henrique\nMartins.',
              style: TextStyle(
                fontSize: titleSize,
                height: .94,
                letterSpacing: -3.2,
                fontWeight: FontWeight.w700,
              ),
            )
            .animate()
            .fadeIn(delay: 260.ms, duration: 650.ms)
            .slideY(begin: .12, end: 0, curve: Curves.easeOutCubic),
        const SizedBox(height: 26),
        ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 570),
              child: Text(
                AppStrings.of(context).description,
                style: TextStyle(
                  color: context.portfolioColors.muted,
                  fontSize: 16,
                  height: 1.65,
                  letterSpacing: -.1,
                ),
              ),
            )
            .animate()
            .fadeIn(delay: 390.ms, duration: 600.ms)
            .slideY(begin: .12, end: 0),
        const SizedBox(height: 34),
        _ContactButton(onPressed: onContact)
            .animate()
            .fadeIn(delay: 520.ms, duration: 500.ms)
            .slideY(begin: .2, end: 0, curve: Curves.easeOutCubic),
      ],
    );
  }
}

class _ContactButton extends StatefulWidget {
  const _ContactButton({required this.onPressed});
  final VoidCallback onPressed;

  @override
  State<_ContactButton> createState() => _ContactButtonState();
}

class _ContactButtonState extends State<_ContactButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: AppStrings.of(context).contactSemantics,
      child: GestureDetector(
        onTap: widget.onPressed,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: (_) => setState(() => _pressed = false),
        child: AnimatedScale(
          scale: _pressed ? .97 : 1,
          duration: 120.ms,
          child: Container(
            padding: const EdgeInsets.fromLTRB(22, 17, 17, 17),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F0F7),
              borderRadius: BorderRadius.circular(17),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x309B8CFF),
                  blurRadius: 28,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppStrings.of(context).contact,
                  style: const TextStyle(
                    color: Color(0xFF111116),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 18),
                const Icon(
                  Icons.arrow_outward_rounded,
                  color: Color(0xFF111116),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CapabilityRail extends StatelessWidget {
  const _CapabilityRail();

  @override
  Widget build(BuildContext context) {
    final capabilities = AppStrings.of(context).capabilities;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      decoration: BoxDecoration(
        color: context.portfolioColors.surface.withValues(alpha: .56),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: context.portfolioColors.stroke.withValues(alpha: .72),
        ),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        runAlignment: WrapAlignment.center,
        spacing: 20,
        runSpacing: 13,
        children: [
          for (final capability in capabilities)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.add_rounded,
                  size: 13,
                  color: context.portfolioColors.accent,
                ),
                const SizedBox(width: 7),
                Text(
                  capability,
                  style: TextStyle(
                    color: context.portfolioColors.muted,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.25,
                  ),
                ),
              ],
            ),
        ],
      ),
    ).animate().fadeIn(delay: 700.ms, duration: 600.ms);
  }
}

class _Atmosphere extends StatelessWidget {
  const _Atmosphere();

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      gradient: RadialGradient(
        center: Alignment(.78, -.35),
        radius: 1.15,
        colors: [
          context.portfolioColors.accent.withValues(alpha: .12),
          Colors.transparent,
        ],
        stops: [0, .72],
      ),
    ),
    child: CustomPaint(painter: _GridPainter(context.portfolioColors.stroke)),
  );
}

class _GridPainter extends CustomPainter {
  const _GridPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: .13)
      ..strokeWidth = .5;
    const gap = 48.0;
    for (double x = 0; x < size.width; x += gap) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += gap) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter oldDelegate) =>
      oldDelegate.color != color;
}
