import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projeto_lembretinhos/helpers/reminder_helper.dart';
import 'package:projeto_lembretinhos/ui/reminder_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

enum Options { view, edit, delete }

class _HomePageState extends State<HomePage> {

  ReminderHelper helper = ReminderHelper();

  List<Reminder> reminders = List();

  var _selection;

  @override
  void initState() {
    super.initState();

    _getAllReminders();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //menu lateral
//        leading: Builder(
//          builder: (BuildContext context) {
//            return IconButton(
//              icon: const Icon(Icons.menu),
//              onPressed: () { Scaffold.of(context).openDrawer(); },
//              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
//            );
//          },
//        ),
        title: Text("Lembretinhos", style: TextStyle( fontSize: 24)),
        backgroundColor: Colors.deepPurpleAccent,
        // centerTitle: true,
        // botao de pesquisar
//        actions: <Widget>[
//          IconButton(
//            icon: Icon(Icons.search),
//            onPressed:(){},
//          )
//        ],
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

            ListTile(
                title: Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Text(reminders[index].title ?? "",
                    style: TextStyle(fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54 ),
                  ),
                ),

                subtitle: Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(0.0,10.0,10.0,10.0),
                        child:  Text(reminders[index].date ?? "",
                          style: TextStyle(fontSize: 18,
                              fontWeight:  FontWeight.bold,
                              color: Colors.black26),
                        ),
                      ),
                      Text(reminders[index].time ?? "",
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
      ),
      onTap: (){
        _showReminderPage(reminder: reminders[index], view: true);
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
                          child: Text("Visualizar",
                            style: TextStyle(
                                color: Colors.deepPurpleAccent,
                                fontSize: 18
                            ),
                          ),
                          onPressed: (){
                            Navigator.pop(context);
                            _showReminderPage(reminder: reminders[index], view: true);
                          },
                        ),
                      ),
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

  void _showReminderPage({Reminder reminder, bool view}) async{
    final recReminder = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => ReminderPage(reminder: reminder, view: view) )
    );//reminder receber o contato q vem da tela de cad
    if (view == null) {
      if(recReminder != null){//se oq  vier nao for nulo
        if(reminder != null) { //e se o q vier ja for um contato (editado)
          await helper.updateReminder(recReminder); //update ele
         // print("fez upadt");
        } else { //se eo q vir nao for nada q foi enviado entao vai salvar
          await helper.createReminder(recReminder);

          //e ai chama o schedulenotification
        }
      }
      _getAllReminders();//carrega dnv // atualiza lista
      print(recReminder.toString());
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
