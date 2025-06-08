import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'back_handler_platform_interface.dart';

/// An implementation of [BackHandlerPlatform] that uses method channels.
class MethodChannelBackHandler extends BackHandlerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('back_handler');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }
}
