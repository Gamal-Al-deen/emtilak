import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Centralized responsive utilities and breakpoints for Emtilak app.
class Responsive {
  // Standard Breakpoints (in logical pixels)
  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 1024.0;
  static const double desktopBreakpoint = 1440.0;

  // Reference design device width for scaling typography & proportions
  static const double referenceWidth = 375.0;

  /// Returns true if the screen width is less than [mobileBreakpoint] (600px).
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobileBreakpoint;

  /// Returns true if the screen width is between 600px and 1024px.
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  /// Returns true if the screen width is between 1024px and 1440px.
  static bool isDesktop(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= tabletBreakpoint && width < desktopBreakpoint;
  }

  /// Returns true if the screen width is 1440px or larger.
  static bool isLargeDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= desktopBreakpoint;

  /// Returns true for any wide screen (Tablet or Desktop: width >= 600px).
  static bool isWide(BuildContext context) =>
      MediaQuery.of(context).size.width >= mobileBreakpoint;

  /// Get current screen width multiplied by [percentage] (0.0 to 1.0).
  static double getWidth(BuildContext context, {double percentage = 1.0}) =>
      MediaQuery.of(context).size.width * percentage;

  /// Get current screen height multiplied by [percentage] (0.0 to 1.0).
  static double getHeight(BuildContext context, {double percentage = 1.0}) =>
      MediaQuery.of(context).size.height * percentage;

  /// Adaptive typography: scales smoothly with screen size while safely clamping
  /// between 85% of base size (for very small devices) and 130% of base size (for ultra-wide 4K screens)
  /// so that text remains balanced, crisp, and readable everywhere.
  static double getFontSize(
    BuildContext context,
    double baseSize, {
    double minScale = 0.85,
    double maxScale = 1.30,
  }) {
    final width = MediaQuery.of(context).size.width;
    // On mobile, keep standard scale (1.0) so small screens are not altered
    if (width < mobileBreakpoint) {
      return baseSize;
    }
    // For wide screens, smooth scale with clamped bounds
    final scale = (width / referenceWidth).clamp(1.0, 1.35);
    final targetSize = baseSize * math.pow(scale, 0.5);
    return targetSize.clamp(baseSize * minScale, baseSize * maxScale);
  }

  /// Helper to get optimal grid cross axis count based on available width and item width
  static int getGridCrossAxisCount(
    BuildContext context, {
    double itemMinWidth = 280.0,
    int minColumns = 1,
    int maxColumns = 6,
  }) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobileBreakpoint) return minColumns;
    final count = (width / itemMinWidth).floor();
    return count.clamp(minColumns, maxColumns);
  }

  /// Helper to get responsive horizontal padding
  static double getHorizontalPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= desktopBreakpoint) return 32.0;
    if (width >= tabletBreakpoint) return 24.0;
    if (width >= mobileBreakpoint) return 20.0;
    return 16.0;
  }
}

/// A widget that builds different layouts depending on the screen size.
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context) mobile;
  final Widget Function(BuildContext context)? tablet;
  final Widget Function(BuildContext context)? desktop;
  final Widget Function(BuildContext context)? largeDesktop;

  const ResponsiveBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
    this.largeDesktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = MediaQuery.of(context).size.width;
        if (width >= Responsive.desktopBreakpoint && largeDesktop != null) {
          return largeDesktop!(context);
        }
        if (width >= Responsive.tabletBreakpoint && (desktop != null || tablet != null)) {
          return (desktop ?? tablet)!(context);
        }
        if (width >= Responsive.mobileBreakpoint && tablet != null) {
          return tablet!(context);
        }
        return mobile(context);
      },
    );
  }
}

/// A container that centers and constrains its child on wide displays.
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.maxWidth = 1200.0,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: padding ?? EdgeInsets.zero,
          child: child,
        ),
      ),
    );
  }
}

