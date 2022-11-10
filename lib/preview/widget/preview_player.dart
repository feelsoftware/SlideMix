import 'dart:io';

import 'package:flutter/material.dart';
import 'package:slidemix/colors.dart';
import 'package:slidemix/logger.dart';
import 'package:slidemix/movies/data/movie.dart';
import 'package:slidemix/preview/widget/preview_player_button.dart';
import 'package:video_player/video_player.dart';

class PreviewPlayer extends StatefulWidget {
  final Movie movie;

  const PreviewPlayer(
    this.movie, {
    Key? key,
  }) : super(key: key);

  @override
  State<PreviewPlayer> createState() => _PreviewPlayerState();
}

class _PreviewPlayerState extends State<PreviewPlayer> {
  VideoPlayerController? controller;

  @override
  void initState() {
    super.initState();

    controller = VideoPlayerController.file(
      File(widget.movie.video),
    )
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});

        // autoplay
        controller?.play();
      })
      ..addListener(() {
        if (controller?.value.hasError ?? false) {
          Logger.e(
            'Failed to play video',
            Exception(controller?.value.errorDescription),
          );
          const snackBar = SnackBar(
            content: Text('Failed to play video'),
            backgroundColor: AppColors.error,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          Navigator.of(context).maybePop();
        }
      });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !(controller?.value.isInitialized ?? false)) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Center(
      child: AspectRatio(
        aspectRatio: controller!.value.aspectRatio,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            VideoPlayer(controller!),
            PreviewPlayPauseButton(controller!),
            VideoProgressIndicator(
              controller!,
              colors: const VideoProgressColors(
                playedColor: AppColors.primary,
              ),
              allowScrubbing: true,
            ),
          ],
        ),
      ),
    );
  }
}
