import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'custom_bluetooth_service.dart';

class DataReceivingPage extends StatefulWidget {
  @override
  _DataReceivingPageState createState() => _DataReceivingPageState();
}

class _DataReceivingPageState extends State<DataReceivingPage> {
  List<String> receivedData = [];

  @override
  void initState() {
    super.initState();
    fetchDataFromDevice();
  }

  void fetchDataFromDevice() async {
    if (CustomBluetoothService.instance.connectedDevice != null) {
      List<BluetoothService> services = await CustomBluetoothService.instance.discoverServices();
      for (BluetoothService service in services) {
        for (BluetoothCharacteristic characteristic in service.characteristics) {
          try {
            List<int> value = await CustomBluetoothService.instance.readCharacteristic(characteristic);
            String stringValue = String.fromCharCodes(value);
            setState(() {
              receivedData.add(stringValue);
            });
          } catch (e) {
            print('Error reading characteristic: $e');
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Receiving Page'),
      ),
      body: ListView.builder(
        itemCount: receivedData.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(receivedData[index], style: TextStyle(color: Colors.black)),
          );
        },
      ),
    );
  }
}
