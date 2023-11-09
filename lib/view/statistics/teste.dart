import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../../common/colo_extension.dart';

class StatisticsView extends StatefulWidget {
  const StatisticsView({super.key});

  @override
  State<StatisticsView> createState() => _StatisticsViewState();
}

class _StatisticsViewState extends State<StatisticsView> {
  @override
  void initState() {
    super.initState();
  }

  List<BluetoothDevice> devicesList = [];
  List<String> debugConsole = [];
  List<BluetoothService> selectedDeviceServices = [];
  BluetoothCharacteristic? selectedCharacteristic;

  void startScanning() {
    FlutterBluePlus.startScan(timeout: Duration(seconds: 4));

    FlutterBluePlus.scanResults.listen((scanResult) {
      for (ScanResult result in scanResult) {
        if (!devicesList.contains(result.device)) {
          setState(() {
            devicesList.add(result.device);
          });
        }
      }
    });    // Display a dialog to select a device
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Selecione seu dispositivo'),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.6,
            child: ListView.builder(
              itemCount: devicesList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(devicesList[index].platformName),
                  subtitle: Text(devicesList[index].remoteId.toString()),
                  onTap: () {
                    _connectToDevice(devicesList[index]);
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _connectToDevice(BluetoothDevice device) async {
    await device.connect();

    // Add debug output to the console
    addToDebugConsole("Connected to device: ${device.platformName}");

    // Once connected, automatically subscribe to the desired service and characteristic
    selectedDeviceServices = await device.discoverServices();
    for (BluetoothService service in selectedDeviceServices) {
      if (service.uuid.toString() == "0000180d-0000-1000-8000-00805f9b34fb") {
        BluetoothCharacteristic? characteristic = service.characteristics
            .firstWhere((char) =>
                char.uuid.toString() == "00002a37-0000-1000-8000-00805f9b34fb");

        if (characteristic != null) {
          setState(() {
            selectedCharacteristic = characteristic;
          });

          // Subscribe to the characteristic
          selectedCharacteristic!.setNotifyValue(true);
          selectedCharacteristic!.lastValueStream.listen((value) {
            // Handle characteristic value updates here
            addToDebugConsole('Received Characteristic Data: $value');
          });

          break; // Exit the loop after finding and setting the characteristic
        } else {
          addToDebugConsole('HRM Data characteristic not found.');
        }
      }
    }
  }

  void addToDebugConsole(String message) {
    setState(() {
      debugConsole.add(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.white,
        centerTitle: true,
        elevation: 0,
        title: Text(
          "Estatísticas",
          style: TextStyle(
              color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          height: media.width * 0.4,
          width: media.width * 0.9,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: TColor.primaryG),
              borderRadius: BorderRadius.circular(media.width * 0.075)),
          child: Stack(alignment: Alignment.center, children: [
            Image.asset(
              "assets/img/bg_dots.png",
              height: media.width * 0.4,
              width: double.maxFinite,
              fit: BoxFit.fitHeight,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset("assets/img/heart_statistics.png"),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'BPM',
                          style: TextStyle(
                            color: TColor.black,
                            fontSize: 24,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          '100',
                          style: TextStyle(
                            color: TColor
                                .black, // Personalize as propriedades de estilo conforme necessário.
                            fontSize: 40,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ]),
        ),
        SizedBox(
          height: media.width * 0.05,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: debugConsole.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(debugConsole[index]),
              );
            },
          ),
        ),
      ])),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          try {
            startScanning();
          } catch (e) {
            addToDebugConsole(e.toString());
          }
        },
        child: Icon(Icons.bluetooth),
      ),
    );
  }
}
