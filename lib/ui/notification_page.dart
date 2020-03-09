import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:projeto_lembretinhos/plugin/notification_plugin.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}



class _NotificationPageState extends State<NotificationPage> {

 final _notificationPlugin = NotificationPlugin();
  Future<List<PendingNotificationRequest>> notificationFuture;

  @override
  void initState() {
    super.initState();
    notificationFuture = _notificationPlugin.getSccheduledNotifications();
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
          //    showNotification();
            },
            child: Text('press')
        ),
      ),
    );
  }


}
