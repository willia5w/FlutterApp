import 'dart:io';
import 'package:flutter/material.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class MessageHandler extends StatefulWidget {

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
//   @override
//   _MessageHandlerState createState() => _MessageHandlerState();
// }

// class _MessageHandlerState extends State<MessageHandler> {
//   final Firestore _db = Firestore.instance;
//
// // TODO...
// //  onMessage fires when the app is open and running in the foreground.
// //  onResume fires if the app is closed, but still running in the background.
// //  onLaunch fires if the app is fully terminated.
//   bool _topicButtonsDisabled = false;
//
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
//   final TextEditingController _topicController =
//   TextEditingController(text: 'topic');
//
//   Widget _buildDialog(BuildContext context, Item item) {
//     return AlertDialog(
//       content: Text("${item.matchteam} with score: ${item.score}"),
//       actions: <Widget>[
//         FlatButton(
//           child: const Text('CLOSE'),
//           onPressed: () {
//             Navigator.pop(context, false);
//           },
//         ),
//         FlatButton(
//           child: const Text('SHOW'),
//           onPressed: () {
//             Navigator.pop(context, true);
//           },
//         ),
//       ],
//     );
//   }
//
//   void _showItemDialog(Map<String, dynamic> message) {
//     showDialog<bool>(
//       context: context,
//       builder: (_) => _buildDialog(context, _itemForMessage(message)),
//     ).then((bool shouldNavigate) {
//       if (shouldNavigate == true) {
//         _navigateToItemDetail(message);
//       }
//     });
//   }
//
//   void _navigateToItemDetail(Map<String, dynamic> message) {
//     final Item item = _itemForMessage(message);
//     // Clear away dialogs
//     Navigator.popUntil(context, (Route<dynamic> route) => route is PageRoute);
//     if (!item.route.isCurrent) {
//       Navigator.push(context, item.route);
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _firebaseMessaging.configure(
//       onMessage: (Map<String, dynamic> message) async {
//         print("onMessage: $message");
//         _showItemDialog(message);
//       },
//       onBackgroundMessage: myBackgroundMessageHandler,
//       onLaunch: (Map<String, dynamic> message) async {
//         print("onLaunch: $message");
//         _navigateToItemDetail(message);
//       },
//       onResume: (Map<String, dynamic> message) async {
//         print("onResume: $message");
//         _navigateToItemDetail(message);
//       },
//     );
//     _firebaseMessaging.requestNotificationPermissions(
//         const IosNotificationSettings(
//             sound: true, badge: true, alert: true, provisional: true));
//     _firebaseMessaging.onIosSettingsRegistered
//         .listen((IosNotificationSettings settings) {
//       print("Settings registered: $settings");
//     });
//     _firebaseMessaging.getToken().then((String token) {
//       assert(token != null);
//       print("Push Messaging token: $token");
//     });
//     _firebaseMessaging.subscribeToTopic("matchscore");
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       appBar: AppBar(
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: const Text('My Flutter FCM'),
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           padding: EdgeInsets.all(20.0),
//           child: Card(
//             child: Container(
//                 padding: EdgeInsets.all(10.0),
//                 child: Column(
//                   children: <Widget>[
//                     Container(
//                       margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
//                       child: Column(
//                         children: <Widget>[
//                           Text('Welcome to this Flutter App:', style: TextStyle(color: Colors.black.withOpacity(0.8))),
//                           Text('You already subscribe to the matchscore topic', style: Theme.of(context).textTheme.title)
//                         ],
//                       ),
//                     ),
//                     Container(
//                       margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
//                       child: Column(
//                         children: <Widget>[
//                           Text('Now you will receive the push notification from the matchscore topics', style: TextStyle(color: Colors.black.withOpacity(0.8)))
//                         ],
//                       ),
//                     ),
//                   ],
//                 )
//             ),
//           ),
//         ),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
