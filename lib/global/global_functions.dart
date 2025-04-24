import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

class GlobalFunctions {
  static void beamToReplaceNamed(BuildContext context, String path) {
    context.beamToReplacementNamed(path);
  }

  static void beamToNamed(BuildContext context, String path) {
    context.beamToNamed(path);
  }
}
