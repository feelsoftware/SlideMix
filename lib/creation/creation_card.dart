import 'dart:io';

import 'package:com_feelsoftware_slidemix/colors.dart';
import 'package:flutter/material.dart';

abstract class CreationCard extends StatelessWidget {}

abstract class AddMediaClickListener {
  void onAddNewMediaClicked();
}

abstract class DeleteMediaClickListener {
  void onMediaDeleteClicked(int position);
}

class AddMediaCardWidget extends CreationCard {
  final AddMediaClickListener _clickListener;

  AddMediaCardWidget(this._clickListener);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _clickListener.onAddNewMediaClicked(),
      child: Container(
        decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            )),
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

class MediaCreationCard extends CreationCard {
  final DeleteMediaClickListener _clickListener;
  final File _file;
  final int _position;

  MediaCreationCard(this._clickListener, this._file, this._position);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: AspectRatio(
              aspectRatio: 1,
              child: Image.file(_file, fit: BoxFit.cover),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8),
          child: Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () {
                _clickListener.onMediaDeleteClicked(_position);
              },
              child: Image.asset(
                "assets/images/ic_remove_media.png",
                width: 16,
                height: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
