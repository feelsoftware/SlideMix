import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slidemix/colors.dart';
import 'package:slidemix/movies/data/movie.dart';
import 'package:slidemix/movies/movies.dart';
import 'package:slidemix/navigation.dart';
import 'package:slidemix/preview/preview_bloc.dart';
import 'package:slidemix/preview/widget/preview_player.dart';
import 'package:slidemix/widget/toolbar.dart';

class PreviewScreen extends StatefulWidget {
  static Route<void> route(Movie movie) => ScreenRoute(PreviewScreen._(movie));

  final Movie movie;

  const PreviewScreen._(
    this.movie, {
    Key? key,
  }) : super(key: key);

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushAndRemoveUntil(MoviesScreen.route(), (_) => false);
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.playerBackground,
        appBar: Toolbar(
          leftIcon: Image.asset("assets/images/ic_back.png"),
          onLeftIconTapped: () => Navigator.of(context).maybePop(),
          rightIcon: Image.asset(
            "assets/images/ic_delete_movie.png",
            color: AppColors.error,
          ),
          onRightIconTapped: () async {
            // TODO: add confirmation dialog
            final route =
                await BlocProvider.of<PreviewBloc>(context).delete(widget.movie);
            if (!mounted) return;
            Navigator.of(context).pushAndRemoveUntil(route, (route) => false);
          },
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: PreviewPlayer(widget.movie),
        ),
      ),
    );
  }
}
