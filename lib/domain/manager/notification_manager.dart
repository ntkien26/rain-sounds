import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    // set the icon to null if you want to use the default app icon
    AwesomeNotifications().initialize(
        // set the icon to null if you want to use the default app icon
        null,
        [
          NotificationChannel(
              channelGroupKey: 'scheduled_channel_group',
              channelKey: 'scheduled_channel',
              /* same name */
              channelName: 'Sleep sound',
              channelDescription: 'Notification channel for sleep sound',
              defaultColor: const Color(0xFF9D50DD),
              ledColor: Colors.white),
          NotificationChannel(
              channelGroupKey: 'media_player_group',
              channelKey: 'media_player',
              channelName: 'Media player controller',
              channelDescription: 'Media player controller',
              defaultPrivacy: NotificationPrivacy.Public,
              enableVibration: false,
              enableLights: false,
              playSound: false,
              locked: true),
        ],
        channelGroups: [
          NotificationChannelGroup(
              channelGroupkey: 'scheduled_channel_group',
              channelGroupName: 'Sleep sound'),
          NotificationChannelGroup(
              channelGroupkey: 'media_player_group',
              channelGroupName: 'Media player controller')
        ],
        debug: true);

    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  Future<void> createReminderNotification(
      NotificationWeekAndTime notificationSchedule) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: createUniqueId(),
        channelKey: 'scheduled_channel',
        title: '${Emojis.wheater_droplet} Sleep sound',
        body: 'Bedtime reminder.',
        category: NotificationCategory.Alarm,
        notificationLayout: NotificationLayout.Default,
      ),
      schedule: NotificationCalendar(
        weekday: notificationSchedule.dayOfTheWeek,
        hour: notificationSchedule.timeOfDay.hour,
        minute: notificationSchedule.timeOfDay.minute,
        second: 0,
        millisecond: 0,
        repeats: true,
      ),
    );
  }

  Future<void> cancelScheduledNotifications() async {
    await AwesomeNotifications().cancelAllSchedules();
  }

  Future<void> cancelMediaNotifications() async {
    await AwesomeNotifications().cancel(1919);
  }

  int createUniqueId() {
    return DateTime.now().millisecondsSinceEpoch.remainder(100000);
  }
}

class NotificationWeekAndTime {
  final int dayOfTheWeek;
  final TimeOfDay timeOfDay;

  NotificationWeekAndTime({
    required this.dayOfTheWeek,
    required this.timeOfDay,
  });
}
