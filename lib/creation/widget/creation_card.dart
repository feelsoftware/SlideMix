import 'package:flutter/material.dart';
import 'package:slidemix/colors.dart';
import 'package:slidemix/creation/data/media.dart';
import 'package:slidemix/file_manager.dart';

class AddMediaCardWidget extends StatelessWidget {
  final VoidCallback onTap;

  const AddMediaCardWidget({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/ic_create_movie.png",
              width: 18,
              height: 18,
            ),
          ],
        ),
      ),
    );
  }
}

class MediaCreationCard extends StatelessWidget {
  final Media media;
  final Function(Media) onDeleteTap;

  const MediaCreationCard(
    this.media, {
    super.key,
    required this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[200],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: AspectRatio(
              aspectRatio: 1,
              child: Image.file(
                FileManager.of(context).getThumbFromDraftMedia(media),
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: GestureDetector(
            onTap: () => onDeleteTap(media),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Image.asset(
                "assets/images/ic_delete.png",
                width: 16,
                color: AppColors.background,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
