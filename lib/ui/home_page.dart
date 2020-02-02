import 'package:flutter/material.dart';
import 'package:projeto_lembretinhos/helpers/reminder_helper.dart';
import 'package:projeto_lembretinhos/ui/reminder_page.dart';
import 'package:sqflite/sqflite.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  ReminderHelper reminder = ReminderHelper();

  List<Reminder> reminders = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  Reminder r = Reminder();
//    r.title = "Aniversario Lug";
//    r.description = "Niver";
//    r.date = "08/02/2019";
//    r.time = "00:00";
//    r.yearly = "1";
//    r.alarm = "0";
//
//    reminder.createReminder(r);

//    reminder.getAllReminders().then((list){
////      print(list);
//      reminders = list;
//    });
    _getAllReminders();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () { Scaffold.of(context).openDrawer(); },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
          title: Text("Lembretinhos", style: TextStyle( fontSize: 24)),
          backgroundColor: Colors.deepPurpleAccent,
         // centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed:(){},
            )
          ],
        ),
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            _showReminderPage();
          },
          child: Icon(Icons.add),
          backgroundColor:  Colors.deepPurpleAccent,
        ),
        body: ListView.builder(
          padding: EdgeInsets.all(10),
          itemCount: reminders.length,
          itemBuilder: (context, index){
            return _reminderCard(context, index);
          },
        )
    );
  }

  Widget _reminderCard(BuildContext context, int index){
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 55),
                child: Column(
                  children: <Widget>[
                    Text(reminders[index].title ?? "",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black54),
                      textAlign: TextAlign.justify,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(reminders[index].date ?? "",
                          style: TextStyle(fontSize: 18,
                              fontWeight:  FontWeight.bold, color: Colors.black26),
                        ),
                        IconButton(icon: Icon(Icons.alarm), color: Colors.black26 ,onPressed: (){})
                      ],
                    )
                  ],

                ),
              ),
            ],
          ),
        ),

      ),
      onTap: (){
        _showReminderPage(reminder: reminders[index]);
      },
    );
  }

  void _showReminderPage({Reminder reminder}){
    Navigator.push(context, MaterialPageRoute(builder: (context) => ReminderPage(reminder: reminder)));
  }

  void _getAllReminders(){
    reminder.getAllReminders().then((list){
      setState(() {
        reminders = list;
      });
    });
  }
}
