import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const DeviceDetailExample());
}

class DeviceDetailExample extends StatelessWidget {
  const DeviceDetailExample({Key? key}) : super(key: key);

  void Function()? getDeviceInfo() {
    return () async {
      /// Initialize Plugin
      final devicePropertiesPlugin = DeviceInfo();
      try {
        /// get all devices info
        var deviceInfo = await devicePropertiesPlugin.getDeviceInfo();
        print("your devices info detail :\n${deviceInfo?.toJson()}");

        /// only get your public ip
        var ipPublic = await devicePropertiesPlugin.getPublicIp();
        print("your devices ip public detail :\n$ipPublic");

        // /// only get your device UUID
        var uuid = await devicePropertiesPlugin.getUUID();
        print("uuid device : $uuid");
      } on PlatformException {
        /// Handle Error
        return;
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(title: const Text("DeviceInfoExample")),
          body: Center(
            child:
                ElevatedButton(onPressed: getDeviceInfo(), child: const Text("Get devices Info")),
          )),
    );
  }
}
