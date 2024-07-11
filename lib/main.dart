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
    MyHomePage(title: 'BLE Set Notification'),
    DataReceivingPage(),
    LoginPage(),
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
          BottomNavigationBarItem(
            icon: Icon(Icons.login),
            label: 'Login',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FlutterBluePlus blue = FlutterBluePlus.instance;

  @override
  void initState() {
    blue.scanResults.listen((results) {
      print("Searching11 ...");
      print("results : $results");
      if (results.isNotEmpty) {
        setState(() {
          result = results;
        });
      }
    });
    blue.connectedDevices.asStream().listen((List<BluetoothDevice> devices) {
      for (BluetoothDevice device in devices) {
        print("device : $device");
      }
    });
    super.initState();
  }

  List? result;
  bool check = false;
  String viewTxt = "Waiting...";

  Future blueBtn() async {
    setState(() {
      check = true;
      viewTxt = "Searching...";
    });
    var bl = await blue.startScan(
        scanMode: ScanMode.balanced,
        allowDuplicates: true,
        timeout: Duration(seconds: 12))
        .timeout(Duration(seconds: 12), onTimeout: () async {
      await blue.stopScan();
      setState(() {
        check = false;
        viewTxt = "ERR";
      });
    });
    print("startScan : $bl");

    await Future.delayed(Duration(seconds: 13), () async {
      await blue.stopScan();
      setState(() {
        check = false;
        if (this.result == null) viewTxt = "Waiting...";
      });
    });
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            ElevatedButton(
              child: Text("Search BLE Devices", style: TextStyle(color: Colors.black)),
              onPressed: this.blueBtn,
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
                color: check ? Colors.blue : Colors.red,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                result?.toString() ?? this.viewTxt,
                style: TextStyle(color: Colors.white),
              ),
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

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            child: Text('Login with BLE', style: TextStyle(color: Colors.black)),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    height: 200,
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.bluetooth, color: Colors.black),
                          title: Text('Connect via BLE', style: TextStyle(color: Colors.black)),
                          onTap: () {
                            // BLE 로그인 처리
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.cancel, color: Colors.black),
                          title: Text('Cancel', style: TextStyle(color: Colors.black)),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            style: ElevatedButton.styleFrom(
              minimumSize: Size(200, 60), // 버튼 크기
              backgroundColor: Colors.white, // 배경색
              foregroundColor: Colors.black, // 텍스트 색상
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30), // 둥근 모서리
              ),
            ),
          ),
        ),
      ),
    );
  }
}
