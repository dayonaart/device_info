import 'package:device_info/device_info_method_channel.dart';

import 'device_info_platform_interface.dart';

class DeviceInfo {
  /// This method will return
  /// - Public IP device
  /// - Device model or brand
  /// - Device OS version
  /// - Your App version code
  /// - Your App build code
  Future<DevicesInfoModel?> getDeviceInfo() {
    return DeviceInfoPlatform.instance.getDeviceInfo();
  }

  /// This method will return
  /// - Your device Public IP
  Future<String?> getPublicIp() {
    return DeviceInfoPlatform.instance.getPublicIp();
  }

  Future<String> getUUID() {
    return DeviceInfoPlatform.instance.getUUID();
  }
}
