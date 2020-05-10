import 'package:cpmoviemaker/creation/creation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'models/movie.dart';

void navigateBack(BuildContext context) {
  if (Navigator.canPop(context)) {
    Navigator.pop(context);
  } else {
    SystemNavigator.pop();
  }
}

void navigateToCreation(BuildContext context) {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => CreationScreen()));
}

void navigateToPreview(BuildContext context, Movie movie) {}
