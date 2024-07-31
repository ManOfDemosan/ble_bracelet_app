import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'custom_bluetooth_service.dart';

class DataReceivingPage extends StatefulWidget {
  @override
  _DataReceivingPageState createState() => _DataReceivingPageState();
}

class _DataReceivingPageState extends State<DataReceivingPage> {
  List<String> fileList = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchFileListFromSDCard();
  }

  Future<void> fetchFileListFromSDCard() async {
    try {
      String serviceUuid = '27655500-9de4-4e89-9229-3b654a53a965';
      String characteristicUuid = '27655700-9de4-4e89-9229-3b654a53a965';

      print('Attempting to read SD card file list...');
      List<int> sdCardData = await CustomBluetoothService.instance.readSDCardFileList(serviceUuid, characteristicUuid);

      if (sdCardData.isEmpty) {
        throw Exception('No data received from the device.');
      }

      String stringValue = String.fromCharCodes(sdCardData);
      print('Received data: $stringValue');

      // .DAT 파일만 필터링
      List<String> files = stringValue.split('\n').where((file) => file.endsWith('.DAT')).toList();

      setState(() {
        fileList.addAll(files);
        isLoading = false;
      });
    } catch (e) {
      print('Error reading SD card file list: $e');
      setState(() {
        errorMessage = 'Failed to read SD card file list. Please try again.';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SD Card File List'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(child: Text(errorMessage!, style: TextStyle(color: Colors.red)))
          : ListView.builder(
        itemCount: fileList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(fileList[index], style: TextStyle(color: Colors.black)),
          );
        },
      ),
    );
  }
}