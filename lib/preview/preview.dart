import 'package:flutter/material.dart';
import 'package:slidemix/colors.dart';
import 'package:slidemix/movies/data/movie.dart';
import 'package:slidemix/movies/movies.dart';
import 'package:slidemix/navigation.dart';
import 'package:slidemix/preview/widget/preview_actions_dialog.dart';
import 'package:slidemix/preview/widget/preview_player.dart';
import 'package:slidemix/widget/toolbar.dart';

class PreviewScreen extends StatefulWidget {
  static Route<void> route(Movie movie) => MaterialPageRoute(
        settings: AppRouteSettings(
          routeName: 'preview',
          screenClass: PreviewScreen,
          arguments: {'id': movie.id},
        ),
        builder: (_) => PreviewScreen._(movie),
      );

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
          leftIcon: const Icon(
            Icons.close,
            color: AppColors.background,
          ),
          onLeftIconTapped: () => Navigator.of(context).maybePop(),
          rightIcon: const Icon(
            Icons.view_headline,
            color: AppColors.background,
          ),
          onRightIconTapped: () async {
            await PreviewActionsDialog.show(context, movie: widget.movie);
          },
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: PreviewPlayer(widget.movie),
          ),
        ),
      ),
    );
  }
}
