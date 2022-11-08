import 'package:flutter/material.dart';
import 'package:slidemix/colors.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isEnabled;
  final VoidCallback? onPressedButDisabled;
  final Color backgroundColor;
  final Color borderColor;

  const PrimaryButton(
    this.text, {
    super.key,
    required this.onPressed,
    this.isEnabled = true,
    this.onPressedButDisabled,
    this.backgroundColor = Colors.transparent,
    this.borderColor = AppColors.border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(
          width: 2,
          color: borderColor,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      child: InkWell(
        onTap: () {
          if (isEnabled) {
            onPressed();
          } else {
            onPressedButDisabled?.call();
          }
        },
        child: Align(
          child: Text(
            text,
            style: TextStyle(
              color: isEnabled ? AppColors.secondary : AppColors.disabled,
              fontSize: 16,
              fontFamily: "Metropolis",
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
  final Color backgroundColor;
  final Color borderColor;

  const SecondaryButton(
    this.text,
    this.onPressed, {
    super.key,
    this.backgroundColor = Colors.transparent,
    this.borderColor = AppColors.border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(
          width: 2,
          color: borderColor,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      child: InkWell(
        onTap: onPressed,
        child: Align(
          child: Text(
            text,
            style: const TextStyle(
              color: AppColors.disabled,
              fontSize: 16,
              fontFamily: "Metropolis",
            ),
          ),
        ),
      ),
    );
  }
}
