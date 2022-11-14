import 'package:flutter/material.dart';
import 'package:slidemix/localizations.dart';
import 'package:slidemix/widget/button.dart';

enum DeletePreviewResult {
  cancel,
  delete,
}

class DeletePreviewDialog extends StatelessWidget {
  static Future<DeletePreviewResult?> show(BuildContext context) async {
    return await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const DeletePreviewDialog._(),
    );
  }

  const DeletePreviewDialog._({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Wrap(
        children: [
          Column(
            children: [
              const SizedBox(height: 24),
              Text(
                AppLocalizations.of(context).deleteMovieAlertTitle,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SecondaryButton(
                    AppLocalizations.of(context).deleteMovieAlertSecondary,
                    onPressed: () {
                      Navigator.of(context).pop(DeletePreviewResult.cancel);
                    },
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                  ),
                  const SizedBox(width: 16),
                  PrimaryButton(
                    AppLocalizations.of(context).deleteMovieAlertPrimary,
                    onPressed: () {
                      Navigator.of(context).pop(DeletePreviewResult.delete);
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
