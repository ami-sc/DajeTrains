import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';

class Noti {
  final _localNotificationService = FlutterLocalNotificationsPlugin();

  final BehaviorSubject<String?> onNotificationClick = BehaviorSubject();

  Future<void> initialize() async {
    const androidInitialize =
        AndroidInitializationSettings('mipmap/ic_launcher');
    final initializationSettings =
        InitializationSettings(android: androidInitialize);
    await _localNotificationService.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onSelectNotification,
    );
  }

  Future<NotificationDetails> _notificationDetails() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails("trainNoti", "trainNoti",
            playSound: true,
            importance: Importance.max,
            priority: Priority.high);
    return NotificationDetails(android: androidPlatformChannelSpecifics);
  }

  Future<void> showNotificationWithPayload(
      {required int id,
      required String title,
      required String body,
      required String payload}) async {
    final notificationDetails = await _notificationDetails();
    await _localNotificationService.show(id, title, body, notificationDetails,
        payload: payload);
  }

  void onSelectNotification(NotificationResponse? payload) {
    print(payload);
    if (payload != null &&
        payload.payload != null &&
        payload.payload!.isNotEmpty) {
      onNotificationClick.add(payload.payload.toString());
    }
  }
}
