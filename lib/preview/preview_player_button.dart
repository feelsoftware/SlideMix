import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PreviewPlayPauseButton extends StatelessWidget {
  final VideoPlayerController? controller;

  PreviewPlayPauseButton(this.controller);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: Duration(milliseconds: 50),
          reverseDuration: Duration(milliseconds: 200),
          child: controller!.value.isPlaying
              ? SizedBox.shrink()
              : Center(
                  child: Icon(
                    Icons.play_circle_filled,
                    color: Theme.of(context).primaryColor,
                    size: 92,
                  ),
                ),
        ),
        GestureDetector(
          onTap: () {
            if (!controller!.value.isPlaying) {
              controller!.seekTo(Duration());
            }
            controller!.value.isPlaying ? controller!.pause() : controller!.play();
          },
        ),
      ],
    );
  }
}
