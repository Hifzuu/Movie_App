import 'dart:async';

import 'package:sensors_plus/sensors_plus.dart';
import 'package:rxdart/rxdart.dart';

class ShakeDetector {
  static const double shakeThreshold = 15.0;
  static DateTime? lastShakeTime;
  static Function()? onShake;
  static StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;

  static const Duration cooldownDuration = Duration(seconds: 2);

  static void initialize() {
    _accelerometerSubscription = accelerometerEventStream()
        .throttleTime(const Duration(milliseconds: 500))
        .listen((AccelerometerEvent event) {
      double x = event.x;
      double y = event.y;
      double z = event.z;

      double acceleration = x * x + y * y + z * z;

      //print('ShakeDetector - Acceleration: $acceleration');

      if (acceleration > shakeThreshold * shakeThreshold) {
        //print('ShakeDetector - Shake detected!');

        // Check cooldown period
        if (lastShakeTime == null ||
            DateTime.now().difference(lastShakeTime!) > cooldownDuration) {
          // Execute shake action
          onShake?.call();

          // Update last shake time
          lastShakeTime = DateTime.now();
        }
      }
    });
  }

  static void dispose() {
    // Clean up resources related to shake detection
    _accelerometerSubscription?.cancel();
  }
}
