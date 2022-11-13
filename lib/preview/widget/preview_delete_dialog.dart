import 'package:flutter/material.dart';
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
              // TODO: use localized string
              const Text(
                'Delete the video?',
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
                    'cancel',
                    onPressed: () {
                      Navigator.of(context).pop(DeletePreviewResult.cancel);
                    },
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                  ),
                  const SizedBox(width: 16),
                  PrimaryButton(
                    'delete',
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
