import 'package:flutter/material.dart';
import 'bluetooth_service.dart';

class DataReceivingPage extends StatefulWidget {
  @override
  _DataReceivingPageState createState() => _DataReceivingPageState();
}

class _DataReceivingPageState extends State<DataReceivingPage> {
  List<String> receivedData = [];

  @override
  void initState() {
    super.initState();
    // Mock data fetching function, replace with actual data fetching from the device
    fetchDataFromDevice();
  }

  void fetchDataFromDevice() {
    // Simulate fetching data from Bluetooth device
    setState(() {
      receivedData = ["Data 1", "Data 2", "Data 3"];
    });
  }

  void _addData() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newData = "";
        return AlertDialog(
          title: Text('Add Data', style: TextStyle(color: Colors.black)),
          content: TextField(
            onChanged: (value) {
              newData = value;
            },
            decoration: InputDecoration(hintText: "Enter data name"),
          ),
          actions: [
            ElevatedButton(
              child: Text('Add', style: TextStyle(color: Colors.black)),
              onPressed: () {
                setState(() {
                  receivedData.add(newData);
                });
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        );
      },
    );
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
      floatingActionButton: FloatingActionButton(
        onPressed: _addData,
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
