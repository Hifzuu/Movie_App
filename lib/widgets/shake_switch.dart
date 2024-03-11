import 'package:flutter/material.dart';
import 'package:movie_assignment/services/shake_detection_provider.dart';
import 'package:movie_assignment/services/shake_detector.dart';

class ShakeDetectionSwitch extends StatelessWidget {
  final ShakeDetectionProvider shakeDetectionProvider;

  const ShakeDetectionSwitch({Key? key, required this.shakeDetectionProvider})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Switch.adaptive(
      value: shakeDetectionProvider.isShakeDetectionEnabled,
      onChanged: (value) {
        shakeDetectionProvider.isShakeDetectionEnabled = value;

        // Enable or disable shake detection based on the user's choice
        if (value) {
          ShakeDetector.initialize();
          ShakeDetector.onShake = () {
            shakeDetectionProvider.handleShake(context);
          };
        } else {
          ShakeDetector.dispose();
        }
      },
    );
  }
}
