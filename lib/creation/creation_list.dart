import 'dart:io';

import 'package:com_feelsoftware_slidemix/creation/creation_card.dart';
import 'package:flutter/material.dart';

abstract class CreationListClickListener {
  void addNewMedia();

  void deleteMedia(int position);
}

class CreationList extends StatelessWidget
    implements AddMediaClickListener, DeleteMediaClickListener {
  final CreationListClickListener _clickListener;
  final List<File> _medias;

  CreationList(this._clickListener, this._medias);

  @override
  void onAddNewMediaClicked() {
    _clickListener.addNewMedia();
  }

  @override
  void onMediaDeleteClicked(int position) {
    _clickListener.deleteMedia(position);
  }

  @override
  Widget build(BuildContext context) {
    final padding = 16.0;
    final spanCount = 2;

    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: spanCount,
          mainAxisSpacing: padding,
          crossAxisSpacing: padding,
        ),
        padding: EdgeInsets.only(
          left: padding * 2,
          right: padding * 2,
          top: padding,
          bottom: padding * 8,
        ),
        itemCount: _medias.length + 1,
        itemBuilder: (BuildContext context, int index) {
          return index == 0
              ? AddMediaCardWidget(this)
              : MediaCreationCard(this, _medias[index - 1], index - 1);
        });
  }
}
