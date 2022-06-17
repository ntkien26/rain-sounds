import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:rain_sounds/data/local/model/media_model.dart';

import 'media_player_central.dart';

class NotificationUtils {

  /* *********************************************
      MEDIA CONTROLLER NOTIFICATIONS
  ************************************************ */

  static void updateNotificationMediaPlayer(int id, MediaModel? mediaNow) {
    if (mediaNow == null) {
      cancelNotification(id);
      return;
    }

    AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: id,
            channelKey: 'media_player',
            category: NotificationCategory.Transport,
            title: mediaNow.bandName,
            body: mediaNow.trackName,
            summary: 'Now playing',
            notificationLayout: NotificationLayout.MediaPlayer,
            largeIcon: mediaNow.diskImagePath,
            color: Colors.purple.shade700,
            autoDismissible: false,
            showWhen: false),
        actionButtons: [
          NotificationActionButton(
              key: 'MEDIA_PREV',
              icon: 'resource://drawable/res_ic_prev' +
                  (MediaPlayerCentral.hasPreviousMedia ? '' : '_disabled'),
              label: 'Previous',
              autoDismissible: false,
              showInCompactView: false,
              enabled: true,
              buttonType: ActionButtonType.KeepOnTop),
          NotificationActionButton(
              key: 'MEDIA_PAUSE',
              label: 'Pause',
              autoDismissible: false,
              showInCompactView: true,
              enabled: true,
              buttonType: ActionButtonType.KeepOnTop),
          NotificationActionButton(
              key: 'MEDIA_NEXT',
              label: 'Previous',
              showInCompactView: true,
              enabled: true,
              buttonType: ActionButtonType.KeepOnTop),
          NotificationActionButton(
              key: 'MEDIA_CLOSE',
              label: 'Close',
              autoDismissible: true,
              showInCompactView: true,
              enabled: true,
              buttonType: ActionButtonType.KeepOnTop)
        ]);
  }

  static Future<void> cancelNotification(int id) async {
    await AwesomeNotifications().cancel(id);
  }
}