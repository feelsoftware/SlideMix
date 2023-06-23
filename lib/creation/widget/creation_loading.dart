import 'package:flutter/material.dart';
import 'package:slidemix/colors.dart';
import 'package:slidemix/localizations.dart';

class CreationLoading extends StatelessWidget {
  final int loadingProgress;
  final bool isInfiniteLoading;

  const CreationLoading({
    super.key,
    required this.loadingProgress,
    required this.isInfiniteLoading,
  });

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      color: AppColors.primary,
      fontSize: 16,
      fontWeight: FontWeight.bold,
      shadows: <Shadow>[
        Shadow(
          offset: Offset(1, 1),
          blurRadius: 1,
          color: Colors.black,
        ),
      ],
    );

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.overlay,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context).createMovieProgress,
            style: textStyle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Opacity(
            opacity: isInfiniteLoading ? 0.0 : 1.0,
            child: Text(
              "$loadingProgress%",
              style: textStyle,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
