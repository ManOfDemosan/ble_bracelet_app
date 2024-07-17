import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class CustomBluetoothService {
  CustomBluetoothService._privateConstructor();

  static final CustomBluetoothService _instance = CustomBluetoothService._privateConstructor();

  static CustomBluetoothService get instance => _instance;

  final FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  BluetoothDevice? _connectedDevice;
  BluetoothDeviceState _deviceState = BluetoothDeviceState.disconnected;
  bool _isReadingCharacteristic = false; // 추가: 읽기 중복 방지 플래그

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
    if (_isReadingCharacteristic) {
      throw PlatformException(
        code: 'read_characteristic_error',
        message: 'Another read operation is already in progress',
      );
    }
    _isReadingCharacteristic = true; // 읽기 시작
    try {
      return await characteristic.read();
    } finally {
      _isReadingCharacteristic = false; // 읽기 완료
    }
  }
}
