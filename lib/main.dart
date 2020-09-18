import 'package:flutter/material.dart';
import 'dart:io';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appName = 'Daniel Williams';

    return MaterialApp(
      title: appName,
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Lato',
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 80.0, fontWeight: FontWeight.bold),
        ),
      ),
      home: MyHomePage(
          title: appName
      ),
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

  void _aboutPage() {
    // When About Me button is pressed.
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called.

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: RaisedButton(
          child: Text('About',
            style: TextStyle(fontSize: 24)
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AboutRoute()
              ),
            );
          }
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}


class AboutRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About Me"),
        centerTitle: true,
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children:[
          SizedBox(
            height: 10.0,
          ),
          VerticalPadding(
            color: Colors.yellow[50],
            child: Text('Daniel Williams',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24),
            ),
          ),
          VerticalPadding(
            color: Colors.yellow[50],
            child: Text('Email: williams.dan@northeastern.edu',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
            ),
          ),
          VerticalPadding(
            color: Colors.yellow[50],
            child: Text('Starting Semester: ALIGN Spring 2019',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Image.asset('assets/images/corporate_daniel_williams.jpg',
              width: 300,
              height: 300
            ),
          ),
          SizedBox(
            height: 30.0,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: RaisedButton(
              child: Text('Generate Error'),
              onPressed: () => generateError(context))
            ),
        ],
      ),
    );
  }
}

class VerticalPadding extends StatelessWidget {
  // Colored faded padding for positioned items.

  VerticalPadding({
    @required this.child,
  this.padding = 16.0,
  this.color = Colors.white,
  });

  final double padding;
  final Widget child;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      padding: EdgeInsets.symmetric(vertical: padding),
    child: child,
    );
  }
}

void generateError(BuildContext context) {

  var alertDialog = AlertDialog(
    title: Text("Error Generated!"),
    content: Text("Shutting down app."),
    actions:[
      FlatButton(
        child: Text("Close now.",
          textAlign: TextAlign.center,
        ),
        onPressed: (){
          exit(0);
          // Navigator.of(context).pop();
        }
      )
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
       return alertDialog;
  });
}
