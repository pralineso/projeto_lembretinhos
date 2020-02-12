import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}



class _NotificationPageState extends State<NotificationPage> {

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) {
    debugPrint("payload : $payload");
    showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        title: new Text('Notification'),
        content: new Text('$payload'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Lembretinhos", style: TextStyle( fontSize: 24)),
          backgroundColor: Colors.deepPurpleAccent),
      body: Center(
        child: RaisedButton(
            onPressed: (){
              showNotification();
            },
            child: Text('press')
        ),
      ),
    );
  }

    showNotification() async{
    var android = new AndroidNotificationDetails('channel id', 'channel NAME', 'CHANNEL DESCRPTION', importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var ios = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, ios);
    await flutterLocalNotificationsPlugin.show(0, 'Notification test', 'Flutter local notification', platform, payload: 'Notification test payload');
  }
}
