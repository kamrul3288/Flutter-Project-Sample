import 'package:flutter/material.dart';
import 'shared_pref_helper.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shared preferences demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(title: 'Shared preferences demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final textController = TextEditingController();
  String _address = "";
  final helper = SharedPrefHelper();

  @override
  void initState() {
    super.initState();
    getDataFromSharedPref();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: textController,
              decoration: InputDecoration(
                labelText: "Your Address",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0)
                )
              ),
            ),

            SizedBox(height: 16.0,),

            RaisedButton(
              onPressed: (){
                setState((){
                  _address = textController.text;
                  helper.putValue("address", _address);

                });
              },
              color: Colors.red,
              child: Text("Save",style: TextStyle(color: Colors.white),),
            ),
            SizedBox(height: 16.0,),
            Text(_address)

          ],
        ),
      )
    );
  }

  void getDataFromSharedPref()async{
    String address = await helper.getValue("address");
    print(address);
    helper.getValue("address").then((value){
      setState(() {
        _address = value;
      });
    });
  }
}
