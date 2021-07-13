import 'package:com_feelsoftware_slidemix/colors.dart';
import 'package:com_feelsoftware_slidemix/entry_point/entry_point_viewmodel.dart';
import 'package:com_feelsoftware_slidemix/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class EntryPointScreen extends StatefulWidget {
  final EntryPointViewModel _viewModel;

  EntryPointScreen(this._viewModel);

  @override
  State<StatefulWidget> createState() => _EntryPointStateScreen(_viewModel);
}

class _EntryPointStateScreen extends State<EntryPointScreen> {
  final EntryPointViewModel viewModel;

  _EntryPointStateScreen(this.viewModel);

  @override
  void initState() {
    super.initState();
    viewModel.init();
    viewModel.addListener(() {
      if (viewModel.showWelcomeScreen) {
        navigateToWelcome(context);
      } else {
        navigateToMovies(context);
      }
    });
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }

  @override
  void dispose() {
    super.dispose();
    viewModel.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
        color: Colors.white,
      );
}
