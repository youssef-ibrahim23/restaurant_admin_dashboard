import 'package:flutter/material.dart';

/// Breakpoints used to switch between mobile and desktop layouts.
class AppBreakpoints {
  /// Width (logical pixels) at or above which the desktop layout is used.
  static const double desktop = 900;
}

/// Convenience helpers for responsive layouts.
extension ResponsiveContext on BuildContext {
  /// Whether the current screen is wide enough for the desktop layout.
  bool get isDesktop => MediaQuery.sizeOf(this).width >= AppBreakpoints.desktop;

  /// Whether the current screen should use the mobile layout.
  bool get isMobile => !isDesktop;

  /// Dialog width that fits the screen: ~90% of the width on mobile,
  /// otherwise the provided desktop width.
  double adaptiveDialogWidth(double desktopWidth) {
    if (isMobile) {
      return MediaQuery.sizeOf(this).width * 0.9;
    }
    return desktopWidth;
  }
}

/// Picks [desktop] or [mobile] based on the available width.
class AdaptiveView extends StatelessWidget {
  final Widget desktop;
  final Widget mobile;

  const AdaptiveView({
    super.key,
    required this.desktop,
    required this.mobile,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= AppBreakpoints.desktop) {
          return desktop;
        }
        return mobile;
      },
    );
  }
}
