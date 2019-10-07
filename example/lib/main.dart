import 'package:flutter/material.dart';

import 'package:collapsible_header/collapsible_header.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool _isClose = false;

  @override
  void initState() {

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
            body: CollapsibleHeader(
                headerColor: Colors.lightGreen,
                open: _isClose,
                headerContent: SizedBox(
                  height: 300,
                  child: Column(
                    children: <Widget>[
                      Expanded(child: MaterialButton(
                        color: Colors.blue,
                        child: Center(child: Text("Button 1"),),
                        onPressed: () {
                          print("Button 1 pressed!");
                        },
                      )),
                      Expanded(child: MaterialButton(
                        color: Colors.red,
                        child: Center(child: Text("Button 2"),),
                        onPressed: () {
                          print("Button 2 pressed!");
                        },
                      )),
                      Expanded(child: MaterialButton(
                        color: Colors.yellow,
                        child: Center(child: Text("Button 3"),),
                        onPressed: () {
                          print("Button 3 pressed!");
                        },
                      )),
                    ],
                  ),
                ),
                body: Container(
                  child: Center(
                    child: Text("This is anything you can imagine.")
                  ),
                ),
        )),
      ),
    );
  }
}
