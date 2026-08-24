import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void configureEasyLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.circle
    ..maskType = EasyLoadingMaskType.none
    ..toastPosition = EasyLoadingToastPosition.center
    ..animationStyle = EasyLoadingAnimationStyle.opacity
    ..indicatorSize = 44
    ..radius = 6
    ..progressColor = Color(0xFF6055D8)
    ..backgroundColor = Color(0xFF6055D8)
    ..indicatorColor = Color(0xFF6055D8)
    ..textColor = Colors.white
    ..maskColor = Color(0xFF6055D8)
    ..userInteractions = true
    ..dismissOnTap = false;
}
