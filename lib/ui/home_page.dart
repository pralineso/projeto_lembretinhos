import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projeto_lembretinhos/helpers/reminder_helper.dart';
import 'package:projeto_lembretinhos/ui/reminder_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  ReminderHelper helper = ReminderHelper();

  List<Reminder> reminders = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //   Reminder r = Reminder();
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
      ),
    );
  }

  Widget _reminderCard(BuildContext context, int index){
    return GestureDetector(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
           // Padding(
          //    padding: EdgeInsets.all(10),
           //   child:
              ListTile(
                // contentPadding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                  title:
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Text(reminders[index].title ?? "",
                      style: TextStyle(fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54 ),
                    ),
                  ),
                  subtitle:
                  Container(
                    padding: EdgeInsets.only(left: 10),
                   child:
                   Row(

                     children: <Widget>[
                       Text(reminders[index].date ?? "",
                         style: TextStyle(fontSize: 18,
                             fontWeight:  FontWeight.bold,
                             color: Colors.black26),
                       ),
                       IconButton(icon: Icon(Icons.alarm), color: Colors.black26 ,onPressed: (){})
                     ],
                   ),

                  ),
                  trailing: Container(
                    child: Column(
                      children: <Widget>[
                        IconButton(icon: Icon(Icons.more_vert), color: Colors.black54, onPressed:  (){_showOptions(context, index);}),
                      ],
                    ),
                  )

              ),
         //   ),
          ],
        ),

//        child: Padding(
//          padding: EdgeInsets.all(10),
//          child: Row(
//            children: <Widget>[
//              Padding(
//                padding: EdgeInsets.only(left: 55),
//                child: Column(
//                  crossAxisAlignment: CrossAxisAlignment.start,
//                  children: <Widget>[
//                    Text(reminders[index].title ?? "",
//                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black54),
//                      // textAlign: TextAlign.start,
//                    ),
//                    Row(
//                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                      children: <Widget>[
//                        Text(reminders[index].date ?? "",
//                          style: TextStyle(fontSize: 18,
//                              fontWeight:  FontWeight.bold, color: Colors.black26),
//                        ),
//                        IconButton(icon: Icon(Icons.alarm), color: Colors.black26 ,onPressed: (){})
//                      ],
//                    ),
//
//                  ],
//                ),
//              ),
//                 IconButton(icon: Icon(Icons.more_vert), color: Colors.black54, onPressed:  (){_showOptions(context, index);}),
//            ],
//          ),
//
//        ),
      ),
      onTap: (){
        // _showReminderPage(reminder: reminders[index]);

      },
    );
  }

  void _showOptions(BuildContext context, int index){
    showModalBottomSheet(
        context: context,
        builder: (context){
          return BottomSheet(
              onClosing: (){},
              builder: (context){
                return Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: FlatButton(
                          child: Text("Editar",
                            style: TextStyle(
                                color: Colors.deepPurpleAccent,
                                fontSize: 18
                            ),
                          ),
                          onPressed: (){
                            Navigator.pop(context);
                            _showReminderPage(reminder: reminders[index]);
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: FlatButton(
                          child: Text("Excluir",
                            style: TextStyle(
                                color: Colors.deepPurpleAccent,
                                fontSize: 18
                            ),
                          ),
                          onPressed: (){
                            helper.deleteReminder(reminders[index].id);
                            setState(() {
                              reminders.removeAt(index);
                              Navigator.pop(context);
                            });
                          },
                        ),
                      )
                    ],
                  ),
                );
              }
          );
        }
    );
  }

  void _showReminderPage({Reminder reminder}) async{
    final recReminder = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => ReminderPage(reminder: reminder) )
    );//recreminder receber o contato q vem da tela de cad
    if(recReminder != null){//se oq  vier nao for nulo
      if(reminder != null){//e se o q vier ja for um contato (editado)
        await helper.updateReminder(recReminder);//update ele
      } else { //se eo q vir nao for anda q foi enviao entoa vaisalvar
        await helper.createReminder(recReminder);
      }
      _getAllReminders();//carrega dnv // atualiza lista
    }
  }

  void _getAllReminders(){
    helper.getAllReminders().then((list){
      setState(() {
        reminders = list;
      });
    });
  }
}


Widget build(BuildContext context) {
  return Center(
    child: Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const ListTile(
            leading: Icon(Icons.album),
            title: Text('The Enchanted Nightingale'),
            subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
          ),
          ButtonBar(
            children: <Widget>[
              FlatButton(
                child: const Text('BUY TICKETS'),
                onPressed: () { /* ... */ },
              ),
              FlatButton(
                child: const Text('LISTEN'),
                onPressed: () { /* ... */ },
              ),
            ],
          ),
        ],
      ),
    ),
  );
}