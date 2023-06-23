// ignore_for_file: use_build_context_synchronously

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slidemix/creation/creation_bloc.dart';
import 'package:slidemix/creation/dialog/pick_orientation_dialog.dart';
import 'package:slidemix/creation/dialog/pick_transition_dialog.dart';
import 'package:slidemix/localizations.dart';

class CreationSettingsDialog extends StatelessWidget {
  static Future<void> show(BuildContext context) async {
    await showModalBottomSheet<CreationSettings>(
      context: context,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height -
            // ignore: deprecated_member_use
            MediaQueryData.fromView(window).padding.top -
            64,
      ),
      builder: (_) => const CreationSettingsDialog._(),
    );
  }

  const CreationSettingsDialog._();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreationBloc, CreationState>(
      builder: (context, state) {
        final settings = state.settings;

        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                title: MediaQuery(
                  data: const MediaQueryData(boldText: true),
                  child: Text(
                    AppLocalizations.of(context).changeCreationSettingsDialogTitle,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  final transition =
                      await PickTransitionDialog.show(context, settings.transition);
                  if (!context.mounted) return;
                  BlocProvider.of<CreationBloc>(context).changeTransition(transition);
                },
                child: ListTile(
                  title: Text(
                    AppLocalizations.of(context).changeCreationSettingsTransition(
                        settings.transition == null
                            ? AppLocalizations.of(context).transitionNone
                            : settings.transition!.name),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  final orientation = await PickOrientationDialog.show(
                      context, state.settings.orientation);
                  if (!context.mounted || orientation == null) return;
                  BlocProvider.of<CreationBloc>(context).changeOrientation(orientation);
                },
                child: ListTile(
                  title: Text(
                    AppLocalizations.of(context).changeCreationSettingsOrientation(
                        AppLocalizations.of(context)
                            .orientationSelector(settings.orientation.name)),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
