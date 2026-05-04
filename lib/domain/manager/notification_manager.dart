import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService {

  static Future<void> init() async {
    await AwesomeNotifications().initialize(
        null,
        [
          NotificationChannel(
              channelGroupKey: 'scheduled_channel_group',
              channelKey: 'scheduled_channel',
              channelName: 'Sleep sound',
              channelDescription: 'Notification channel for sleep sound',
              defaultColor: const Color(0xFF9D50DD),
              ledColor: Colors.white,
              importance: NotificationImportance.High,
              defaultRingtoneType: DefaultRingtoneType.Notification),
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
              channelGroupKey: 'scheduled_channel_group',
              channelGroupName: 'Sleep sound'),
          NotificationChannelGroup(
              channelGroupKey: 'media_player_group',
              channelGroupName: 'Media player controller')
        ],
        debug: true);

    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }

    // Set up listeners for notification actions
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
      onNotificationCreatedMethod: onNotificationCreatedMethod,
      onNotificationDisplayedMethod: onNotificationDisplayedMethod,
    );
  }

  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint('Notification created: ${receivedNotification.id}');
  }

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint('Notification displayed: ${receivedNotification.id}');
  }

  /// Use this method to detect when the user taps on a notification
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    debugPrint('Notification action received: ${receivedAction.id}');
  }

  Future<void> createReminderNotification(
      NotificationWeekAndTime notificationSchedule) async {
    String localTimeZone =
        await AwesomeNotifications().getLocalTimeZoneIdentifier();

    debugPrint(
        'Scheduling notification for weekday: ${notificationSchedule.dayOfTheWeek}, '
        'time: ${notificationSchedule.timeOfDay.hour}:${notificationSchedule.timeOfDay.minute}, '
        'timeZone: $localTimeZone');

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: notificationSchedule.dayOfTheWeek,
        channelKey: 'scheduled_channel',
        title: 'Rain Sounds for Sleep',
        body: 'It\'s time go to bed',
        category: NotificationCategory.Alarm,
        notificationLayout: NotificationLayout.Default,
        wakeUpScreen: true,
      ),
      schedule: NotificationCalendar(
        weekday: notificationSchedule.dayOfTheWeek,
        hour: notificationSchedule.timeOfDay.hour,
        minute: notificationSchedule.timeOfDay.minute,
        second: 0,
        millisecond: 0,
        repeats: true,
        preciseAlarm: true,
        allowWhileIdle: true,
        timeZone: localTimeZone,
      ),
    );

    // Verify it was scheduled
    List<NotificationModel> scheduledList =
        await AwesomeNotifications().listScheduledNotifications();
    debugPrint('Total scheduled notifications: ${scheduledList.length}');
    for (var n in scheduledList) {
      debugPrint('  Scheduled: id=${n.content?.id}, title=${n.content?.title}, '
          'schedule=${n.schedule}');
    }
  }

  Future<void> cancelScheduledNotifications() async {
    await AwesomeNotifications().cancelAllSchedules();
    debugPrint('All scheduled notifications cancelled');
  }

  Future<void> cancelMediaNotifications() async {
    await AwesomeNotifications().cancel(1919);
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
