import 'dart:io';

import 'package:cpmoviemaker/creation/creation_card.dart';
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
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
        ),
        padding: EdgeInsets.all(16),
        itemCount: _medias.length + 1,
        itemBuilder: (BuildContext context, int index) {
          return index == 0
              ? AddMediaCard(this)
              : MediaCreationCard(this, _medias[index - 1], index - 1);
        });
  }
}
