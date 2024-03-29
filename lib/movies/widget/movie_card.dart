import 'package:slidemix/colors.dart';
import 'package:flutter/material.dart';
import 'package:slidemix/file_manager.dart';
import 'package:slidemix/localizations.dart';
import 'package:slidemix/movies/data/movie.dart';
import 'package:timeago/timeago.dart' as timeago;

class MovieCard extends StatelessWidget {
  final Movie movie;
  final Function(Movie) onTap;
  final Function(Movie) onToggleFavouriteTap;

  const MovieCard(
    this.movie, {
    required this.onTap,
    required this.onToggleFavouriteTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final fileManager = FileManager.of(context);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        const padding = 8.0;
        const radius = 8.0;
        final imageSize = constraints.maxWidth - padding * 2;

        return InkWell(
          onTap: () => onTap(movie),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 2,
                color: AppColors.border,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(radius)),
              color: movie.isDraft ? Colors.grey[200] : null,
            ),
            child: Column(
              children: <Widget>[
                const SizedBox(height: padding),
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(radius)),
                  child: movie.isDraft
                      ? ColorFiltered(
                          colorFilter: const ColorFilter.mode(
                            Colors.grey,
                            BlendMode.saturation,
                          ),
                          child: SizedBox(
                            width: imageSize,
                            height: imageSize,
                            child: Image.file(
                              fileManager.getThumb(movie),
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                            ),
                          ),
                        )
                      : SizedBox(
                          width: imageSize,
                          height: imageSize,
                          child: Image.file(
                            fileManager.getThumb(movie),
                            fit: BoxFit.fitWidth,
                            errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                          ),
                        ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: padding),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                movie.title,
                                style: const TextStyle(
                                  color: AppColors.secondary,
                                  fontSize: 12,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _formatDate(context),
                                style: const TextStyle(
                                  color: AppColors.border,
                                  fontSize: 8,
                                  fontWeight: FontWeight.w300,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        if (!movie.isDraft)
                          InkWell(
                            onTap: () => onToggleFavouriteTap(movie),
                            child: Icon(
                              movie.isFavourite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color:
                                  movie.isFavourite ? AppColors.primary : Colors.grey,
                              size: 24,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDate(BuildContext context) {
    return timeago.format(
      movie.createdAt,
      locale: Localizations.localeOf(context).languageCode,
    );
  }
}

class AddMovieCard extends StatelessWidget {
  final VoidCallback onTap;

  const AddMovieCard({
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/ic_create_movie.png",
              width: 18,
              height: 18,
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context).newMovie,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
