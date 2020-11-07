//
// import 'dart:async';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
// import 'package:flutter_firebase_tic_tac_toe/models/User.dart';
// import 'package:flutter_firebase_tic_tac_toe/models/app_error.dart';
// import 'package:flutter_firebase_tic_tac_toe/utils/user_util.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
//
//
// class user_manager {
//   FirebaseAuth _auth;
//   GoogleSignIn _googleSignIn;
//
//   user_manager() {
//     _auth = FirebaseAuth.instance;
//     // _googleSignIn = GoogleSignIn();
//   }
//
//   // TODO: Update to just requiring UserName
//
//   Future<User> signUpWithEmailAndPassword(username) async {
//     final FirebaseUser user = await _auth.createUserWithEmailAndPassword(
//         email: email, password: password);
//     UserUpdateInfo updateInfo = new UserUpdateInfo();
//     updateInfo.displayName = username;
//     await user.updateProfile(updateInfo);
//     return signInWithEmailAndPasword(email, password);
//   }
//
//   Future<User> signInWithEmailAndPasword(email, password) async {
//     final FirebaseUser user = await _auth.signInWithEmailAndPassword(
//         email: email, password: password);
//     return _processAuthUser(user);
//   }
//
//
//   Future<User> _processAuthUser(FirebaseUser authUser) async {
//
//     User loggedInUser = User(
//         id: authUser.uid,
//         email: authUser.email,
//         name: authUser.displayName,
//         avatarUrl: authUser.photoUrl);
//
//     String fcmToken = await _getTokenFromPreference();
//     loggedInUser = loggedInUser.copyWith(fcmToken: fcmToken);
//     await _addUserToFireStore(loggedInUser);
//     return loggedInUser;
//   }
//
//   logoutUser() async{
//     if((await _auth.currentUser()) != null){
//       _auth.signOut();
//     }
//   }
//
//
//   Future<Null> _addUserToFireStore(User user) async {
//
//     await Firestore.instance
//         .collection('users')
//         .document(user.id)
//         .setData({'email': user.email, 'displayName': user.name, 'fcmToken': user.fcmToken, 'currentState': UserUtil().getStringFromState(UserState.available)});
//   }
//
//   saveUserFcmTokenToPreference(String token) async{
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString('fcm_token', token);
//   }
//
//   addUserTokenToStore(String userId, String fcmToken) async{
//     await Firestore.instance
//         .collection('users')
//         .document(userId)
//         .setData({'fcmToken': fcmToken}, merge: true);
//   }
//
//   Future<String> _getTokenFromPreference() async{
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String fcmToken = prefs.getString('fcm_token');
//     return fcmToken;
//   }
//
//   Future<User> getCurrentUser() async {
//
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String   token = prefs.getString('fcm_token');
//     FirebaseUser currentUser = await _auth.currentUser();
//     if(currentUser != null){
//       return User(id: currentUser.uid, name: currentUser.displayName, avatarUrl: currentUser.photoUrl , fcmToken:  token );
//     }
//     return null;
//
//   }
//
//   checkUserPresence(){
//     FirebaseDatabase.instance
//         .reference()
//         .child('.info/connected')
//         .onValue.listen((Event event) async{
//       if(event.snapshot.value == false){
//         return;
//       }
//       User currentUser = await getCurrentUser();
//       FirebaseDatabase.instance.reference().child('/status/'+currentUser.id).onDisconnect().set({
//         'state': UserUtil().getStringFromState(UserState.offline)
//       }).then((onValue){
//         FirebaseDatabase.instance.reference().child('/status/'+currentUser.id).set({
//           'state': UserUtil().getStringFromState(UserState.available)
//         });
//       });
//     });
//   }
//
// }