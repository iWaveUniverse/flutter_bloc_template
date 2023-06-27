// import 'package:_iwu_pack/setup/index.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

// Future<void> backgroundMessageHandler(RemoteMessage message) async {}
// String? fcmToken;

// class FirebaseCloudMessaging {
//   static final FirebaseMessaging instance = FirebaseMessaging.instance;

//   static initFirebaseMessaging() async {
//     FirebaseMessaging.onMessage.listen((message) {
//       appDebugPrint("OnMessage: ${message.toMap()}");
//       _handler(message, onlyShow: true);
//     });
//     FirebaseMessaging.onMessageOpenedApp.listen((message) {
//       appDebugPrint("OnMessageOpenedApp: ${message.toMap()}");
//       _handler(message);
//     });
//     RemoteMessage? initMessage = await instance.getInitialMessage();
//     if (initMessage != null) {
//       _handler(initMessage);
//     }
//   }

//   static permission() async {
//     NotificationSettings setting = await instance.requestPermission();
//     if (setting.authorizationStatus == AuthorizationStatus.authorized) {
//       fcmToken =
//           await FirebaseMessaging.instance.getToken(vapidKey: googlevapidKey);
//       if (fcmToken != null && (await appPrefs.getNormalToken()) != null) {
//         AuthRepo().addNotificationToken(fcmToken, 'fcm');
//       }
//     }
//   }

//   static _handler(RemoteMessage message, {bool onlyShow = false}) {
//     if (onlyShow) {
//     } else {}
//   }
// }
