import 'package:flutter/material.dart';

abstract class MediaSourceClickListener {
  void onCameraSourceClicked();

  void onGallerySourceClicked();
}

class CreationMediaSourceDialog extends StatelessWidget {
  final MediaSourceClickListener _clickListener;

  CreationMediaSourceDialog(this._clickListener);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        children: <Widget>[
          ListTile(
            onTap: () {
              _clickListener.onCameraSourceClicked();
              Navigator.pop(context);
            },
            leading: Icon(
              Icons.camera_alt,
              color: Theme.of(context).primaryColor,
            ),
            title: Text("Camera"),
          ),
          ListTile(
            onTap: () {
              _clickListener.onGallerySourceClicked();
              Navigator.pop(context);
            },
            leading: Icon(
              Icons.image,
              color: Theme.of(context).primaryColor,
            ),
            title: Text("Gallery"),
          )
        ],
      ),
    );
  }
}
