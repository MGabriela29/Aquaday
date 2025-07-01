import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';

Future<void> requestNotificationPermission() async {
  if (Platform.isAndroid) {
    final status = await Permission.notification.request();
    if (status.isGranted) {
      debugPrint("✅ Permiso de notificación concedido.");
    } else if (status.isDenied) {
      debugPrint("⚠️ Permiso de notificación denegado por el usuario.");
    } else if (status.isPermanentlyDenied) {
      debugPrint("⚠️ Permiso de notificación denegado permanentemente.");
      openAppSettings();
    }
  }
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async { 
    // Inicializa zonas horarias
    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('icon_notification');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
        debugPrint("🔔 Notificación seleccionada: ${notificationResponse.payload}");
      },
    );

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'alarm_channel_id', // id del canal
    'Alarm Notifications v3', // nombre visible
    description: 'Canal para alarmas programadas de AquaDay',
    importance: Importance.max,
    playSound: true,
  );

  await _flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

    // Solicita permisos después de inicializar
    await requestNotificationPermission();
  }

  Future<void> showScheduledNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    try {
      final status = await Permission.notification.status;
      if (!status.isGranted) {
        debugPrint("🚫 Notificaciones no permitidas. No se programó la alarma.");
        return;
      }

      await _flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledTime, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'alarm_channel_id',
            'Alarm Notifications',
            channelDescription: 'Canal para alarmas programadas de AquaDay',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
            enableVibration: true,
          ),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );

      debugPrint("✅ Notificación programada correctamente para $scheduledTime");
    } catch (e) {
      debugPrint("❌ Error al programar la notificación: $e");
    }
  }

  Future<void> cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }
}
 