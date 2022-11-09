import 'package:flutter/material.dart';

enum CreationMediaSource { camera, gallery }

class PickMediaSourceDialog extends StatelessWidget {
  static Future<CreationMediaSource?> show(BuildContext context) =>
      showModalBottomSheet<CreationMediaSource>(
        context: context,
        builder: (context) => const PickMediaSourceDialog(),
      );

  const PickMediaSourceDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        ListTile(
          onTap: () {
            Navigator.pop(context, CreationMediaSource.camera);
          },
          leading: Icon(
            Icons.camera_alt,
            color: Theme.of(context).primaryColor,
          ),
          title: const Text("Camera"),
        ),
        ListTile(
          onTap: () {
            Navigator.pop(context, CreationMediaSource.gallery);
          },
          leading: Icon(
            Icons.image,
            color: Theme.of(context).primaryColor,
          ),
          title: const Text("Gallery"),
        ),
      ],
    );
  }
}
