import 'dart:async';
import 'dart:io';
import 'package:cpmoviemaker/creation/creation_list.dart';
import 'package:cpmoviemaker/navigation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'creation_source_dialog.dart';

class CreationScreen extends StatefulWidget {
  @override
  _CreationState createState() => _CreationState();
}

class _CreationState extends State<CreationScreen>
    implements CreationListClickListener, MediaSourceClickListener {
  final List<File> _medias = List<File>();

  StreamSubscription<File> pickSubscription;

  @override
  void dispose() {
    super.dispose();
    pickSubscription?.cancel();
  }

  @override
  void addNewMedia() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return CreationMediaSourceDialog(this);
        });
  }

  @override
  void deleteMedia(int position) {
    _medias.removeAt(position);
    setState(() {});
  }

  @override
  void onCameraSourceClicked() {
    _pickImage(ImageSource.camera);
  }

  @override
  void onGallerySourceClicked() {
    _pickImage(ImageSource.gallery);
  }

  void _pickImage(ImageSource source) {
    pickSubscription =
        ImagePicker.pickImage(source: source).asStream().listen((file) {
      if (file != null) {
        _medias.add(file);
        setState(() {});
      }
    });
  }

  void _onCreateClicked(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            navigateBack(context);
          },
        ),
        title: Text("Select media"),
        centerTitle: false,
      ),
      body: CreationList(this, _medias),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _onCreateClicked(context);
        },
        tooltip: "Create a movie",
        child: Icon(
          Icons.play_arrow,
          color: Colors.white,
        ),
      ),
    );
  }
}
