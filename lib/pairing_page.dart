import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'custom_bluetooth_service.dart';

class PairingPage extends StatefulWidget {
  @override
  _PairingPageState createState() => _PairingPageState();
}

class _PairingPageState extends State<PairingPage> {
  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  List<ScanResult> scanResultList = [];
  bool isScanning = false;
  int naCount = 0;

  void toggleState() {
    setState(() {
      isScanning = !isScanning;
    });

    if (isScanning) {
      startScan();
    } else {
      flutterBlue.stopScan();
    }
  }

  void startScan() {
    try {
      flutterBlue.startScan(scanMode: ScanMode.balanced, allowDuplicates: true);
      scan();
    } catch (e) {
      print('Error starting scan: $e');
      setState(() {
        isScanning = false;
      });
    }
  }

  void scan() async {
    if (isScanning) {
      flutterBlue.scanResults.listen((results) {
        setState(() {
          scanResultList = results.where((r) => r.device.name.isNotEmpty || r.advertisementData.localName.isNotEmpty).toList();
          naCount = results.length - scanResultList.length;
        });
      }).onError((error) {
        print('Error during scan: $error');
        setState(() {
          isScanning = false;
        });
      });
    }
  }

  void connectToDevice(ScanResult r) async {
    try {
      await CustomBluetoothService.instance.connectToDevice(r);
      print('Connected to ${r.device.name}');
      discoverServices(r.device);
    } catch (e) {
      print('Error connecting to device: $e');
    }
  }

  void discoverServices(BluetoothDevice device) async {
    List<BluetoothService> services = await device.discoverServices();
    for (var service in services) {
      for (var characteristic in service.characteristics) {
        var value = await characteristic.read();
        print('Characteristic value: $value');
        setState(() {
          receivedData.add(String.fromCharCodes(value));
        });
      }
    }
  }

  Widget deviceSignal(ScanResult r) {
    return Text(r.rssi.toString());
  }

  Widget deviceMacAddress(ScanResult r) {
    return Text(r.device.id.id);
  }

  Widget deviceName(ScanResult r) {
    String name;
    if (r.device.name.isNotEmpty) {
      name = r.device.name;
    } else if (r.advertisementData.localName.isNotEmpty) {
      name = r.advertisementData.localName;
    } else {
      name = 'N/A';
    }
    return Text(name);
  }

  Widget leading(ScanResult r) {
    return CircleAvatar(
      backgroundColor: Colors.cyan,
      child: Icon(
        Icons.bluetooth,
        color: Colors.white,
      ),
    );
  }

  void onTap(ScanResult r) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Connect to Device'),
          content: Text('Do you want to connect to ${r.device.name}?'),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Connect'),
              onPressed: () {
                connectToDevice(r);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget listItem(ScanResult r) {
    return ListTile(
      onTap: () => onTap(r),
      leading: leading(r),
      title: deviceName(r),
      subtitle: deviceMacAddress(r),
      trailing: deviceSignal(r),
    );
  }

  List<String> receivedData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BLE Set Notification'),
      ),
      body: Center(
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            ElevatedButton(
              child: Text(isScanning ? "Stop" : "Search BLE Devices", style: TextStyle(color: Colors.black)),
              onPressed: toggleState,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(200, 60),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: isScanning ? Colors.blue : Colors.red,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                scanResultList.isEmpty
                    ? "Waiting..."
                    : "Devices found: ${scanResultList.length} (N/A Count: $naCount)",
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 20.0),
            ListView.separated(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: scanResultList.length,
              itemBuilder: (context, index) {
                return listItem(scanResultList[index]);
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider();
              },
            ),
            SizedBox(height: 20.0),
            ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: receivedData.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(receivedData[index]),
                );
              },
            ),
            SizedBox(height: 20.0),
            CustomBluetoothService.instance.connectedDevice != null
                ? Text(
              'Connected to ${CustomBluetoothService.instance.connectedDevice!.name} - State: ${CustomBluetoothService.instance.deviceState.toString().split('.')[1]}',
              style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
            )
                : Text(
              'No device connected',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
