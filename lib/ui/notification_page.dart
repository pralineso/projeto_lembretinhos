import 'dart:async';
//import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//import 'package:http/http.dart' as http;
//import 'package:path_provider/path_provider.dart';
import 'package:rxdart/subjects.dart';

var _date = DateTime.now();
var _time;
String timeSelected;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

// Streams are created so that app can respond to notification-related events since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
BehaviorSubject<String>();

NotificationAppLaunchDetails notificationAppLaunchDetails;

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification(
      {@required this.id,
        @required this.title,
        @required this.body,
        @required this.payload});
}

/// IMPORTANT: running the following code on its own won't work as there is setup required for each platform head project.
/// Please download the complete example app from the GitHub repository where all the setup has been done
Future<void> main() async {




  // needed if you intend to initialize in the `main` function
  WidgetsFlutterBinding.ensureInitialized();

  notificationAppLaunchDetails = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  var initializationSettingsAndroid = AndroidInitializationSettings('app-icon.png');
  // Note: permissions aren't requested here just to demonstrate that can be done later using the `requestPermissions()` method
  // of the `IOSFlutterLocalNotificationsPlugin` class
  var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async {
        didReceiveLocalNotificationSubject.add(ReceivedNotification(
            id: id, title: title, body: body, payload: payload));
      });
  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
        if (payload != null) {
          debugPrint('notification payload: ' + payload);
        }
        selectNotificationSubject.add(payload);
      });
  runApp(
    MaterialApp(
      home: NotificationPage(),
    ),
  );
}

class PaddedRaisedButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  const PaddedRaisedButton(
      {@required this.buttonText, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
      child: RaisedButton(child: Text(buttonText), onPressed: onPressed),
    );
  }
}

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final MethodChannel platform =
  MethodChannel('crossingthestreams.io/resourceResolver');
  @override
  void initState() {
    super.initState();
//    _requestIOSPermissions();
    _configureDidReceiveLocalNotificationSubject();
    _configureSelectNotificationSubject();
  }

//  void _requestIOSPermissions() {
//    flutterLocalNotificationsPlugin
//        .resolvePlatformSpecificImplementation<
//        IOSFlutterLocalNotificationsPlugin>()
//        ?.requestPermissions(
//      alert: true,
//      badge: true,
//      sound: true,
//    );
//  }

  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationSubject.stream
        .listen((ReceivedNotification receivedNotification) async {
      await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: receivedNotification.title != null
              ? Text(receivedNotification.title)
              : null,
          content: receivedNotification.body != null
              ? Text(receivedNotification.body)
              : null,
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Ok'),
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SecondScreen(receivedNotification.payload),
                  ),
                );
              },
            )
          ],
        ),
      );
    });
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String payload) async {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SecondScreen(payload)),
      );
    });
  }

  @override
  void dispose() {
    didReceiveLocalNotificationSubject.close();
    selectNotificationSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('NotificationPage'),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
                    child: Text('Teste da notificação para o app Lembretinhos'),
                  ),

                Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(5, 6, 5, 6),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Colors.grey[400],
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.calendar_today),
                          onPressed: (){
                            _selectDate(context);
                          },
                        ),
                      ),
                      VerticalDivider(),
                      Container(
                        padding: EdgeInsets.fromLTRB(5, 6, 5, 6),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Colors.grey[400],
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.access_time),
                          onPressed: (){
                            _selectedTime(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
//                 PaddedRaisedButton(
//                    buttonText: 'Cancel notification',
//                    onPressed: () async {
//                      await _cancelNotification();
//                    },
//                  ),
                  PaddedRaisedButton(
                    buttonText:
                    'Schedule notification to appear in 5 seconds, custom sound, red colour, large icon, red LED',
                    onPressed: () async {
                      await _scheduleNotification(_date,_time);
                    },
                  ),
                  PaddedRaisedButton(
                    buttonText: 'Check pending notifications',
                    onPressed: () async {
                      await _checkPendingNotificationRequests();
                    },
                  ),
                  PaddedRaisedButton(
                    buttonText: 'Cancel all notifications',
                    onPressed: () async {
                      await _cancelAllNotifications();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<Null> _selectDate(BuildContext context) async{
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2019),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
              primaryColor: const Color(0xFF4A5BF6),
              accentColor: const Color(0xFF4A5BF6)
          ),
          child: child,
        );
      },
    );

    if (picked !=null && picked != _date){
      setState(() {
        _date = picked;
      });
    }

//    await _scheduleNotification(_date);

    print("Date _date" + _date.toString());
  }

  Future<Null> _selectedTime(BuildContext context) async{
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if(picked != null && picked != _time){
      setState(() {
        _time = picked;
      });
    }
    // print(_time.toString().substring(9));
    timeSelected = _time.toString().substring(9);

    print("timeSelected =  $timeSelected");
    print("timeSelected =  $timeSelected");

    print("timeSelected =" +  _time.toString());
  }


  Future<void> _cancelNotification() async {
    await flutterLocalNotificationsPlugin.cancel(0);
  }

//androidAllowWhileIdle
  /// Schedules a notification that specifies a different icon, sound and vibration pattern
  Future<void> _scheduleNotification(DateTime dia, TimeOfDay hora) async {

   // DateTime horario = new DateTime(2020,3,10,11,50,0,0,0);
   // DateTime dateTimeShedule = new DateTime(dia.year, dia.month, dia.day, hora.hour, hora.minute);
 //   print(dateTimeShedule.toString());
    var scheduledNotificationDateTime = DateTime(dia.year, dia.month, dia.day, hora.hour, hora.minute);
    //DateTime.now().add(Duration(minutes: 2));
    var vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your other channel id',
        'your other channel name',
        'your other channel description',
        icon: 'secondary_icon',
        largeIcon: 'sample_large_icon',
        largeIconBitmapSource: BitmapSource.Drawable,
//        vibrationPattern: vibrationPattern
    );
    var iOSPlatformChannelSpecifics =
    IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        0,
        'scheduled title',
        'scheduled body',
        scheduledNotificationDateTime,
        platformChannelSpecifics);
  }

  Future<void> _checkPendingNotificationRequests() async {
    var pendingNotificationRequests =
    await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    for (var pendingNotificationRequest in pendingNotificationRequests) {
      debugPrint(
          'pending notification: [id: ${pendingNotificationRequest.id}, title: ${pendingNotificationRequest.title}, body: ${pendingNotificationRequest.body}, payload: ${pendingNotificationRequest.payload}]');
    }
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
              '${pendingNotificationRequests.length} pending notification requests'),
          actions: [
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    await showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: title != null ? Text(title) : null,
        content: body != null ? Text(body) : null,
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SecondScreen(payload),
                  //aki tem mandar pra pagina de visualização do lembrete ou a principal do app
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

class SecondScreen extends StatefulWidget {
  SecondScreen(this.payload);

  final String payload;

  @override
  State<StatefulWidget> createState() => SecondScreenState();
}

class SecondScreenState extends State<SecondScreen> {
  String _payload;
  @override
  void initState() {
    super.initState();
    _payload = widget.payload;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Second Screen with payload: ${(_payload ?? '')}'),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }



}
