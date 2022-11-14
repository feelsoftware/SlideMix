import 'package:flutter/material.dart';
import 'package:slidemix/localizations.dart';
import 'package:slidemix/widget/button.dart';

enum LeaveCreationResult {
  leave,
  keepAsDraft,
}

class LeaveCreationDialog extends StatelessWidget {
  static Future<LeaveCreationResult?> show(BuildContext context) async {
    return await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const LeaveCreationDialog._(),
    );
  }

  const LeaveCreationDialog._({Key? key}) : super(key: key);

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
                  AppLocalizations.of(context).leaveCreationAlertTitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SecondaryButton(
                    AppLocalizations.of(context).leaveCreationAlertSecondary,
                    onPressed: () {
                      Navigator.of(context).pop(LeaveCreationResult.leave);
                    },
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                  ),
                  const SizedBox(width: 16),
                  PrimaryButton(
                    AppLocalizations.of(context).leaveCreationAlertPrimary,
                    onPressed: () {
                      Navigator.of(context).pop(LeaveCreationResult.keepAsDraft);
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
