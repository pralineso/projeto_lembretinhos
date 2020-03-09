import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationPlugin{
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  NotificationPlugin(){
    _initializeNotifications();
  }

  void _initializeNotifications(){
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
    final _notificationPlugin = NotificationPlugin();
    Future<List<PendingNotificationRequest>> notificationFuture;

    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) {
    if (payload !=null){
      print('Notification payload: '+ payload);
    }
  }

  Future<void> showWeeklyAtDayAndTime(Time time, Day day, int id, String title, String description) async{
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'show weekly channel id',
        'show weekly channel name',
        'show weekly description'
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await _flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
        id,
        title,
        description,
        day,
        time,
        platformChannelSpecifics
    );
  }

  Future<List<PendingNotificationRequest>> getSccheduledNotifications() async{
    var pendingNotifications = await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
    return pendingNotifications;
  }

  Future cancelNotification(int id) async{
    await _flutterLocalNotificationsPlugin.cancel(id);
  }
}






