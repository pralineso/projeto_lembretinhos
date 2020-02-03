import 'package:flutter/material.dart';
import 'package:projeto_lembretinhos/helpers/reminder_helper.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';


class ReminderPage extends StatefulWidget {

  final Reminder reminder;

  ReminderPage({this.reminder});//contrutor

  @override
  _ReminderPageState createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {

  //value para o checkbox
  bool alamrVal = false;
  bool yearlyVal = false;
  bool value = true;
  DateTime date1;
  DateTime time1;

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dateController = TextEditingController();

  final _titleFocus = FocusNode();

  bool _reminderEdited = false;

  Reminder _editedReminder;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //senoa veio nenhum lembrete vai ser criado um novo
    if(widget.reminder == null){
      _editedReminder = Reminder();
    } else {
      _editedReminder = Reminder.fromMap(widget.reminder.toMap());

      _titleController.text = _editedReminder.title;
      _descriptionController.text = _editedReminder.description;
      _dateController.text = _editedReminder.date;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text("Lembretinhos",
                style: TextStyle( fontSize: 24, color: Colors.white)
            ),
            backgroundColor: Colors.deepPurpleAccent),

          floatingActionButton: FloatingActionButton(
            onPressed: (){
              if(_editedReminder.title != null && _editedReminder.title.isNotEmpty){
                Navigator.pop(context, _editedReminder);//é akiq mandar pra la o q foi alterado
              } else {
                FocusScope.of(context).requestFocus(_titleFocus);
              }
            },
            child: Icon(Icons.save),
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
                    controller: _titleController,
                    focusNode: _titleFocus,
                    decoration: InputDecoration(
                      labelText: "Título",
                      labelStyle: TextStyle(color: Colors.black87),
                      border: OutlineInputBorder(),
                    ),
                    textAlign: TextAlign.start,
                    style: TextStyle(color:  Colors.black87, fontSize: 20),
                    onChanged: (text){
                      _reminderEdited = true;
                      setState(() {
                        _editedReminder.title = text;
                      });
                    },
                  ),
                  Divider(),
                  TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: "Descrição",
                      labelStyle: TextStyle(color: Colors.black87),
                      border: OutlineInputBorder(),
                    ),
                    textAlign: TextAlign.start,
                    style: TextStyle(color:  Colors.black87, fontSize: 20),
                    onChanged: (text){
                      _reminderEdited = true;
                      setState(() {
                        _editedReminder.description = text;
                      });
                    },
                  ),
                  Divider(),
                  DateTimePickerFormField(
                    controller: _dateController,
                    inputType: InputType.date,
                    style: TextStyle(color: Colors.black87, fontSize: 20),
                    format: DateFormat("dd-MM-yyyy"),
                    initialDate: DateTime(2019, 1, 1),
                    editable: false,
                    decoration: InputDecoration(
                      labelText: 'Data',
                      labelStyle: TextStyle(color: Colors.black87),
                      hasFloatingPlaceholder: true,
                      border: OutlineInputBorder(),
                    ),
//                    onChanged: (dt) {
//                      setState(() => date1 = dt);
//                      print('Selected date: $date1');
//                    },
                    onChanged: (text){
                      _reminderEdited = true;
                      setState(() {
                        _editedReminder.date =  text.toString();
                      });
                    },

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
                      IconButton(
                        icon: Icon(Icons.access_time),
                        onPressed: (){
//                          DateTimePickerFormField(
//                            inputType: InputType.time,
//                            format: DateFormat("HH:mm"),
//                            initialTime: TimeOfDay(hour: 5, minute: 5),
//                            editable: false,
//                            decoration: InputDecoration(
//                                labelText: 'Time',
//                                hasFloatingPlaceholder: false
//                            ),
//                            onChanged: (dt) {
//                              setState(() => time1 = dt);
//                              print('Selected date: $time1');
//                              print('Hour: $time1.hour');
//                              print('Minute: $time1.minute');
//                            },
//                          );
                        },
                        iconSize: 20,)
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
