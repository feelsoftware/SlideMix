import 'package:com_feelsoftware_slidemix/colors.dart';
import 'package:com_feelsoftware_slidemix/preview/preview_player_button.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PreviewPlayer extends StatelessWidget {
  final VideoPlayerController? _controller;

  PreviewPlayer(this._controller);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: _controller!.value.aspectRatio,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          VideoPlayer(_controller!),
          PreviewPlayPauseButton(_controller),
          VideoProgressIndicator(
            _controller!,
            colors: VideoProgressColors(
              playedColor: AppColors.primary,
            ),
            allowScrubbing: true,
          ),
        ],
      ),
    );
  }
}
