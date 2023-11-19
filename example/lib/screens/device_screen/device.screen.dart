import 'package:bluetooth_classic/models/device.dart';
import 'package:bluetooth_classic_example/providers/device.provider.dart';
import 'package:bluetooth_classic_example/repos/water_tracker.repo.dart';
import 'package:bluetooth_classic_example/services/user.service.dart';
import 'package:bluetooth_classic_example/utils/get_it.util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeviceScreen extends StatelessWidget {
  const DeviceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DeviceProvider>(
          builder: (BuildContext context, DeviceProvider deviceProvider, _) {
            deviceProvider.initialize();

            Widget connectToDevice() {
              return Center(
                child: SizedBox(
                  height: double.infinity,
                  child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 50),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: TextButton(
                              onPressed: () async {
                                await deviceProvider.bluetoothClassicPlugin.initPermissions();
                              },
                              child: const Text(
                                  "Check BT Permissions",
                                  style: TextStyle(
                                    color: Colors.black26
                                  ),
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: TextButton(
                            onPressed: () async {
                              SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                              print("REQUIRED WATER INTAKE FROM SHRAREDPREFERENCES: ${sharedPreferences.getString("required_water_intale")}");

                              await deviceProvider.getDevices();
                              deviceProvider.onShowDevicesPressed();
                            },
                            child: !deviceProvider.showDevices
                                ? const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                      "It seems you are not connected to a device.",
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                  ),

                                  SizedBox(height: 20,),

                                  Text(
                                      "Show Paired Devices",
                                      style: TextStyle(
                                        color: Colors.indigo,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18
                                      ),
                                  )
                                ],
                              )
                                : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
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

                                          await deviceProvider.bluetoothClassicPlugin.write("REQUIRED_WATER_INTAKE->2400MM");
                                        },
                                        child: Text(device.name ?? device.address))
                              ],
                            )
                          ),
                        ),
                      ],
                    ),
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
                            enabledBorder: OutlineInputBorder(),
                            label: Text("SSID"),
                            hintText: "DIGI_40efd",
                          ),

                          onChanged: (value) => deviceProvider.onSSIDChanged(value),
                        ),

                        const SizedBox(height: 20),

                        TextFormField(
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(),
                            label: Text("Password"),
                            hintText: "aebf00d",
                         ),

                          onChanged: (value) => deviceProvider.onPasswordChanged(value),
                        ),

                        const SizedBox(height: 20),

                        TextButton(
                            onPressed: () async => await deviceProvider.sendWifiCredentialsToDevice(),
                            child: const Text(
                                "connect device to wifi",
                              style: TextStyle(
                                color: Colors.indigo
                              ),
                            )
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
                      title: const Center(child: Text('Device Settings')),
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

                  Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Received data: ${String.fromCharCodes(deviceProvider.data)}")
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
