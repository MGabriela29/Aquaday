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
      'alarm_channel_id_v2', // id del canal
      'Alarm Notifications v2', // nombre visible
      // channelDescription: 'Canal para alarmas programadas de AquaDay',
      importance: Importance.max,
      priority: Priority.high,
      // playSound: true,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
       'AquaDay - ¡Hora de beber agua!',
       'Es hora de hidratarte y cuidar tu salud. \n Bebe un vaso de agua ahora.',
      // 'mi noti de prueba', 
      notificationDetails );
}