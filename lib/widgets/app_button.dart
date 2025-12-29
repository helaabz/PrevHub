import 'package:flutter/material.dart';

enum ButtonVariant { primary, secondary, ghost, outline }
enum ButtonSize { sm, md, lg }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final ButtonSize size;
  final bool fullWidth;
  final Widget? icon;
  final bool isLoading;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.md,
    this.fullWidth = false,
    this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null || isLoading;

    Color backgroundColor;
    Color foregroundColor;
    Color? borderColor;

    switch (variant) {
      case ButtonVariant.primary:
        backgroundColor = const Color(0xFFE63900);
        foregroundColor = Colors.white;
        borderColor = null;
        break;
      case ButtonVariant.secondary:
        backgroundColor = const Color(0xFFFFE8DC);
        foregroundColor = const Color(0xFFFF4D3D);
        borderColor = null;
        break;
      case ButtonVariant.ghost:
        backgroundColor = Colors.transparent;
        foregroundColor = const Color(0xFF666666);
        borderColor = null;
        break;
      case ButtonVariant.outline:
        backgroundColor = Colors.transparent;
        foregroundColor = const Color(0xFFFF4D3D);
        borderColor = const Color(0xFFFF4D3D);
        break;
    }

    if (isDisabled) {
      backgroundColor = backgroundColor.withOpacity(0.5);
      foregroundColor = foregroundColor.withOpacity(0.5);
    }

    double horizontalPadding;
    double verticalPadding;
    double fontSize;

    switch (size) {
      case ButtonSize.sm:
        horizontalPadding = 16;
        verticalPadding = 8;
        fontSize = 14;
        break;
      case ButtonSize.md:
        horizontalPadding = 24;
        verticalPadding = 12;
        fontSize = 16;
        break;
      case ButtonSize.lg:
        horizontalPadding = 32;
        verticalPadding = 16;
        fontSize = 18;
        break;
    }

    Widget content = Row(
      mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading)
          SizedBox(
            width: fontSize,
            height: fontSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
            ),
          )
        else ...[
          if (icon != null) ...[
            icon!,
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                color: foregroundColor,
              ),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ],
    );

    Widget button = Container(
      width: fullWidth ? double.infinity : null,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: borderColor != null
            ? Border.all(color: borderColor, width: 2)
            : null,
        boxShadow: variant == ButtonVariant.primary && !isDisabled
            ? [
                BoxShadow(
                  color: const Color(0xFFFF4D3D).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: content,
    );

    return GestureDetector(
      onTap: isDisabled ? null : onPressed,
      child: AnimatedOpacity(
        opacity: isDisabled ? 0.5 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: button,
      ),
    );
  }
}

