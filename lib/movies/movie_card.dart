import 'dart:io';

import 'package:com_feelsoftware_slidemix/colors.dart';
import 'package:flutter/material.dart';

class MovieCardWidget extends StatelessWidget {
  final String? thumb;
  final String? title;

  MovieCardWidget(this.thumb, this.title);

  @override
  Widget build(BuildContext context) {
    final radius = 8.0;
    final borderRadius = Radius.circular(radius);

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: AppColors.border,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(8), //                 <--- border radius here
          ),
        ),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 8,
            ),
            ClipRRect(
              borderRadius: BorderRadius.all(borderRadius),
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Colors.grey,
                  BlendMode.saturation,
                ),
                child: Image.file(
                  File(thumb!),
                  fit: BoxFit.fitWidth,
                  width: constraints.maxWidth - 18,
                  height: constraints.maxWidth - 18,
                ),
              ),
            ),
            Container(
              width: constraints.maxWidth,
              height: constraints.maxHeight - constraints.maxWidth,
              padding: EdgeInsets.symmetric(horizontal: 8),
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title!,
                    style: TextStyle(
                      color: AppColors.secondary,
                      fontSize: 12,
                      fontFamily: "Metropolis",
                    ),
                  ),
                  // TODO: date isn't provided for now
                  // SizedBox(
                  //   height: 4,
                  // ),
                  // Text(
                  //   title!,
                  //   style: TextStyle(
                  //     color: borderColor,
                  //     fontSize: 10,
                  //     fontFamily: "Metropolis Bold",
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

class AddMovieCardWidget extends StatelessWidget {
  final VoidCallback onPressed;

  AddMovieCardWidget(this.onPressed);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/ic_create_movie.png",
              width: 18,
              height: 18,
            ),
            SizedBox(
              height: 24,
            ),
            Text(
              "add new",
              style: TextStyle(
                fontFamily: "Metropolis",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
