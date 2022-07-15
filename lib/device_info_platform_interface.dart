import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'device_info_method_channel.dart';

abstract class DeviceInfoPlatform extends PlatformInterface {
  /// Constructs a DeviceInfoPlatform.
  DeviceInfoPlatform() : super(token: _token);

  static final Object _token = Object();

  static DeviceInfoPlatform _instance = MethodChannelDeviceInfo();

  /// The default instance of [DeviceInfoPlatform] to use.
  ///
  /// Defaults to [MethodChannelDeviceInfo].
  static DeviceInfoPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [DeviceInfoPlatform] when
  /// they register themselves.
  static set instance(DeviceInfoPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<DevicesInfoModel?> getDeviceInfo() {
    throw UnimplementedError('getProperties() not inplement');
  }

  Future<String?> getPublicIp() {
    throw UnimplementedError('getPublicIp() not inplement');
  }

  Future<String> getUUID() {
    throw UnimplementedError('getPublicIp() not inplement');
  }
}
