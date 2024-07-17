import 'dart:collection';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:async';

class CustomBluetoothService {
  CustomBluetoothService._privateConstructor();

  static final CustomBluetoothService _instance = CustomBluetoothService._privateConstructor();

  static CustomBluetoothService get instance => _instance;

  final FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  BluetoothDevice? _connectedDevice;
  BluetoothDeviceState _deviceState = BluetoothDeviceState.disconnected;
  Queue<Function> _readQueue = Queue();

  BluetoothDevice? get connectedDevice => _connectedDevice;
  BluetoothDeviceState get deviceState => _deviceState;

  Future<void> connectToDevice(ScanResult result) async {
    _connectedDevice = result.device;
    await _connectedDevice!.connect();
    _connectedDevice!.state.listen((state) {
      _deviceState = state;
    });
  }

  Future<void> disconnectFromDevice() async {
    if (_connectedDevice != null) {
      await _connectedDevice!.disconnect();
      _connectedDevice = null;
    }
  }

  Future<List<BluetoothService>> discoverServices() async {
    if (_connectedDevice != null) {
      return await _connectedDevice!.discoverServices();
    }
    return [];
  }

  Future<List<int>> readCharacteristic(BluetoothCharacteristic characteristic) async {
    final completer = Completer<List<int>>();
    _readQueue.add(() async {
      try {
        final result = await characteristic.read();
        completer.complete(result);
      } catch (e) {
        completer.completeError(e);
      } finally {
        _readQueue.removeFirst();
        if (_readQueue.isNotEmpty) {
          _readQueue.first();
        }
      }
    });

    if (_readQueue.length == 1) {
      _readQueue.first();
    }

    return completer.future;
  }

  Future<List<int>> readSDCardFileList(String serviceUuid, String characteristicUuid) async {
    if (_connectedDevice != null) {
      var services = await discoverServices();
      print('Discovered services: ${services.length}');
      for (var service in services) {
        print('Service found: ${service.uuid}');
        if (service.uuid.toString() == serviceUuid) {
          for (var characteristic in service.characteristics) {
            print('Characteristic found: ${characteristic.uuid}');
            if (characteristic.uuid.toString() == characteristicUuid) {
              return await readCharacteristic(characteristic);
            }
          }
        }
      }
    }
    throw Exception('Service or characteristic not found');
  }
}
