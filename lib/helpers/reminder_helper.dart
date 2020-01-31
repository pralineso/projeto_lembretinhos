import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String reminderTable = "reminderTable";
final String idColumn = "idColumn";
final String titleColumn = "titleColumn";
final String descriptionColumn = "descriptionColumn";
final String dateColumn = "dateColumn";
final String timeColumn = "timeColumn";
final String yearlyColumn = "yearlyColumn";
final String alarmColumn = "alarmColumn";

class ReminderHelper{

  Database _db;


  //inicia a conexao com bd
  Future<Database> get db async{
    if(_db != null){
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  //
  Future<Database> initDb() async{
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "reminder3.bd");

    return openDatabase(path, version: 1, onCreate: (Database db, int newerVersion) async {
      await db.execute(
        "CREATE TABLE $reminderTable($idColumn INTEGER PRIMARY KEY, $titleColumn TEXT,"
            "$descriptionColumn TEXT, $dateColumn TEXT, $timeColumn TEXT,"
            "$yearlyColumn TEXT, $alarmColumn TEXT)"
      );
    });
  }

  //create-insert
  Future<Reminder> createReminder(Reminder reminder) async{
    Database dbReminder = await db;
    reminder.id = await dbReminder.insert(reminderTable, reminder.toMap());
    return reminder;
  }

  //update
  Future<int> updateReminder(Reminder reminder) async{
    Database dbReminder = await db;
    return await dbReminder.update(reminderTable,
        reminder.toMap(),
    where:  "$idColumn = ?",
    whereArgs: [reminder.id]
    );
  }

  //read
  //listar tds
  Future<List> getAllReminders() async{
    Database dbReminder = await db;
    List listMap = await dbReminder.rawQuery("SELECT * FROM $reminderTable");
    List<Reminder> listReminder = List();
    for(Map m in listMap){
      listReminder.add(Reminder.fromMap(m));
    }
    return listReminder;
  }

  //buscar por id
  Future<Reminder> getReminder(int id) async{
    Database dbReminder = await db;
    List<Map> maps = await dbReminder.query(reminderTable,
    columns: [idColumn, titleColumn, descriptionColumn, dateColumn, titleColumn, yearlyColumn, alarmColumn],
    where: "$idColumn = ?",
    whereArgs: [id]
    );
    if(maps.length > 0){
      return Reminder.fromMap(maps.first);
    } else {
      return null;
    }
  }

  //delete
  Future<int> deleteReminder(int id) async{
    Database dbReminder = await db;
    return await dbReminder.delete(reminderTable,
    where: "$idColumn = ?",
    whereArgs: [id]
    );
  }

  //contar qtd de lembretes
  Future<int> getNumber() async{
    Database dbReminder = await db;
    return Sqflite.firstIntValue(await dbReminder.rawQuery("SELECT COUNT(*) FROM $reminderTable"));
  }

  close() async{
    Database dbContact = await db;
    dbContact.close();
  }


}

class Reminder{

  int id;
  String title;
  String description;
  String date;
  String time;
  String yearly;
  String alarm;

  Reminder();

  Reminder.fromMap(Map map){
    id = map[idColumn];
    title = map[titleColumn];
    description = map[descriptionColumn];
    date = map[dateColumn];
    time = map[timeColumn];
    yearly = map[yearlyColumn];
    alarm = map[alarmColumn];
  }

  Map toMap(){
    Map<String, dynamic> map = {
      titleColumn: title,
      descriptionColumn: description,
      dateColumn: date,
      timeColumn: time,
      yearlyColumn: yearly,
      alarmColumn: alarm
    };
    if(id!=null){
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    // TODO: implement toString
    return "Lembrete nº$id, titulo: $title, descrição: $description, dia: $date, hora: $time, anualmente: $yearly, alarme: $alarm";
  }


}