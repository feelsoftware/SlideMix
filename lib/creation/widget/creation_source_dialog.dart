import 'package:flutter/material.dart';
import 'package:slidemix/localizations.dart';

enum CreationMediaSource { camera, gallery }

class PickMediaSourceDialog extends StatelessWidget {
  static Future<CreationMediaSource?> show(BuildContext context) =>
      showModalBottomSheet<CreationMediaSource>(
        context: context,
        builder: (context) => const PickMediaSourceDialog._(),
      );

  const PickMediaSourceDialog._({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
            title: Text(AppLocalizations.of(context).mediaSourceCamera),
          ),
          ListTile(
            onTap: () {
              Navigator.pop(context, CreationMediaSource.gallery);
            },
            leading: Icon(
              Icons.image,
              color: Theme.of(context).primaryColor,
            ),
            title: Text(AppLocalizations.of(context).mediaSourceGallery),
          ),
        ],
      ),
    );
  }
}
