// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_android/image_picker_android.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:slidemix/localizations.dart';
import 'package:slidemix/logger.dart';
import 'package:slidemix/navigation.dart';

enum _MediaSource { camera, gallery }

class PickMediaDialog extends StatefulWidget {
  static Future<Iterable<File>> show(BuildContext context) async {
    final source = await showModalBottomSheet<_MediaSource>(
      context: context,
      routeSettings: AppRouteSettings(
        routeName: 'creation/pick',
        screenClass: PickMediaDialog,
      ),
      builder: (context) => const PickMediaDialog._(),
    );
    if (source == null || !context.mounted) return [];

    final imagePickerImpl = ImagePickerPlatform.instance;
    if (imagePickerImpl is ImagePickerAndroid) {
      // Handling MainActivity destruction
      final lostData = await imagePickerImpl.getLostData();
      if (lostData.files != null && lostData.files!.isNotEmpty) {
        return lostData.files!.map((file) => File(file.path));
      } else if (lostData.exception != null) {
        Logger.e('Failed to retrieve lost media', lostData.exception);
      }

      imagePickerImpl.useAndroidPhotoPicker = true;
    }

    switch (source) {
      case _MediaSource.camera:
        final image = await ImagePicker().pickImage(source: ImageSource.camera);
        if (!context.mounted || image == null) return [];
        return [File(image.path)];

      case _MediaSource.gallery:
        final images = await ImagePicker().pickMultiImage();
        if (!context.mounted || images.isEmpty) return [];
        return images.map((image) => File(image.path));
    }
  }

  const PickMediaDialog._();

  @override
  State<PickMediaDialog> createState() => _PickMediaDialogState();
}

class _PickMediaDialogState extends State<PickMediaDialog> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Wrap(
        children: <Widget>[
          ListTile(
            title: MediaQuery(
              data: const MediaQueryData(boldText: true),
              child: Text(AppLocalizations.of(context).pickMediaDialogTitle),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.pop(context, _MediaSource.camera);
            },
            leading: Icon(
              Icons.camera_alt,
              color: Theme.of(context).primaryColor,
            ),
            title: Text(AppLocalizations.of(context).mediaSourceCamera),
          ),
          ListTile(
            onTap: () {
              Navigator.pop(context, _MediaSource.gallery);
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
