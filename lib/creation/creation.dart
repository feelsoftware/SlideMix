import 'package:cpmoviemaker/creation/creation_list.dart';
import 'package:cpmoviemaker/creation/creation_viewmodel.dart';
import 'package:cpmoviemaker/models/movie.dart';
import 'package:cpmoviemaker/navigation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'creation_source_dialog.dart';

class CreationScreen extends StatefulWidget {
  final CreationViewModel _viewModel;

  CreationScreen(this._viewModel);

  @override
  _CreationState createState() => _CreationState(_viewModel);
}

class _CreationState extends State<CreationScreen>
    implements CreationListClickListener {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final CreationViewModel _viewModel;

  _CreationState(this._viewModel);

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _viewModel.dispose();
  }

  @override
  Future addNewMedia() async {
    final CreationMediaSource source = await showModalBottomSheet(
      context: context,
      builder: (context) => CreationMediaSourceDialog(),
    );
    switch (source) {
      case CreationMediaSource.camera:
        _pickImage(ImageSource.camera);
        break;
      case CreationMediaSource.gallery:
        _pickImage(ImageSource.gallery);
        break;
    }
  }

  @override
  void deleteMedia(int position) {
    _viewModel.deleteMedia(position);
  }

  void _pickImage(ImageSource source) {
    _viewModel.launch(() => ImagePicker.pickImage(source: source), (file) {
      _viewModel.addMedia(file);
    });
  }

  void _createMovie() {
    _viewModel.launch(() => _viewModel.createMovie(), (Movie movie) {
      navigateToPreview(context, movie);
    }, onError: (String error) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(error)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
      body: Stack(
        children: <Widget>[
          CreationList(this, _viewModel.media),
          _viewModel.isLoading
              ? Container(
                  color: Colors.black12,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Container(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _createMovie();
        },
        tooltip: "Create a movie",
        child: Icon(
          Icons.play_arrow,
          color: Colors.white,
        ),
        backgroundColor: _viewModel.isCreationAllowed
            ? Theme.of(context).accentColor
            : Colors.grey,
      ),
    );
  }
}
