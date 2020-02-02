import 'package:flutter/material.dart';
import 'package:projeto_lembretinhos/helpers/reminder_helper.dart';
import 'package:sqflite/sql.dart';


class ReminderPage extends StatefulWidget {
  @override
  _ReminderPageState createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {

  //value para o checkbox
  bool alamrVal = false;
  bool yearlyVal = false;
  bool value = true;


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
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
            onPressed: (){},
            child: Icon(Icons.add),
            backgroundColor:  Colors.deepPurpleAccent,
          ),

          body: SingleChildScrollView(
            padding: EdgeInsets.all(10),
            child: Padding(
              padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text("Lembrar de ...",
                    style: TextStyle( fontSize: 24, color: Colors.black54),
                    textAlign: TextAlign.left,
                  ),
                  Divider(),
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Título",
                      labelStyle: TextStyle(color: Colors.black87),
                      border: OutlineInputBorder(),
                    ),
                    textAlign: TextAlign.start,
                    style: TextStyle(color:  Colors.black87, fontSize: 20),
                  ),
                  Divider(),
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Descrição",
                      labelStyle: TextStyle(color: Colors.black87),
                      border: OutlineInputBorder(),
                    ),
                    textAlign: TextAlign.start,
                    style: TextStyle(color:  Colors.black87, fontSize: 20),
                  ),
                  Divider(),
                  //mudar isso, colocar a data pra selecionar
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Data",
                      labelStyle: TextStyle(color: Colors.black87),
                      border: OutlineInputBorder(),
                    ),
                    textAlign: TextAlign.start,
                    style: TextStyle(color:  Colors.black87, fontSize: 20),
                  ),
                  Divider(),
                  Row(
                    children: <Widget>[
                      Checkbox(
                          value: alamrVal,
                          onChanged: (bool value){
                            setState(() {
                              alamrVal=value;
                            });
                          }),
                      Text("Despertar",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black87
                        ),
                      ),
                      IconButton(icon: Icon(Icons.access_time), onPressed: (){}, iconSize: 20,)
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Checkbox(
                          value: yearlyVal,
                          onChanged: (bool value){
                            setState(() {
                              yearlyVal = value;
                            });
                          }),
                      Text("Anual",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black87
                        ),
                      ),
                    ],
                  ),
                  //  checkbox("Despertar", alamrVal),
                  //  checkbox("Anual", yearlyVal),
                ],
              ),
            ),
          ),
        ),
        onWillPop: null
    );
  }

  Widget checkbox(String title, bool boolValue) {
    return Row(
      children: <Widget>[
        Checkbox(
          value: boolValue,
          onChanged: (bool value) {
            setState(() {
              switch (title) {
                case "Despertar":
                  alamrVal = value;
                  break;
                case "Anual":
                  yearlyVal = value;
                  break;
              }
            });
          },
        ),
        Text(title,
            style: TextStyle(fontSize: 20, color: Colors.black87)
        ),
      ],
    );
  }
}
