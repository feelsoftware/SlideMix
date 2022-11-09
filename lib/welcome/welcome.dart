import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slidemix/colors.dart';
import 'package:slidemix/creation/creation.dart';
import 'package:slidemix/movies/movies.dart';
import 'package:slidemix/welcome/welcome_bloc.dart';
import 'package:slidemix/widget/button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _WelcomeStateScreen();
}

class _WelcomeStateScreen extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WelcomeBloc, WelcomeState>(
      builder: (context, state) {
        switch (state.runtimeType) {
          case ShowWelcomeState:
            return _build(context);

          case ShowMoviesState:
            return Builder(builder: (context) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pushReplacement(MoviesScreen.route());
              });
              return Container(color: AppColors.background);
            });

          default:
            return Container(color: AppColors.background);
        }
      },
    );
  }

  Widget _build(BuildContext context) {
    final logoSize = MediaQuery.of(context).size.width / 2;

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
            child: Image.asset(
              "assets/images/ic_logo_large.png",
              width: logoSize,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: FractionallySizedBox(
              heightFactor: 0.25,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: logoSize,
                    child: PrimaryButton(
                      "tap to start",
                      onPressed: () {
                        Navigator.of(context).push(CreationScreen.route());
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
