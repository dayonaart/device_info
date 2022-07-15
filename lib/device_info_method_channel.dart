import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'device_info_platform_interface.dart';

/// An implementation of [DeviceInfoPlatform] that uses method channels.
class MethodChannelDeviceInfo extends DeviceInfoPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('device_info');

  @override
  Future<DevicesInfoModel?> getDeviceInfo() async {
    try {
      final version = await methodChannel.invokeMethod<String>('getInformations');
      return DevicesInfoModel.fromJson(jsonDecode(version!));
    } catch (e) {
      return null;
    }
  }

  @override
  Future<String?> getPublicIp() async {
    try {
      final publicIp = await methodChannel.invokeMethod<String>('getPublicIp');
      return publicIp;
    } catch (e) {
      return "cannnot get public ip";
    }
  }

  @override
  Future<String> getUUID() async {
    try {
      final uuid = await methodChannel.invokeMethod<String>('getUUID');
      return uuid!;
    } catch (e) {
      return "cannnot get uuid";
    }
  }
}

class DevicesInfoModel {
  String? ipAddress;
  String? deviceType;
  String? osVersion;
  String? appVersionCode;
  String? buildVersionCode;
  String? uuid;
  DevicesInfoModel(
      {this.ipAddress,
      this.deviceType,
      this.osVersion,
      this.appVersionCode,
      this.buildVersionCode,
      this.uuid});

  factory DevicesInfoModel.fromJson(Map<String, dynamic> json) {
    return DevicesInfoModel(
        ipAddress: json['ip_address'] as String?,
        deviceType: json['device_type'] as String?,
        osVersion: json['os_version'] as String?,
        appVersionCode: json['app_version_code'] as String?,
        buildVersionCode: json['app_build_code'] as String?,
        uuid: json['uuid'] as String?);
  }

  Map<String, dynamic> toJson() => {
        'ip_address': ipAddress,
        'device_type': deviceType,
        'os_version': osVersion,
        'app_version_code': appVersionCode,
        'app_build_code': buildVersionCode,
        'uuid': uuid
      };
}
