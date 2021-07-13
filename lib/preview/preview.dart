import 'package:com_feelsoftware_slidemix/colors.dart';
import 'package:com_feelsoftware_slidemix/navigation.dart';
import 'package:com_feelsoftware_slidemix/preview/preview_player.dart';
import 'package:com_feelsoftware_slidemix/preview/preview_viewmodel.dart';
import 'package:com_feelsoftware_slidemix/widget/toolbar.dart';
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
      backgroundColor: AppColors.playerBackground,
      appBar: Toolbar(
        leftIcon: Image.asset("assets/images/ic_back.png"),
        onLeftIconTapped: () => navigateBack(context),
      ),
      body: _viewModel.isPlayerReady
          ? Padding(
              padding: EdgeInsets.only(top: 16),
              child: PreviewPlayer(_viewModel.controller),
            )
          : SizedBox.shrink(),
    );
  }
}
