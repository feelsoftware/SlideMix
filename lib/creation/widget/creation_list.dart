import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slidemix/creation/creation_bloc.dart';
import 'package:slidemix/creation/widget/creation_card.dart';
import 'package:slidemix/creation/data/media.dart';
import 'package:slidemix/extensions/device.dart';

class CreationList extends StatelessWidget {
  final List<Media> media;
  final VoidCallback onAddMedia;
  final Function(Media) onDeleteMedia;

  const CreationList(
    this.media, {
    super.key,
    required this.onAddMedia,
    required this.onDeleteMedia,
  });

  @override
  Widget build(BuildContext context) {
    const padding = 16.0;
    final spanCount = context.deviceType.isMobile ? 2 : 3;

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: spanCount,
        mainAxisSpacing: padding,
        crossAxisSpacing: padding,
      ),
      padding: const EdgeInsets.only(
        left: padding * 2,
        right: padding * 2,
        top: padding,
        bottom: padding * 6,
      ),
      itemCount: media.length + 1,
      itemBuilder: (BuildContext context, int index) {
        return index == 0
            ? AddMediaCardWidget(
                onTap: onAddMedia,
              )
            : MediaCreationCard(
                media[index - 1],
                onDeleteTap: (media) =>
                    BlocProvider.of<CreationBloc>(context).deleteMedia(media),
              );
      },
    );
  }
}
