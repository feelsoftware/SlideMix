import 'dart:async';
import 'dart:io';
import 'package:cpmoviemaker/creation/creation_list.dart';
import 'package:cpmoviemaker/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'creation_source_dialog.dart';

const _CHANNEL = "com.vitoksmile.cpmoviemaker.CHANNEL";
const _METHOD_CREATE = "METHOD_CREATE";
const _METHOD_CANCEL = "METHOD_CANCEL";
const _METHOD_PROGRESS = "METHOD_PROGRESS";
const _METHOD_READY = "METHOD_READY";
const _METHOD_ERROR = "METHOD_ERROR";

class CreationScreen extends StatefulWidget {
  @override
  _CreationState createState() => _CreationState();
}

class _CreationState extends State<CreationScreen>
    implements CreationListClickListener, MediaSourceClickListener {
  final List<File> _medias = List<File>();

  StreamSubscription<File> pickSubscription;

  final _channel = MethodChannel(_CHANNEL);

  @override
  void initState() {
    super.initState();
    _channel.setMethodCallHandler(_onChannelReceived);
  }

  @override
  void dispose() {
    super.dispose();
    pickSubscription?.cancel();
    _channel.invokeMethod(_METHOD_CANCEL);
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

  void _onCreateClicked(BuildContext context) {
    if (_medias.length == 0) return;

    _channel
        .invokeMethod(
            _METHOD_CREATE,
            List.generate(_medias.length, (index) {
              return _medias[index].path;
            }))
        .asStream()
        .listen((data) {
      print(data);
    });
  }

  Future<dynamic> _onChannelReceived(MethodCall call) {
    if (call.method == _METHOD_PROGRESS) {
      final progress = call.arguments as int;
      print("Creation progress: $progress");
      // TODO: notify progress on UI
    } else if (call.method == _METHOD_READY) {
      final moviePath = call.arguments as String;
      print("Movie path: $moviePath");
      // TODO: show preview screen
    } else if (call.method == _METHOD_ERROR) {
      final message = call.arguments as String;
      print("Error: $message");
      // TODO: show error on UI
    }
    return null;
  }

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
