import 'package:cpmoviemaker/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final VoidCallback? onPressedButDisabled;
  final bool isEnabled;

  PrimaryButton(this.text, this.onPressed,
      {this.isEnabled = true, this.onPressedButDisabled});

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
        borderRadius: BorderRadius.all(
          Radius.circular(8), //                 <--- border radius here
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
              color: isEnabled ? secondaryColor : disabledColor,
              fontSize: 16,
              fontFamily: "Metropolis",
            ),
          ),
        ),
      ),
    );
  }
}
