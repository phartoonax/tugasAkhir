import 'package:flutter/material.dart';
import 'package:backendless_sdk/backendless_sdk.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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
  String _status = 'Object is saving to the real time database...';
  String _savedValue = '...';
  late Map _savedTestObject;
  late IDataStore<Map> _testTableDataStore;
  late TextEditingController _controller;

  static const String SERVER_URL = "https://eu-api.backendless.com";
  static const String APPLICATION_ID = "A5B771C1-B135-1146-FFC2-204701E95500";
  static const String ANDROID_API_KEY = "0CCFCDB3-0974-43B5-BD23-61FA6745C4A3";
  static const String IOS_API_KEY = "140898C0-D6DC-459E-A62E-20FF3A644653";
  static const String JS_API_KEY = "D4EF9175-2546-4B17-9038-14A77F5186F5";

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    _controller = TextEditingController();

    await Backendless.initApp(
      applicationId: APPLICATION_ID,
      androidApiKey: ANDROID_API_KEY,
      iosApiKey: IOS_API_KEY,
      jsApiKey: JS_API_KEY,
    );
    await Backendless.setUrl(SERVER_URL);

    Map testObject = Map();
    testObject['foo'] = 'Hello World';
    _testTableDataStore = Backendless.data.of('TestTable');
    _testTableDataStore.save(testObject).then((response) {
      _savedTestObject = response!;
      _subscribeForObjectUpdate();
      setState(() {
        _status = 'Object has been saved in the real-time database';
        _savedValue = response['foo'];
      });
    });
  }

  void _subscribeForObjectUpdate() {
    _testTableDataStore.rt().addUpdateListener(
        (response) => setState(() => _savedValue = response['foo']),
        whereClause: "objectId='${_savedTestObject["objectId"]}'");
  }

  void _updateValue() {
    _savedTestObject['foo'] = _controller.text;
    _testTableDataStore.save(_savedTestObject).then((response) {
      print("Saved $response");
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Padding(
          padding: EdgeInsets.all(10),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '$_status',
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  'Live update object property:',
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  '$_savedValue',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                TextField(
                  decoration:
                      InputDecoration(hintText: 'Change property value'),
                  controller: _controller,
                ),
                ElevatedButton(
                  child: const Text('Update'),
                  onPressed: _updateValue,
                ),
              ],
            ),
          ),
        ));
  }
}
