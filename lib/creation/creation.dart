// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slidemix/colors.dart';
import 'package:slidemix/creation/creation_bloc.dart';
import 'package:slidemix/creation/dialog/creation_settings_dialog.dart';
import 'package:slidemix/creation/dialog/pick_media_dialog.dart';
import 'package:slidemix/creation/dialog/creation_cancel_dialog.dart';
import 'package:slidemix/creation/dialog/creation_leave_dialog.dart';
import 'package:slidemix/creation/widget/creation_list.dart';
import 'package:slidemix/creation/widget/creation_loading.dart';
import 'package:slidemix/localizations.dart';
import 'package:slidemix/logger.dart';
import 'package:slidemix/movies/data/movie.dart';
import 'package:slidemix/navigation.dart';
import 'package:slidemix/preview/preview.dart';
import 'package:slidemix/widget/button.dart';
import 'package:slidemix/widget/toolbar.dart';

class CreationScreen extends StatefulWidget {
  static Route<void> route({
    Movie? draftMovie,
  }) =>
      MaterialPageRoute(
        settings: AppRouteSettings(
          routeName: 'creation',
          screenClass: CreationScreen,
        ),
        builder: (_) => CreationScreen._(draftMovie: draftMovie),
      );

  final Movie? draftMovie;

  const CreationScreen._({
    Key? key,
    this.draftMovie,
  }) : super(key: key);

  @override
  _CreationScreenState createState() => _CreationScreenState();
}

class _CreationScreenState extends State<CreationScreen> {
  bool _openPickerAtStartup = true;

  @override
  void initState() {
    super.initState();

    _openPickerAtStartup = widget.draftMovie == null;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_openPickerAtStartup) {
        setState(() => _openPickerAtStartup = false);
        _pickMedia();
      }
      if (widget.draftMovie != null) {
        BlocProvider.of<CreationBloc>(context).openDraft(widget.draftMovie!);
      }
    });
  }

  void _pickMedia() async {
    final files = await PickMediaDialog.show(context);
    if (!mounted || files.isEmpty) return;
    BlocProvider.of<CreationBloc>(context).pickFiles(files);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        LeaveCreationResult? leaveCreationResult;

        if (BlocProvider.of<CreationBloc>(context).state.isLoading) {
          if (await CancelCreationDialog.show(context) != CancelCreationResult.cancel) {
            return false;
          } else {
            leaveCreationResult = LeaveCreationResult.leave;
          }
        }
        if (!mounted) return false;

        if (leaveCreationResult == null &&
            BlocProvider.of<CreationBloc>(context).state.media.isNotEmpty) {
          // Ask if user wants to leave
          final result = await LeaveCreationDialog.show(context);
          if (result == null) {
            // Dismissed
            return false;
          }
          leaveCreationResult = result;
        } else {
          leaveCreationResult = LeaveCreationResult.leave;
        }
        if (!mounted) return false;

        final route = await BlocProvider.of<CreationBloc>(context).reset(
          deleteDraft: leaveCreationResult == LeaveCreationResult.leave,
        );
        if (!mounted) return false;
        Navigator.of(context).pushAndRemoveUntil(route, (_) => false);
        return false;
      },
      child: BlocBuilder<CreationBloc, CreationState>(
        builder: (context, state) {
          return Scaffold(
            appBar: Toolbar(
              leftIcon: const Icon(Icons.close),
              onLeftIconTapped: () => Navigator.of(context).maybePop(),
              rightIcon: const Icon(Icons.settings),
              onRightIconTapped: () => CreationSettingsDialog.show(context),
            ),
            body: Stack(
              children: <Widget>[
                CreationList(
                  state.media,
                  onAddMedia: () => _pickMedia(),
                  onDeleteMedia: (media) {
                    BlocProvider.of<CreationBloc>(context).deleteMedia(media);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: FractionallySizedBox(
                      widthFactor: 0.5,
                      child: PrimaryButton(
                        AppLocalizations.of(context).createMovie,
                        onPressed: () async {
                          Movie movie;
                          try {
                            movie = await BlocProvider.of<CreationBloc>(context)
                                .createMovie();
                          } catch (ex) {
                            if (!mounted) return;
                            final snackBar = SnackBar(
                              content: Text(ex.toString()),
                              backgroundColor: AppColors.error,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            return;
                          } finally {
                            if (mounted) CancelCreationDialog.dismiss(context);
                          }

                          if (!mounted) return;
                          Navigator.of(context).pushAndRemoveUntil(
                              PreviewScreen.route(movie), (_) => false);
                        },
                        isEnabled: state.isCreationAllowed,
                        onPressedButDisabled: () {
                          Logger.d('"create" pressed, but not enough media');
                          final snackBar = SnackBar(
                              content: Text(
                            AppLocalizations.of(context).notEnoughMediaToCreateMovie(
                                state.minMediaCountToProceed),
                          ));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        },
                        backgroundColor: AppColors.background,
                      ),
                    ),
                  ),
                ),
                if (state.isLoading)
                  CreationLoading(
                    loadingProgress: state.loadingProgress,
                    isInfiniteLoading: state.isInfiniteLoading,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
