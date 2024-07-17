import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class CustomBluetoothService {
  CustomBluetoothService._privateConstructor();

  static final CustomBluetoothService _instance = CustomBluetoothService._privateConstructor();

  static CustomBluetoothService get instance => _instance;

  final FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  BluetoothDevice? _connectedDevice;
  BluetoothDeviceState _deviceState = BluetoothDeviceState.disconnected;

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
}
