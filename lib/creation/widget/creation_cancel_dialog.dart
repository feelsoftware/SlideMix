import 'package:flutter/material.dart';
import 'package:slidemix/localizations.dart';
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
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  AppLocalizations.of(context).leaveCancelAlertTitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SecondaryButton(
                    AppLocalizations.of(context).leaveCancelAlertSecondary,
                    onPressed: () {
                      Navigator.of(context).pop(CancelCreationResult.dismiss);
                    },
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                  ),
                  const SizedBox(width: 16),
                  PrimaryButton(
                    AppLocalizations.of(context).leaveCancelAlertPrimary,
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
