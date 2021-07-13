import 'dart:io';

import 'package:com_feelsoftware_slidemix/colors.dart';
import 'package:com_feelsoftware_slidemix/creation/creation_list.dart';
import 'package:com_feelsoftware_slidemix/creation/creation_viewmodel.dart';
import 'package:com_feelsoftware_slidemix/models/movie.dart';
import 'package:com_feelsoftware_slidemix/navigation.dart';
import 'package:com_feelsoftware_slidemix/widget/button.dart';
import 'package:com_feelsoftware_slidemix/widget/toolbar.dart';
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
    final CreationMediaSource? source = await showModalBottomSheet(
      context: context,
      builder: (context) => CreationMediaSourceDialog(),
    );
    // ignore: missing_enum_constant_in_switch
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
    // ignore: invalid_use_of_visible_for_testing_member
    _viewModel.launch(() => ImagePicker.platform.pickImage(source: source),
        (dynamic _file) {
      File file = File((_file as PickedFile).path);
      _viewModel.addMedia(file);
    });
  }

  void _createMovie() {
    _viewModel.launch(() => _viewModel.createMovie(), (Movie movie) {
      navigateToPreview(context, movie);
    }, onError: (String error) {
      // ignore: deprecated_member_use
      _scaffoldKey.currentState?.showSnackBar(SnackBar(content: Text(error)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          key: _scaffoldKey,
          appBar: Toolbar(
            leftIcon: Image.asset("assets/images/ic_back.png"),
            onLeftIconTapped: () => navigateBack(context),
          ),
          body: Stack(
            children: <Widget>[
              CreationList(this, _viewModel.media),
              Padding(
                padding: EdgeInsets.only(bottom: 64),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: FractionallySizedBox(
                    widthFactor: 0.45,
                    child: PrimaryButton(
                      "create",
                      () => _createMovie(),
                      isEnabled: _viewModel.isCreationAllowed,
                      onPressedButDisabled: () {
                        final minMediaCount = _viewModel.minMediaCount;
                        final snackBar = SnackBar(
                            content: Text(
                          'Add $minMediaCount or more media to create a movie',
                        ));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                      backgroundColor: AppColors.background,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        _viewModel.isLoading
            ? Container(
                color: AppColors.overlay,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : SizedBox.shrink(),
      ],
    );
  }
}
