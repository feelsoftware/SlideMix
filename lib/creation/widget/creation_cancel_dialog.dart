import 'package:flutter/material.dart';
import 'package:slidemix/navigation.dart';
import 'package:slidemix/widget/button.dart';

enum CancelCreationResult {
  dismiss,
  cancel,
}

class CancelCreationDialog extends StatelessWidget {
  static const RouteSettings _routeSettings = RouteSettings(
    name: 'creation/cancel',
  );

  static Future<CancelCreationResult?> show(BuildContext context) async {
    return await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      routeSettings: _routeSettings,
      builder: (_) => const CancelCreationDialog._(),
    );
  }

  static void dismiss(BuildContext context) {
    for (final route in NavigationStackObserver.stack) {
      if (route.settings.name == _routeSettings.name) {
        Navigator.of(context).removeRoute(route);
        return;
      }
    }
  }

  const CancelCreationDialog._({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Wrap(
        children: [
          Column(
            children: [
              // TODO: use localized string
              const Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Movie is in progress, do you want to cancel?',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: "Metropolis",
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SecondaryButton(
                    'wait',
                    onPressed: () {
                      Navigator.of(context).pop(CancelCreationResult.dismiss);
                    },
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                  ),
                  const SizedBox(width: 16),
                  PrimaryButton(
                    'cancel',
                    onPressed: () {
                      Navigator.of(context).pop(CancelCreationResult.cancel);
                    },
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ],
      ),
    );
  }
}
