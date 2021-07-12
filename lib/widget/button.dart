import 'package:cpmoviemaker/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  PrimaryButton(this.text, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
          color: borderColor,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(8), //                 <--- border radius here
        ),
      ),
      child: InkWell(
        onTap: onPressed,
        child: Align(
          child: Text(
            text,
            style: TextStyle(
              color: secondaryColor,
              fontSize: 16,
              fontFamily: "Metropolis",
            ),
          ),
        ),
      ),
    );
  }
}
