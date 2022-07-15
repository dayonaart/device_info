import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:device_info/device_info_method_channel.dart';

void main() {
  MethodChannelDeviceInfo platform = MethodChannelDeviceInfo();
  const MethodChannel channel = MethodChannel('device_info');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getInformations', () async {
    expect(await platform.getDeviceInfo(), null);
  });
  test('getPublicIp', () async {
    expect(await platform.getPublicIp(), null);
  });
  test('getUUID', () async {
    expect(await platform.getUUID(), null);
  });
}
