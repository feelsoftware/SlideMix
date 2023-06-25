// ignore_for_file: use_build_context_synchronously

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slidemix/creation/creation_bloc.dart';
import 'package:slidemix/creation/dialog/pick_orientation_dialog.dart';
import 'package:slidemix/creation/dialog/pick_resize_dialog.dart';
import 'package:slidemix/creation/dialog/pick_transition_dialog.dart';
import 'package:slidemix/creation/dialog/set_duration_dialog.dart';
import 'package:slidemix/creator/slideshow_orientation.dart';
import 'package:slidemix/creator/slideshow_resize.dart';
import 'package:slidemix/creator/slideshow_transition.dart';
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
              _SlideDurationItem(settings.slideDuration),
              _TransitionItem(settings.transition),
              if (settings.transition != null)
                _TransitionDurationItem(settings.transitionDuration),
              _OrientationItem(settings.orientation),
              _ResizeItem(settings.resize),
            ],
          ),
        );
      },
    );
  }
}

class _SlideDurationItem extends StatelessWidget {
  final Duration duration;

  const _SlideDurationItem(this.duration);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () async {
        final newDuration = await SetDurationDialog.show(
          context,
          currentDuration: duration,
          formatter: (duration) => AppLocalizations.of(context).slideDurationSelector(
            AppLocalizations.of(context).formatDuration(duration),
          ),
        );
        if (!context.mounted || newDuration == null) return;
        BlocProvider.of<CreationBloc>(context).changeSlideDuration(newDuration);
      },
      title: Text(
        AppLocalizations.of(context).slideDurationSelector(
          AppLocalizations.of(context).formatDuration(duration),
        ),
      ),
    );
  }
}

class _TransitionItem extends StatelessWidget {
  final SlideShowTransition? transition;

  const _TransitionItem(this.transition);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () async {
        final newTransition = await PickTransitionDialog.show(context, transition);
        if (!context.mounted) return;
        BlocProvider.of<CreationBloc>(context).changeTransition(newTransition);
      },
      title: Text(
        AppLocalizations.of(context).changeCreationSettingsTransition(transition == null
            ? AppLocalizations.of(context).transitionNone
            : transition!.name),
      ),
    );
  }
}

class _TransitionDurationItem extends StatelessWidget {
  final Duration duration;

  const _TransitionDurationItem(this.duration);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () async {
        final newDuration = await SetDurationDialog.show(
          context,
          currentDuration: duration,
          formatter: (duration) =>
              AppLocalizations.of(context).transitionDurationSelector(
            AppLocalizations.of(context).formatDuration(duration),
          ),
        );
        if (!context.mounted || newDuration == null) return;
        BlocProvider.of<CreationBloc>(context).changeTransitionDuration(newDuration);
      },
      title: Text(
        AppLocalizations.of(context).transitionDurationSelector(
          AppLocalizations.of(context).formatDuration(duration),
        ),
      ),
    );
  }
}

class _OrientationItem extends StatelessWidget {
  final SlideShowOrientation orientation;

  const _OrientationItem(this.orientation);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () async {
        final newOrientation = await PickOrientationDialog.show(context, orientation);
        if (!context.mounted || newOrientation == null) return;
        BlocProvider.of<CreationBloc>(context).changeOrientation(newOrientation);
      },
      title: Text(
        AppLocalizations.of(context).changeCreationSettingsOrientation(
            AppLocalizations.of(context).orientationSelector(orientation.name)),
      ),
    );
  }
}

class _ResizeItem extends StatelessWidget {
  final SlideShowResize resize;

  const _ResizeItem(this.resize);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () async {
        final newResize = await PickResizeDialog.show(context, resize);
        if (!context.mounted || newResize == null) return;
        BlocProvider.of<CreationBloc>(context).changeResize(newResize);
      },
      title: Text(
        AppLocalizations.of(context).changeCreationSettingsResize(
            AppLocalizations.of(context).resizeSelector(resize.name)),
      ),
    );
  }
}
