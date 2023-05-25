import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slidemix/colors.dart';
import 'package:slidemix/creation/creation.dart';
import 'package:slidemix/localizations.dart';
import 'package:slidemix/movies/movies.dart';
import 'package:slidemix/navigation.dart';
import 'package:slidemix/welcome/welcome_bloc.dart';
import 'package:slidemix/widget/button.dart';

class WelcomeScreen extends StatefulWidget {
  static Route<void> route() => ScreenRoute(
        settings: const RouteSettings(name: 'welcome'),
        child: const WelcomeScreen(),
      );

  const WelcomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _WelcomeStateScreen();
}

class _WelcomeStateScreen extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<WelcomeBloc>(context).refresh();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WelcomeBloc, WelcomeState>(
      listener: (context, state) {
        if (state is ShowMoviesState) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            BlocProvider.of<WelcomeBloc>(context).reset();
            Navigator.of(context).pushReplacement(MoviesScreen.route());
          });
        }
      },
      builder: (context, state) {
        if (state is ShowWelcomeState) {
          return _build(context);
        }

        return Container(color: AppColors.background);
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
                      AppLocalizations.of(context).tapToStart,
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
