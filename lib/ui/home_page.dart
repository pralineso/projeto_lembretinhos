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
//                      IconButton(icon: Icon(Icons.more_vert), color: Colors.black54, onPressed:  (){_showOptions(context, index);}),

                      PopupMenuButton<Options>(
                        icon: Icon(Icons.more_vert, color: Colors.black54),
                        onSelected: (Options result) {
                          setState(() {
                            _actionOptions(context, index, _selection);
                            //_selection = result;
                          });
                        },
                        itemBuilder: (BuildContext context) => <PopupMenuEntry<Options>>[
                          const PopupMenuItem<Options>(
                            value: Options.view,
                            child: Text('Visualizar', style: TextStyle(color: Colors.black54)),
                          ),
                          const PopupMenuItem<Options>(
                            value: Options.edit,
                            child: Text('Editar', style: TextStyle(color: Colors.black54)),
                          ),
                          const PopupMenuItem<Options>(
                            value: Options.delete,
                            child: Text('Excluir', style: TextStyle(color: Colors.black54)),
                          ),
                        ],
                      ),
                    ],
                  ),
                )

            ),
            //   ),
          ],
        ),
      ),
      onTap: (){
        // _showReminderPage(reminder: reminders[index]);
      },
    );
  }



  void _actionOptions(BuildContext context, int index, Options result){
    String r = result.toString();
    switch (r){
      case "Options.view":
        {
          print("visualizar");
          break;
        }
      case "Options.edit":{
        Navigator.pop(context);
        _showReminderPage(reminder: reminders[index]);
        break;
      }
      case "Options.delete":{
        helper.deleteReminder(reminders[index].id);
        setState(() {
          reminders.removeAt(index);
          Navigator.pop(context);
        });
        break;
      }
    }
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
