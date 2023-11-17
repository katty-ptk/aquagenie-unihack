import 'package:bluetooth_classic/models/device.dart';
import 'package:bluetooth_classic_example/providers/device.provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeviceScreen extends StatelessWidget {
  const DeviceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DeviceProvider>(
          builder: (BuildContext context, DeviceProvider deviceProvider, _) {
            deviceProvider.initialize();

            Widget connectToDevice() {
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Device status is ${deviceProvider.deviceStatus}"),
                    TextButton(
                      onPressed: () async {
                        await deviceProvider.bluetoothClassicPlugin.initPermissions();
                      },
                      child: const Text("Check Permissions"),
                    ),
                    TextButton(
                      onPressed: () async => await deviceProvider.getDevices(),
                      child: const Text("Get Paired Devices"),
                    ),
                    TextButton(
                      onPressed: deviceProvider.deviceStatus == Device.connected
                          ? () async {
                        await deviceProvider.bluetoothClassicPlugin.disconnect();
                      }
                          : null,
                      child: const Text("disconnect"),
                    ),
                    TextButton(
                      onPressed: deviceProvider.deviceStatus == Device.connected
                          ? () async {
                        await deviceProvider.bluetoothClassicPlugin.write("ping");
                      }
                          : null,
                      child: const Text("send ping"),
                    ),
                    ...[
                      for (var device in deviceProvider.devices)
                        if ( device.name!.contains("esp".toUpperCase()) ||
                            device.address.contains("esp".toUpperCase()) )
                          TextButton(
                              onPressed: () async {
                                await deviceProvider.bluetoothClassicPlugin.connect(
                                    device.address,
                                    "00001101-0000-1000-8000-00805f9b34fb");

                                deviceProvider.discoveredDevices = [];
                                deviceProvider.devices = [];
                              },
                              child: Text(device.name ?? device.address))
                    ],
                    TextButton(
                      onPressed: deviceProvider.scan,
                      child: Text(deviceProvider.scanning ? "Stop Scan" : "Start Scan"),
                    ),
                    ...[
                      for (var device in deviceProvider.discoveredDevices)
                        Text(device.name ?? device.address)
                    ],
                    Text("Received data: ${String.fromCharCodes(deviceProvider.data)}"),
                  ],
                ),
              );
            }

            Widget wifiData() {
              return Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 3, color: Colors.greenAccent), //<-- SEE HERE
                            ),
                            label: Text("SSID"),
                            hintText: "DIGI_40efd",
                          ),

                          onChanged: (value) => deviceProvider.onSSIDChanged(value),
                        ),

                        SizedBox(height: 20),

                        TextFormField(
                          decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 3, color: Colors.greenAccent), //<-- SEE HERE
                          ),
                          label: Text("Password"),
                          hintText: "aebf00d",
                         ),

                          onChanged: (value) => deviceProvider.onPasswordChanged(value),
                        ),

                        SizedBox(height: 20),

                        TextButton(
                            onPressed: () async => await deviceProvider.sendWifiCredentialsToDevice(),
                            child: Text("connect to wifi")
                        )
                      ],
                ),
              );
            }

            Future<void> showSimpleDialog() async {
              await showDialog<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return SimpleDialog( // <-- SEE HERE
                      title: const Text('Device Settings'),
                      children: [wifiData()]
                    );
                  });
            }

            Widget deviceInfo() {
              return Stack(
                children: [
                  Positioned(
                    top: 50,
                    right: 30,
                    child: IconButton(
                        onPressed: () async => showSimpleDialog(),
                        icon: const Icon(Icons.settings)),
                  ),

                  const Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("device info")
                        ],
                      ),
                    ),
                  )
                ],
              );
            }

            return Scaffold(
              body: deviceProvider.deviceStatus != Device.connected
                  ? connectToDevice()
                  : deviceInfo()
            );
          }
    );
  }
}
