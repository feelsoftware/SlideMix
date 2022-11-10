import 'dart:io';

import 'package:flutter/material.dart';
import 'package:slidemix/colors.dart';
import 'package:slidemix/movies/data/movie.dart';
import 'package:slidemix/movies/movies.dart';
import 'package:slidemix/navigation.dart';
import 'package:slidemix/preview/widget/preview_player.dart';
import 'package:slidemix/widget/toolbar.dart';
import 'package:video_player/video_player.dart';

class PreviewScreen extends StatelessWidget {
  static Route<void> route(Movie movie) => ScreenRoute(PreviewScreen._(movie));

  final Movie movie;

  const PreviewScreen._(this.movie, {Key? key}) : super(key: key);

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
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: PreviewPlayer(movie),
        ),
      ),
    );
  }
}
