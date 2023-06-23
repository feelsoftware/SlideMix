import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:slidemix/colors.dart';
import 'package:slidemix/creator/slideshow_creator.dart';
import 'package:slidemix/extensions/device.dart';
import 'package:slidemix/localizations.dart';

class PickTransitionDialog extends StatelessWidget {
  static Future<SlideShowTransition?> show(
    BuildContext context,
    SlideShowTransition? selectedTransition,
  ) {
    return showModalBottomSheet<SlideShowTransition>(
      context: context,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height -
            // ignore: deprecated_member_use
            MediaQueryData.fromView(window).padding.top -
            64,
      ),
      builder: (_) => PickTransitionDialog._(selectedTransition),
    );
  }

  final SlideShowTransition? selectedTransition;

  const PickTransitionDialog._(this.selectedTransition);

  @override
  Widget build(BuildContext context) {
    const transitions = SlideShowTransition.values;

    return DraggableScrollableSheet(
      initialChildSize: 1,
      minChildSize: 0.99,
      maxChildSize: 1,
      builder: (context, controller) {
        return Scaffold(
          body: Column(
            children: [
              ListTile(
                title: MediaQuery(
                  data: const MediaQueryData(boldText: true),
                  child: Text(AppLocalizations.of(context).pickTransitionDialogTitle),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  controller: controller,
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: context.deviceType.isMobile ? 3 : 6,
                    childAspectRatio: 180 / 136,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemBuilder: (context, index) {
                    SlideShowTransition? transition;
                    if (index > 0) transition = transitions[index - 1];

                    return _TransitionItem(
                      transition: transition,
                      isSelected: transition == selectedTransition,
                    );
                  },
                  itemCount: transitions.length + 1,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TransitionItem extends StatelessWidget {
  final SlideShowTransition? transition;
  final bool isSelected;

  const _TransitionItem({
    required this.transition,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(transition),
      behavior: HitTestBehavior.opaque,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (transition == null)
            Text(
              AppLocalizations.of(context).transitionNone,
              textAlign: TextAlign.center,
            ),
          if (transition != null)
            Image.asset('assets/transitions/${transition!.name}.gif'),
          Container(
            decoration: isSelected
                ? BoxDecoration(
                    border: Border.all(color: AppColors.primary, width: 4),
                  )
                : null,
          )
        ],
      ),
    );
  }
}
