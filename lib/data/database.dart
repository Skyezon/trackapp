import 'package:android/const/strings.dart';
import 'package:android/data/delivery.dart';
import 'package:android/data/matrix.dart';
import 'package:android/data/stop.dart';
import 'package:sqflite/sqflite.dart';

Database? db;

Future _onCreate(Database db, int version) async {
  await db.execute('''
        CREATE TABLE ${Delivery.getTableName()}(
        ${Delivery.cDeliveryNumber} varchar(9) PRIMARY KEY UNIQUE,
        ${Delivery.cStartTime} DATETIME,
        ${Delivery.cFinishTime} DATETIME,
        ${Delivery.cPlannedStartTime} DATETIME
        )
    ''');
  await db.execute('''
        CREATE TABLE ${Stop.getTableName()}(
         ${Stop.cId} INTEGER PRIMARY KEY AUTOINCREMENT,
         ${Stop.cName} varchar(255),
         ${Stop.cAddress} varchar(255),
         ${Stop.cStopIndex} INT,
         ${Stop.cStopStartTime} DATETIME,
         ${Stop.cStopEndTime} DATETIME,
         ${Stop.cDeliveryNumber} varchar(9),
         ${Stop.cUnloadingTime} INT,
         
         FOREIGN KEY (${Stop.cDeliveryNumber}) REFERENCES ${Delivery.getTableName()}(${Delivery.cDeliveryNumber})
        )
      ''');
  await db.execute('''
        CREATE TABLE ${Matrix.getTableName()}(
         ${Matrix.cName} varchar(255),
         ${Matrix.cLength} INT ,
         ${Matrix.cDuration} INT,
         ${Matrix.cDeliveryNumber} varchar(9),
         
         PRIMARY KEY (${Matrix.cName},${Matrix.cDeliveryNumber}),
         FOREIGN KEY (${Matrix.cDeliveryNumber}) REFERENCES ${Delivery.getTableName()}(${Matrix.cDeliveryNumber})
        )
  ''');
}

Future _onConfigure(Database db) async {
  await db.execute('PRAGMA foreign_keys = ON');
}

Future<Database?> getDatabase() async{
  if (db != null){
    return db;
  }
  db = await initDatabase();
  return db;
}

Future<Database> initDatabase() async {
  String databasePath = await getDatabasesPath();
  String path = databasePath + DATABASE_FILE_NAME;

  Database database = await openDatabase(path,
      version: 1,
      onCreate: _onCreate,
      onConfigure: _onConfigure,
  );

  return database;
}

 void seedDatabase() async{

  db = await getDatabase();
  String firstDeliveryNumber = "A91JK0S7";
  List<Map> maps =  await db!.query(Delivery.getTableName(),
  columns: [Delivery.cDeliveryNumber],
    where: '${Delivery.cDeliveryNumber} = ?',
    whereArgs: [firstDeliveryNumber]
  );
  if (maps.length > 0){
    return;
  }

  //insert delivery
   await db!.transaction((txn) async {
      await txn.rawInsert("""
     INSERT INTO ${Delivery.getTableName()}(
        ${Delivery.cDeliveryNumber},
        ${Delivery.cStartTime},
        ${Delivery.cFinishTime},
        ${Delivery.cPlannedStartTime}
     ) VALUES (
     '$firstDeliveryNumber',
     '',
     '',
     '${DateTime.now().add(const Duration(minutes: 5)).toIso8601String()}'
     )
      """);
     print("inserted delivery : ${firstDeliveryNumber}") ;

     //insert stops
     String firstStopName = "stop_1";
     await txn.rawInsert("""
     INSERT INTO ${Stop.getTableName()}(
       ${Stop.cName},
       ${Stop.cAddress},
       ${Stop.cStopIndex},
       ${Stop.cStopStartTime},
       ${Stop.cStopEndTime},
       ${Stop.cUnloadingTime},
       ${Stop.cDeliveryNumber} 
     ) VALUES (
       '$firstStopName',
       'abc street',
       '1',
       '',
       '',
       10,
       '${firstDeliveryNumber}'
     )
     """);
     print("inserted stop : $firstStopName");

     String secondStopName = "stop_2";

     await txn.rawInsert("""
     INSERT INTO ${Stop.getTableName()}(
       ${Stop.cName},
       ${Stop.cAddress},
       ${Stop.cStopIndex},
       ${Stop.cStopStartTime},
       ${Stop.cStopEndTime},
       ${Stop.cUnloadingTime},
       ${Stop.cDeliveryNumber} 
     ) VALUES (
        '$secondStopName',
        'def street',
        '2',
        '',
        '',
        '20',
        '${firstDeliveryNumber}'
     )
     """);
     print("inserted stop : $secondStopName");

     //inert matrixs

     await txn.rawInsert("""
      INSERT INTO ${Matrix.getTableName()}(
      ${Matrix.cDeliveryNumber},
      ${Matrix.cName},
      ${Matrix.cLength},
      ${Matrix.cDuration}
      ) VALUES 
        ('$firstDeliveryNumber','$BASE_NAME-$firstStopName',50000,30),
        ('$firstDeliveryNumber','$BASE_NAME-$secondStopName',55000,20),
        ('$firstDeliveryNumber','$firstStopName-$BASE_NAME',48000,25),
        ('$firstDeliveryNumber','$secondStopName-$BASE_NAME',53000,18),
        ('$firstDeliveryNumber','$firstStopName-$secondStopName',20000,10),
        ('$firstDeliveryNumber','$secondStopName-$firstStopName',20000,10) 
     """);
   });
}