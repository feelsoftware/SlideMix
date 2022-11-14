import 'package:flutter/material.dart';
import 'package:slidemix/colors.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isEnabled;
  final VoidCallback? onPressedButDisabled;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  final Color borderColor;

  const PrimaryButton(
    this.text, {
    super.key,
    required this.onPressed,
    this.isEnabled = true,
    this.onPressedButDisabled,
    this.padding = EdgeInsets.zero,
    this.backgroundColor = Colors.transparent,
    this.borderColor = AppColors.border,
  });

  @override
  Widget build(BuildContext context) {
    const borderRadius = BorderRadius.all(
      Radius.circular(8),
    );

    return InkWell(
      onTap: () {
        if (isEnabled) {
          onPressed();
        } else {
          onPressedButDisabled?.call();
        }
      },
      borderRadius: borderRadius,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(
            width: 2,
            color: borderColor,
          ),
          borderRadius: borderRadius,
        ),
        padding: padding,
        child: Align(
          child: Text(
            text,
            style: TextStyle(
              color: isEnabled ? AppColors.secondary : AppColors.disabled,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  final Color borderColor;

  const SecondaryButton(
    this.text, {
    super.key,
    required this.onPressed,
    this.padding = EdgeInsets.zero,
    this.backgroundColor = Colors.transparent,
    this.borderColor = AppColors.border,
  });

  @override
  Widget build(BuildContext context) {
    const borderRadius = BorderRadius.all(
      Radius.circular(8),
    );

    return InkWell(
      onTap: onPressed,
      borderRadius: borderRadius,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(
            width: 2,
            color: borderColor,
          ),
          borderRadius: borderRadius,
        ),
        padding: padding,
        child: Align(
          child: Text(
            text,
            style: const TextStyle(
              color: AppColors.disabled,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
