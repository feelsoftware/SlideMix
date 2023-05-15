import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:slidemix/movies/data/movie.dart';

class PreviewShareDialog {
  static Future<void> show(
    BuildContext context,
    Movie movie,
  ) async {
    final box = context.findRenderObject() as RenderBox?;
    Share.shareXFiles(
      [
        XFile(
          movie.video,
          name: movie.title,
          mimeType: movie.mime,
        ),
      ],
      subject: movie.title,
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  }
}
