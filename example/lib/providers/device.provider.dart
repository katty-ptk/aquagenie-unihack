import 'dart:async';

import 'package:bluetooth_classic/bluetooth_classic.dart';
import 'package:bluetooth_classic/models/device.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

@Singleton()
class DeviceProvider extends ChangeNotifier {
  String platformVersion = 'Unknown';
  final BluetoothClassic bluetoothClassicPlugin = BluetoothClassic();
  List<Device> devices = [];
  List<Device> discoveredDevices = [];
  bool scanning = false;
  int deviceStatus = Device.disconnected;
  Uint8List data = Uint8List(0);

  StreamSubscription? subscription1, subscription2;

  bool showDevices = false;

  String ssidText = "";
  String passwordText = "";

  initialize() {
//    initPlatformState();

    subscription1 ??=
        bluetoothClassicPlugin.onDeviceStatusChanged().listen((event) {
      deviceStatus = event;
      notifyListeners();
      print('Subscription1 is here');
    });

    subscription2 ??=
        bluetoothClassicPlugin.onDeviceDataReceived().listen((event) {
      data = Uint8List.fromList([...data, ...event]);
      print("Data from subscription2: $data");
      notifyListeners();
    });
  }

  Future<void> initPlatformState() async {
    String platformVersion;

    try {
      platformVersion = await BluetoothClassic().getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    platformVersion = platformVersion;
    notifyListeners();
  }

  Future<void> getDevices() async {
    var res = await bluetoothClassicPlugin.getPairedDevices();
    devices = res;
    notifyListeners();
  }

  Future<void> scan() async {
    if (scanning) {
      await bluetoothClassicPlugin.stopScan();
      scanning = false;
    } else {
      await bluetoothClassicPlugin.startScan();
      bluetoothClassicPlugin.onDeviceDiscovered().listen(
        (event) {
          discoveredDevices = [...discoveredDevices, event];
        },
      );
      scanning = true;
    }

    notifyListeners();
  }

  onShowDevicesPressed() {
    showDevices = true;
    notifyListeners();
  }

  onSSIDChanged(String newSSID) {
    ssidText = newSSID;
    notifyListeners();
  }

  onPasswordChanged(String newPassword) {
    passwordText = newPassword;
    notifyListeners();
  }

  sendWifiCredentialsToDevice() async {
    print("sending SSID: ${ssidText} and password: ${passwordText} to device");
    await bluetoothClassicPlugin
        .write("SSID -> ${ssidText} \n PASSWORD -> ${passwordText} \n");
    notifyListeners();
  }
}
