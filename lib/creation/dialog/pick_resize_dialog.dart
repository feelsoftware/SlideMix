import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:slidemix/creator/slideshow_resize.dart';
import 'package:slidemix/localizations.dart';

class PickResizeDialog extends StatelessWidget {
  static Future<SlideShowResize?> show(
    BuildContext context,
    SlideShowResize selectedResize,
  ) async {
    return showModalBottomSheet<SlideShowResize>(
      context: context,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height -
            // ignore: deprecated_member_use
            MediaQueryData.fromView(window).padding.top -
            64,
      ),
      builder: (_) => PickResizeDialog._(selectedResize),
    );
  }

  final SlideShowResize selectedResize;

  const PickResizeDialog._(this.selectedResize);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Wrap(
        alignment: WrapAlignment.center,
        children: <Widget>[
          ListTile(
            title: MediaQuery(
              data: const MediaQueryData(boldText: true),
              child: Text(AppLocalizations.of(context).pickResizeDialogTitle),
            ),
          ),
          _ResizeItem(
            resize: SlideShowResize.contain,
            isSelected: SlideShowResize.contain == selectedResize,
          ),
          // SizedBox not working inside Wrap
          Container(height: 16),
          _ResizeItem(
            resize: SlideShowResize.cover,
            isSelected: SlideShowResize.cover == selectedResize,
          ),
          // ...SlideShowResize.values.map((resize) => _ResizeItem(
          //       resize: resize,
          //       isSelected: resize == selectedResize,
          //     )),
        ],
      ),
    );
  }
}

class _ResizeItem extends StatelessWidget {
  final SlideShowResize resize;
  final bool isSelected;

  const _ResizeItem({
    required this.resize,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(resize),
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: MediaQuery.sizeOf(context).width * 0.7,
        decoration: isSelected
            ? BoxDecoration(
                border: Border.all(color: Theme.of(context).primaryColor, width: 4),
              )
            : null,
        child: Column(
          children: [
            Image.asset('assets/images/resize_${resize.name}.webp'),
            Text(AppLocalizations.of(context).resizeSelector(resize.name)),
          ],
        ),
      ),
    );
  }
}
