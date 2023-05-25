import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slidemix/colors.dart';
import 'package:slidemix/localizations.dart';
import 'package:slidemix/movies/data/movie.dart';
import 'package:slidemix/preview/preview_bloc.dart';
import 'package:slidemix/preview/widget/preview_delete_dialog.dart';
import 'package:slidemix/preview/widget/preview_share_dialog.dart';

class PreviewActionsDialog extends StatelessWidget {
  static Future<void> show(
    BuildContext context, {
    required Movie movie,
  }) =>
      showModalBottomSheet(
        context: context,
        routeSettings: const RouteSettings(
          name: 'preview/actions',
        ),
        builder: (context) => PreviewActionsDialog._(
          movie: movie,
        ),
      );

  final Movie movie;

  const PreviewActionsDialog._({
    Key? key,
    required this.movie,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Wrap(
        children: <Widget>[
          ListTile(
            onTap: () {
              PreviewShareDialog.show(context, movie);
            },
            leading: Image.asset(
              "assets/images/ic_share.png",
              width: 24,
              color: AppColors.secondary,
            ),
            title: Text(AppLocalizations.of(context).previewActionShare),
          ),
          ListTile(
            onTap: () async {
              final result = await DeletePreviewDialog.show(context, movie);
              if (result == null || result == DeletePreviewResult.cancel) {
                // Dismissed
                return;
              }
              // ignore: use_build_context_synchronously
              if (!context.mounted) return;

              final route = await BlocProvider.of<PreviewBloc>(context).delete(movie);
              // ignore: use_build_context_synchronously
              if (!context.mounted) return;
              Navigator.of(context).pushAndRemoveUntil(route, (_) => false);
            },
            leading: Image.asset(
              "assets/images/ic_delete.png",
              width: 24,
              color: AppColors.border,
            ),
            title: Text(AppLocalizations.of(context).previewActionDelete),
          ),
        ],
      ),
    );
  }
}
