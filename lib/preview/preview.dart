import 'package:cpmoviemaker/navigation.dart';
import 'package:cpmoviemaker/preview/preview_player.dart';
import 'package:cpmoviemaker/preview/preview_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PreviewScreen extends StatefulWidget {
  final PreviewViewModel _viewModel;

  PreviewScreen(this._viewModel);

  @override
  _PreviewScreenState createState() => _PreviewScreenState(_viewModel);
}

class _PreviewScreenState extends State<PreviewScreen> {
  final PreviewViewModel _viewModel;

  _PreviewScreenState(this._viewModel);

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(() {
      setState(() {});
    });
    _viewModel.init();
  }

  @override
  void dispose() {
    super.dispose();
    _viewModel.dispose();
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
        title: Text(_viewModel.movie.title!),
        centerTitle: false,
      ),
      body: _viewModel.isPlayerReady
          ? PreviewPlayer(_viewModel.controller)
          : Container(),
    );
  }
}
