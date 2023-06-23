import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:slidemix/creator/slideshow_orientation.dart';
import 'package:slidemix/localizations.dart';

class PickOrientationDialog extends StatelessWidget {
  static Future<SlideShowOrientation?> show(
    BuildContext context,
    SlideShowOrientation selectedOrientation,
  ) async {
    return showModalBottomSheet<SlideShowOrientation>(
      context: context,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height -
            // ignore: deprecated_member_use
            MediaQueryData.fromView(window).padding.top -
            64,
      ),
      builder: (_) => PickOrientationDialog._(selectedOrientation),
    );
  }

  final SlideShowOrientation selectedOrientation;

  const PickOrientationDialog._(this.selectedOrientation);

  @override
  Widget build(BuildContext context) {
    const orientations = SlideShowOrientation.values;

    return SafeArea(
      child: Wrap(
        children: <Widget>[
          ListTile(
            title: MediaQuery(
              data: const MediaQueryData(boldText: true),
              child: Text(AppLocalizations.of(context).pickOrientationDialogTitle),
            ),
          ),
          ...orientations.map((orientation) => _OrientationItem(
                orientation: orientation,
                isSelected: orientation == selectedOrientation,
              )),
        ],
      ),
    );
  }
}

class _OrientationItem extends StatelessWidget {
  final SlideShowOrientation orientation;
  final bool isSelected;

  const _OrientationItem({
    required this.orientation,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      selected: isSelected,
      onTap: () => Navigator.pop(context, orientation),
      leading: Icon(
        orientation.icon,
        color: Theme.of(context).primaryColor,
      ),
      title: Text(AppLocalizations.of(context).orientationSelector(orientation.name)),
    );
  }
}

extension _SlideShowOrientationX on SlideShowOrientation {
  IconData get icon => switch (this) {
        SlideShowOrientation.landscape => Icons.stay_current_landscape,
        SlideShowOrientation.portrait => Icons.stay_current_portrait,
        SlideShowOrientation.square => Icons.crop_square_rounded,
      };
}
