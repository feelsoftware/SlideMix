import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PreviewPlayPauseButton extends StatefulWidget {
  final VideoPlayerController controller;

  const PreviewPlayPauseButton(this.controller, {Key? key}) : super(key: key);

  @override
  State<PreviewPlayPauseButton> createState() => _PreviewPlayPauseButtonState();
}

class _PreviewPlayPauseButtonState extends State<PreviewPlayPauseButton> {
  late VideoPlayerController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller;
    controller.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 50),
          reverseDuration: const Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? const SizedBox.shrink()
              : Center(
                  child: Image.asset(
                    "assets/images/ic_preview_play.png",
                    width: 64,
                    height: 64,
                  ),
                ),
        ),
        GestureDetector(
          onTap: () async {
            if (!controller.value.isPlaying) {
              if (controller.value.position == controller.value.duration) {
                controller.seekTo(Duration.zero);
              }
            }
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
      ],
    );
  }
}
