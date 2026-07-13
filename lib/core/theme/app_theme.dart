import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

@immutable
class PortfolioColors extends ThemeExtension<PortfolioColors> {
  const PortfolioColors({
    required this.canvas,
    required this.surface,
    required this.stroke,
    required this.accent,
    required this.muted,
  });

  final Color canvas;
  final Color surface;
  final Color stroke;
  final Color accent;
  final Color muted;

  @override
  PortfolioColors copyWith({
    Color? canvas,
    Color? surface,
    Color? stroke,
    Color? accent,
    Color? muted,
  }) => PortfolioColors(
    canvas: canvas ?? this.canvas,
    surface: surface ?? this.surface,
    stroke: stroke ?? this.stroke,
    accent: accent ?? this.accent,
    muted: muted ?? this.muted,
  );

  @override
  PortfolioColors lerp(PortfolioColors? other, double t) {
    if (other == null) return this;
    return PortfolioColors(
      canvas: Color.lerp(canvas, other.canvas, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      stroke: Color.lerp(stroke, other.stroke, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
    );
  }
}

abstract final class AppTheme {
  static const darkColors = PortfolioColors(
    canvas: Color(0xFF08090B),
    surface: Color(0xFF111216),
    stroke: Color(0xFF27282E),
    accent: Color(0xFF9B8CFF),
    muted: Color(0xFF92939C),
  );

  static const lightColors = PortfolioColors(
    canvas: Color(0xFFF6F5F2),
    surface: Color(0xFFFFFFFF),
    stroke: Color(0xFFDEDDD8),
    accent: Color(0xFF6554D9),
    muted: Color(0xFF67666D),
  );

  static ThemeData get light => _build(
    brightness: Brightness.light,
    colors: lightColors,
    foreground: const Color(0xFF17171B),
  );

  static ThemeData get dark => _build(
    brightness: Brightness.dark,
    colors: darkColors,
    foreground: const Color(0xFFF4F3F7),
  );

  static ThemeData _build({
    required Brightness brightness,
    required PortfolioColors colors,
    required Color foreground,
  }) {
    final base = brightness == Brightness.dark
        ? ThemeData.dark()
        : ThemeData.light();
    final textTheme = GoogleFonts.interTextTheme(base.textTheme);
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: colors.canvas,
      colorScheme: ColorScheme.fromSeed(
        brightness: brightness,
        seedColor: colors.accent,
        primary: colors.accent,
        surface: colors.surface,
        onSurface: foreground,
      ),
      textTheme: textTheme.apply(
        bodyColor: foreground,
        displayColor: foreground,
      ),
      extensions: [colors],
    );
  }
}

extension PortfolioThemeX on BuildContext {
  PortfolioColors get portfolioColors =>
      Theme.of(this).extension<PortfolioColors>()!;
}
