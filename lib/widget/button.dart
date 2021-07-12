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
            color: Color(0xff9e9e9e),
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(8), //                 <--- border radius here
          )),
      child: InkWell(
          onTap: onPressed,
          child: Align(
            child: Text(
              text,
              style: TextStyle(
                  color: Color(0xffff5500),
                  fontSize: 16,
                  fontFamily: "Metropolis"),
            ),
          )),
    );
  }
}
