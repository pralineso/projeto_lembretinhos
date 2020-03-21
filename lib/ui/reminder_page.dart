import 'dart:math';

import 'package:date_format/date_format.dart';
import 'package:datetime_picker_formfield/time_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projeto_lembretinhos/helpers/reminder_helper.dart';
import 'package:intl/intl.dart';
//import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
//import 'package:intl/intl_browser.dart';


class ReminderPage extends StatefulWidget {
  final Reminder reminder;
  final bool view;

  ReminderPage({this.reminder, this.view});//contrutor

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
 // final _dateController = new MaskedTextController(text:'dd-MM-yyyy', mask: '00-00-0000');



  final _titleFocus = FocusNode();

  String dateSelected;
  String timeSelected;
  var _date = DateTime.now();
  var _time;
  bool active=true;

  //bool _reminderEdited = false;

  Reminder _editedReminder;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    if(widget.reminder == null){ //senoa veio nenhum lembrete vai ser criado um novo
      _editedReminder = Reminder();
    } else {

      _editedReminder = Reminder.fromMap(widget.reminder.toMap());

      _titleController.text = _editedReminder.title;
      _descriptionController.text = _editedReminder.description;
      _dateController.text = _editedReminder.date;

      timeSelected = _editedReminder.time;
      alamrVal =  _checkBool(_editedReminder.alarm, alamrVal);
      yearlyVal = _checkBool(_editedReminder.yearly, yearlyVal);
    }

    //se veio a condicao do view verdadeira entao desativa os campos
    if(widget.view == true) {
      active = false;
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
            onPressed: () {
              if (widget.view == null) {
                if (_editedReminder.title != null &&
                    _editedReminder.title.isNotEmpty) {
                  Navigator.pop(context,
                      _editedReminder); //é akiq mandar pra la o q foi alterado
                } else {
                  FocusScope.of(context).requestFocus(_titleFocus);
                }
              }else {
                Navigator.pop(context,
                    _editedReminder);
              }
            },
            child:  Icon(Icons.save),
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
                    enabled: active,
                    focusNode: _titleFocus,
                    decoration: InputDecoration(
                      labelText: "Título",
                      labelStyle: TextStyle(color: Colors.black87),
                      border: OutlineInputBorder(),
                    ),
                    textAlign: TextAlign.start,
                    style: TextStyle(color:  Colors.black87, fontSize: 20),
                    onChanged: (text){
                      //_reminderEdited = true;
                      setState(() {
                        _editedReminder.title = text;
                      });
                    },
                  ),
                  Divider(),
                  TextField(
                    controller: _descriptionController,
                    enabled: active,
                    decoration: InputDecoration(
                      labelText: "Descrição",
                      labelStyle: TextStyle(color: Colors.black87),
                      border: OutlineInputBorder(),
                    ),
                    textAlign: TextAlign.start,
                    maxLines: 4,
                    style: TextStyle(color:  Colors.black87, fontSize: 20),
                    onChanged: (text){
                     // _reminderEdited = true;

                      setState(() {
                        _editedReminder.description = text;
                      });
                    },
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          child: TextField(
//                    controller: controller,
                            controller: _dateController,
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: "Data",
                              labelStyle: TextStyle(color: Colors.black87),
                              border: OutlineInputBorder(),
                            ),
                            textAlign: TextAlign.start,
//                    maxLines: 4,
                            style: TextStyle(color:  Colors.black87, fontSize: 20),
                            keyboardType: TextInputType.number,
                            onChanged: (text){
                              //  _reminderEdited = true;
                              setState(() {
                                _editedReminder.date = text;
                              });
                            },
                          ),
                      ),
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

                    ],
                  ),

                  Divider(),
                  Row(
                    children: <Widget>[
                      Checkbox(
                          value: alamrVal,
                         // activeColor: Colors.grey,
                          onChanged: (bool value){
                            setState(() {
                              alamrVal=value;
                              _editedReminder.alarm = alamrVal.toString();
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
                          _selectedTime(context);
                        },

                        iconSize: 20,
                      ),
                      Text( timeSelected ?? "",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black87
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Checkbox(
                          value: yearlyVal,
                          onChanged: (bool value){
                            setState(() {
                              yearlyVal = value;
                              _editedReminder.yearly = yearlyVal.toString();
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

  bool _checkBool(String text, bool checkval){
    if(text == 'true') {
      checkval = true;
    } else {
      checkval = false;
    }
    return checkval;
  }

//  Widget buildDateTextField(TextEditingController c){
//    return TextField(
//      controller: c,
//      decoration: InputDecoration(
//          labelText: "Data",
//          labelStyle: TextStyle(color: Colors.amber),
//          border: OutlineInputBorder(),
//         ),
//      style: TextStyle(color: Colors.amber, fontSize: 25.0),
//      onChanged: null,
//      keyboardType: TextInputType.number,
//    );
//  }

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
   //  print(_time.toString().substring(9));
    timeSelected = _time.toString().substring(9);
    setState(() {
      _editedReminder.time = timeSelected;
    });
   // print("dentro da funaoo $timeSelected");
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
        dateSelected = formatDate(_date, [dd, '-', mm, '-', yyyy]).toString();
 //       dateSelected = DateFormat.yMd().format(_date);

        _dateController.text = dateSelected.toString();
    //    print(dateSelected);
        //_dateController.text = _date.toString();
      });
    }

    setState(() {
      _editedReminder.date = dateSelected.toString();
     // _dateController.text = _date.toString();
    });

//    print("Date _date" + _date.toString());
//    print("Date selected " + dateSelected);
  }


}

