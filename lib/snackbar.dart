import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';

void showMySnackBar({
  required String msg,
  required AnimatedSnackBarType type,
  required BuildContext context,
}) {
  AnimatedSnackBar.material(msg, type: type).show(context);
}
