import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rain_sounds/data/local/service/sound_service.dart';

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
      actionButtons: [
        NotificationActionButton(
          key: 'MARK_DONE',
          label: 'Mark Done',
        ),
      ],
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

  Future<void> createMediaNotification(SoundService soundService) async {
    AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 1919,
            channelKey: 'media_player',
            category: NotificationCategory.Transport,
            title: 'Sleep sound',
            body: 'Sleep sound',
            summary: 'Now playing',
            notificationLayout: NotificationLayout.MediaPlayer,
            color: Colors.purple.shade700,
            autoDismissible: false,
            showWhen: false),
        actionButtons: [
          NotificationActionButton(
              key: 'MEDIA_PREV',
              label: 'Previous',
              autoDismissible: false,
              showInCompactView: false,
              enabled: false,
              buttonType: ActionButtonType.KeepOnTop),
          soundService.isPlaying
              ? NotificationActionButton(
                  key: 'MEDIA_PAUSE',
                  icon: 'resource://drawable/res_ic_pause',
                  label: 'Pause',
                  autoDismissible: false,
                  showInCompactView: true,
                  buttonType: ActionButtonType.KeepOnTop)
              : NotificationActionButton(
                  label: 'Play',
                  autoDismissible: false,
                  showInCompactView: true,
                  enabled: soundService.totalActiveSound > 0,
                  buttonType: ActionButtonType.KeepOnTop,
                  key: 'play'),
          NotificationActionButton(
              key: 'MEDIA_NEXT',
              label: 'Previous',
              showInCompactView: true,
              enabled: false,
              buttonType: ActionButtonType.KeepOnTop),
          NotificationActionButton(
              key: 'MEDIA_CLOSE',
              label: 'Close',
              autoDismissible: true,
              showInCompactView: true,
              buttonType: ActionButtonType.KeepOnTop)
        ]);
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
