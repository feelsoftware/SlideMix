import 'package:flutter/material.dart';

enum CreationMediaSource {
  camera, gallery
}

class CreationMediaSourceDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        children: <Widget>[
          ListTile(
            onTap: () {
              Navigator.pop(context, CreationMediaSource.camera);
            },
            leading: Icon(
              Icons.camera_alt,
              color: Theme.of(context).primaryColor,
            ),
            title: Text("Camera"),
          ),
          ListTile(
            onTap: () {
              Navigator.pop(context, CreationMediaSource.gallery);
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
