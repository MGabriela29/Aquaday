import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();


class NotiService {

Future<void> initNoti() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('icon_notification');

const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);


  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,);

}
  
}

Future<void>mostrarNoti()async{
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'alarm_channel_id_v2', 
      'Alarm Notifications v2', 
      importance: Importance.max,
      priority: Priority.high,

    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
       'AquaDay - Time to drink water!',
       'It is time to hydrate and take care of your health. \n Drink a glass of water now..',
      notificationDetails );
}