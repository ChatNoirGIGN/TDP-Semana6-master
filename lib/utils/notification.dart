import 'package:carsharing_app/main.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationSend {
  void showNotification(String cabezera, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        ticker: 'ticker');
    const IOSNotificationDetails iOSPlatformChannelSpecifics = IOSNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true);

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, '$cabezera', '$body', platformChannelSpecifics,
        payload: 'item x');
  }
  }