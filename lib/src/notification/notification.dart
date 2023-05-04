export 'firebase_messaging.dart';
export 'local_notification.dart';

import 'dart:async';
import 'dart:convert';

import 'package:rxdart/rxdart.dart';

import 'notification.dart';

final BehaviorSubject<String?> selectNotificationSubject =
    BehaviorSubject<String?>();

StreamSubscription? _subscription;

initializeNotificationSetting(Function(Map<String, dynamic> payload) redirect) {
  LocalNotification.setup();
  FirebaseCloudMessaging.initFirebaseMessaging();
  _subscription =
      selectNotificationSubject.stream.listen((String? _payload) async {
    if (_payload == null) return;
    try {
      Map<String, dynamic> payload = jsonDecode(_payload);
      redirect(payload);
    } catch (e) {
      print('Error redirect by notification: $e');
    } finally {
      selectNotificationSubject.add(null);
    }
  });
}

disposeNotificationSetting() {
  _subscription?.cancel();
  _subscription = null;
}
