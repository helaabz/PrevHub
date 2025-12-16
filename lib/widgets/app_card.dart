import 'package:flutter/material.dart';

enum CardVariant { default_, elevated, outlined }

class AppCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final CardVariant variant;
  final EdgeInsets? padding;
  final Color? backgroundColor;

  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.variant = CardVariant.default_,
    this.padding,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor = backgroundColor ?? Colors.white;
    List<BoxShadow>? shadows;
    Border? border;

    switch (variant) {
      case CardVariant.default_:
        shadows = [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ];
        border = Border.all(color: Colors.grey.shade100, width: 1);
        break;
      case CardVariant.elevated:
        shadows = [
          BoxShadow(
            color: const Color(0xFFFF4D3D).withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ];
        break;
      case CardVariant.outlined:
        border = Border.all(color: const Color(0xFFFFE8DC), width: 2);
        break;
    }

    Widget card = Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: border,
        boxShadow: shadows,
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: card,
      );
    }

    return card;
  }
}

