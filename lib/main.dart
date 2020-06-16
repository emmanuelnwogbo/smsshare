import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:share/share.dart';

class Alligator {
  String name;
  String description;

  Alligator({@required this.name, @required this.description});
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) _setTargetPlatformForDesktop();
  runApp(MyApp());
}

void _setTargetPlatformForDesktop() {
  TargetPlatform targetPlatform;
  if (Platform.isMacOS) {
    targetPlatform = TargetPlatform.iOS;
  } else if (Platform.isLinux || Platform.isWindows) {
    targetPlatform = TargetPlatform.android;
  }
  if (targetPlatform != null) {
    debugDefaultTargetPlatformOverride = targetPlatform;
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _controllerPeople, _controllerMessage;
  String _message, body;
  String _canSendSMSMessage = "Check is not run.";
  List<String> people = ['08033426880', '08157472838', '08121144100'];

  List<Alligator> alligators = [
    Alligator(
        name: "Crunchy", description: "A fierce Alligator with many teeth."),
    Alligator(name: "Munchy", description: "Has a big belly, eats a lot."),
    Alligator(
        name: "Grunchy", description: "Scaly Alligator that looks menacing."),
  ];

  Future<void> initPlatformState() async {
    _controllerPeople = TextEditingController();
    _controllerMessage = TextEditingController();
  }

  void _sendSMS(List<String> recipents) async {
    try {
      String _result = await sendSMS(
          message: 'hello there this is a test', recipients: recipents);
      setState(() => _message = _result);
    } catch (error) {
      setState(() => _message = error.toString());
    }
  }

  void _canSendSMS() async {
    bool _result = await canSendSMS();
    setState(() => _canSendSMSMessage =
        _result ? 'This unit can send SMS' : 'This unit cannot send SMS');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
              child: Column(
        children: <Widget>[
          SizedBox(height: 200),
          FlatButton(
              onPressed: () {
                _sendSMS(people);
              },
              child: Text('Send sms')),
          SizedBox(height: 20),
          FlatButton(
              onPressed: () {
                final RenderBox box = context.findRenderObject();
                Share.share('hello there, this is a test',
                    subject: 'alligator.description,',
                    sharePositionOrigin:
                        box.localToGlobal(Offset.zero) & box.size);
              },
              child: Text('Share')),
        ],
      ))), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
