import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'back_handler_method_channel.dart';

abstract class BackHandlerPlatform extends PlatformInterface {
  /// Constructs a BackHandlerPlatform.
  BackHandlerPlatform() : super(token: _token);

  static final Object _token = Object();

  static BackHandlerPlatform _instance = MethodChannelBackHandler();

  /// The default instance of [BackHandlerPlatform] to use.
  ///
  /// Defaults to [MethodChannelBackHandler].
  static BackHandlerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [BackHandlerPlatform] when
  /// they register themselves.
  static set instance(BackHandlerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
