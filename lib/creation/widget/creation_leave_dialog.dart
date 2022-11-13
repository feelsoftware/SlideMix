import 'package:flutter/material.dart';
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
              const SizedBox(height: 24),
              // TODO: use localized string
              const Text(
                'Leave the project?',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: "Metropolis",
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SecondaryButton(
                    'leave',
                    onPressed: () {
                      Navigator.of(context).pop(LeaveCreationResult.leave);
                    },
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                  ),
                  const SizedBox(width: 16),
                  PrimaryButton(
                    'save as draft',
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
