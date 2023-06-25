import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

class SetDurationDialog extends StatefulWidget {
  static Future<Duration?> show(
    BuildContext context, {
    required Duration currentDuration,
    required String Function(Duration) formatter,
  }) async {
    var newDuration = currentDuration;
    await showModalBottomSheet<Duration>(
      context: context,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height -
            // ignore: deprecated_member_use
            MediaQueryData.fromView(window).padding.top -
            64,
      ),
      builder: (_) => SetDurationDialog._(
        duration: currentDuration,
        formatter: formatter,
        onUpdate: (duration) => newDuration = duration,
      ),
    );
    return newDuration;
  }

  final Duration duration;
  final String Function(Duration) formatter;
  final Function(Duration) onUpdate;

  const SetDurationDialog._({
    required this.duration,
    required this.formatter,
    required this.onUpdate,
  });

  @override
  State<SetDurationDialog> createState() => _SetDurationDialogState();
}

class _SetDurationDialogState extends State<SetDurationDialog> {
  late Duration minDuration;
  late Duration maxDuration;
  late Duration duration;

  @override
  void initState() {
    super.initState();

    minDuration = const Duration(milliseconds: 500);
    maxDuration = const Duration(seconds: 10);
    duration = widget.duration;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Wrap(
        children: <Widget>[
          ListTile(
            title: MediaQuery(
              data: const MediaQueryData(boldText: true),
              child: Text(widget.formatter(duration)),
            ),
          ),
          Slider(
            value: duration.inMilliseconds.toDouble(),
            // min -> 0.5 s
            min: minDuration.inMilliseconds.toDouble(),
            // min -> 10 s
            max: maxDuration.inMilliseconds.toDouble(),
            divisions: maxDuration.inMilliseconds ~/ minDuration.inMilliseconds - 1,
            onChanged: (newValue) {
              setState(() => duration = Duration(milliseconds: newValue.toInt()));
              widget.onUpdate(duration);
            },
          ),
        ],
      ),
    );
  }
}
