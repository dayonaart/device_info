import 'package:flutter_test/flutter_test.dart';
import 'package:device_info/device_info.dart';
import 'package:device_info/device_info_platform_interface.dart';
import 'package:device_info/device_info_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockDeviceInfoPlatform with MockPlatformInterfaceMixin implements DeviceInfoPlatform {
  @override
  Future<DevicesInfoModel?> getDeviceInfo() => Future.value(null);
  @override
  Future<String?> getPublicIp() => Future.value(null);
  @override
  Future<String> getUUID() => Future.value("");
}

void main() {
  final DeviceInfoPlatform initialPlatform = DeviceInfoPlatform.instance;
  DeviceInfo infoPlugin = DeviceInfo();
  MockDeviceInfoPlatform fakePlatform = MockDeviceInfoPlatform();
  DeviceInfoPlatform.instance = fakePlatform;
  test('$MethodChannelDeviceInfo is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelDeviceInfo>());
  });

  test('getInformations', () async {
    expect(await infoPlugin.getDeviceInfo(), null);
  });
  test('getPublicIp', () async {
    expect(await infoPlugin.getPublicIp(), null);
  });
  test('getUUID', () async {
    expect(await infoPlugin.getUUID(), null);
  });
}
