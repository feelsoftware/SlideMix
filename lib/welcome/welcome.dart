import 'package:cpmoviemaker/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WelcomeStateScreen();
}

class _WelcomeStateScreen extends State<WelcomeScreen> {
  final double logoWidthFactor = 0.45;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: FractionallySizedBox(
              heightFactor: 0.5,
              child: Image.asset(
                "assets/images/bg_welcome.png",
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: FractionallySizedBox(
              widthFactor: logoWidthFactor,
              child: Image.asset("assets/images/ic_logo_large.png"),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: FractionallySizedBox(
              heightFactor: 0.25,
              child: Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * logoWidthFactor,
                    child: PrimaryButton("tap to start", () {}),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            ),
          )
        ],
      ),
    );
  }
}
