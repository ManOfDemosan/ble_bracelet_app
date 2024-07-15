import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final title = 'BLE Set Notification';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(
          color: Color(0xFF4169E1), // 로얄 블루
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'Arial',
          ),
          centerTitle: true,
        ),
        textTheme: TextTheme(
          headlineLarge: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.black),
          bodyMedium: TextStyle(fontSize: 18.0, color: Colors.black),
        ),
      ),
      home: HomeScreen(title: title),
    );
  }
}

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static List<Widget> _pages = <Widget>[
    PairingPage(),
    DataReceivingPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.bluetooth),
            label: 'Pairing',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.data_usage),
            label: 'Data',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

class PairingPage extends StatefulWidget {
  @override
  _PairingPageState createState() => _PairingPageState();
}

class _PairingPageState extends State<PairingPage> {
  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  List<ScanResult> scanResultList = [];
  bool isScanning = false;

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
      flutterBlue.startScan(scanMode: ScanMode.balanced, allowDuplicates: true, timeout: Duration(seconds: 12));
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
          scanResultList = results;
        });
      }).onError((error) {
        print('Error during scan: $error');
        setState(() {
          isScanning = false;
        });
      });
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
    print('${r.device.name}');
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
              child: Text("Search BLE Devices", style: TextStyle(color: Colors.black)),
              onPressed: toggleState,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(200, 60), // 버튼 크기
                backgroundColor: Colors.white, // 배경색
                foregroundColor: Colors.black, // 텍스트 색상
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // 둥근 모서리
                ),
              ),
            ),
            SizedBox(height: 20.0), // 간격 추가
            Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: isScanning ? Colors.blue : Colors.red,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                scanResultList.isEmpty ? "Waiting..." : "Devices found: ${scanResultList.length}",
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 20.0),
            ListView.separated(
              shrinkWrap: true,
              itemCount: scanResultList.length,
              itemBuilder: (context, index) {
                return listItem(scanResultList[index]);
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DataReceivingPage extends StatefulWidget {
  @override
  _DataReceivingPageState createState() => _DataReceivingPageState();
}

class _DataReceivingPageState extends State<DataReceivingPage> {
  List<String> receivedData = ["Data 1", "Data 2", "Data 3"];

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
                backgroundColor: Colors.white, // 배경색
                foregroundColor: Colors.black, // 텍스트 색상
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // 둥근 모서리
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