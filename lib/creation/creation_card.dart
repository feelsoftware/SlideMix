import 'dart:io';

import 'package:flutter/material.dart';

abstract class CreationCard extends StatelessWidget {}

abstract class AddMediaClickListener {
  void onAddNewMediaClicked();
}

abstract class DeleteMediaClickListener {
  void onMediaDeleteClicked(int position);
}

class AddMediaCard extends CreationCard {
  final AddMediaClickListener _clickListener;

  AddMediaCard(this._clickListener);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _clickListener.onAddNewMediaClicked();
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xffC4C4C4)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.add, color: Colors.black, size: 32),
            SizedBox(height: 8),
            Text(
              "Add\nnew media",
              style: TextStyle(fontSize: 14, fontFamily: "Roboto-Light"),
              textAlign: TextAlign.center,
            )
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
            border: Border.all(color: Colors.black, width: 0.1),
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
              child: Icon(
                Icons.delete_outline,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
