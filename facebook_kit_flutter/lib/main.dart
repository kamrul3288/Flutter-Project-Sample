import 'package:flutter/material.dart';
import 'package:flutter_account_kit/flutter_account_kit.dart';
import 'package:flutter/services.dart';
import 'dart:async';




void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Account Kit',
      theme: ThemeData(
        primaryColor: Colors.indigo
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  FlutterAccountKit akt = FlutterAccountKit();
  int _state = 0;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    initAccountkit();
  }

  //----------intial account kit----------------------
  Future<void> initAccountkit() async {
    bool initialized = false;
    try {
      //-------------set custom theme----------------
      final theme = AccountKitTheme(
          headerBackgroundColor: Colors.indigo,
          buttonBackgroundColor: Colors.indigo,
          buttonBorderColor: Colors.indigo,
          buttonTextColor: Colors.white);

      //---------configure kit-------------------
      await akt.configure(Config()
        ..facebookNotificationsEnabled = true
        ..receiveSMS = true
        ..readPhoneStateEnabled = true
        ..titleType = TitleType.appName
        ..theme = theme
      );
      initialized = true;
    } on PlatformException {
      print('Failed to initialize account kit');
    }

    if (!mounted) return; // if some error occurred then just return
    setState(() {
      _isInitialized = initialized;
      print("isInitialied $_isInitialized");
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('Facebook Account Kit'),
      ),
      body: new Center(

        //----------login button---------------
        child: RaisedButton(
          padding: EdgeInsets.all(16.0),
          color: _state == 2 ? Colors.green : Colors.indigo,
          child: buildButtonChild(),
          onPressed: _isInitialized ? this.login : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0)
          ),
        ),
      ),
    );
  }

  Widget buildButtonChild() {
    if (_state == 0) {
      return Text(
        'Login With Phone Number',
        style: TextStyle(color: Colors.white, fontSize: 16.0),
      );
    } else if (_state == 1) {
      return SizedBox(
          height: 24.0,
          width: 24.0,
          child: CircularProgressIndicator(
            value: null,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ));
    } else {
      return Icon(Icons.check, color: Colors.white);
    }
  }

  // observe login result
  Future<void> login() async {
    if (_state == 1) {
      return;
    }
    setState(() {
      _state = 1;
    });
    final result = await akt.logInWithPhone();
    if (result.status == LoginStatus.cancelledByUser) {
      print('Login cancelled by user');
      setState(() {
        _state = 0;
      });
    } else if (result.status == LoginStatus.error) {
      print('Login error');
      setState(() {
        _state = 0;
      });
    } else {
      print('Login success');
      setState(() {
        _state = 2;
      });
    }
  }
}





