import 'package:android/const/strings.dart';
import 'package:android/data/delivery.dart';
import 'package:android/data/matrix.dart';
import 'package:android/data/stop.dart';
import 'package:android/env.dart';
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

Future<Database> getDatabase() async{
  if (db != null){
    return db!;
  }
  db = await initDatabase();
  return db!;
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

void seedData1() async{

  db = await getDatabase();

  if(NEW_DATABASE_EVERY_RUN){
    String path = await getDatabasesPath();
    await deleteDatabase(path + DATABASE_FILE_NAME);
    db = null;
    db = await getDatabase();
  }

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
     '${DateTime.now().add(const Duration(minutes: 0)).toIso8601String()}'
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

void seedData2() async{

  db = await getDatabase();

  if(NEW_DATABASE_EVERY_RUN){
    String path = await getDatabasesPath();
    await deleteDatabase(path + DATABASE_FILE_NAME);
    db = null;
    db = await getDatabase();
  }

  String firstDeliveryNumber = "TEST12345";
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
     '${DateTime.now().add(const Duration(minutes: 0)).toIso8601String()}'
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


  String thirdStopName = "stop_3";

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
        '$thirdStopName',
        'ghi street',
        '3',
        '',
        '',
        '30',
        '${firstDeliveryNumber}'
     )
     """);
  print("inserted stop : $thirdStopName");


  //inert matrixs

  await txn.rawInsert("""
      INSERT INTO ${Matrix.getTableName()}(
      ${Matrix.cDeliveryNumber},
      ${Matrix.cName},
      ${Matrix.cLength},
      ${Matrix.cDuration}
      ) VALUES 
        ('$firstDeliveryNumber','$BASE_NAME-$firstStopName',50000,20),
        ('$firstDeliveryNumber','$BASE_NAME-$secondStopName',55000,40),
        ('$firstDeliveryNumber','$firstStopName-$BASE_NAME',48000,50),
        ('$firstDeliveryNumber','$secondStopName-$BASE_NAME',53000,36),
        ('$firstDeliveryNumber','$firstStopName-$secondStopName',20000,20),
        ('$firstDeliveryNumber','$secondStopName-$firstStopName',20000,20),
        ('$firstDeliveryNumber','$BASE_NAME-$thirdStopName',123,40),
        ('$firstDeliveryNumber','$firstStopName-$thirdStopName',123,50),
        ('$firstDeliveryNumber','$secondStopName-$thirdStopName',123,60),
        ('$firstDeliveryNumber','$thirdStopName-$BASE_NAME',123,70),
        ('$firstDeliveryNumber','$thirdStopName-$firstStopName',123,80),
        ('$firstDeliveryNumber','$thirdStopName-$secondStopName',123,90)
     """);
  });
}

void seedData3() async{
  db = await getDatabase();

  if(NEW_DATABASE_EVERY_RUN){
    String path = await getDatabasesPath();
    await deleteDatabase(path + DATABASE_FILE_NAME);
    db = null;
    db = await getDatabase();
  }

  String firstDeliveryNumber = "TEST55555";
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
     '${DateTime.now().add(const Duration(minutes: 0)).toIso8601String()}'
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


    String thirdStopName = "stop_3";

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
        '$thirdStopName',
        'ghi street',
        '3',
        '',
        '',
        '30',
        '${firstDeliveryNumber}'
     )
     """);
    print("inserted stop : $thirdStopName");

    String fourthStop = "stop_4";

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
        '$fourthStop',
        'jkl street',
        '4',
        '',
        '',
        '40',
        '${firstDeliveryNumber}'
     )
     """);
    print("inserted stop : $fourthStop");

    String fifthStop = "stop_5";

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
        '$fifthStop',
        'mno street',
        '5',
        '',
        '',
        '50',
        '${firstDeliveryNumber}'
     )
     """);
    print("inserted stop : $fifthStop");


    //inert matrixs

    await txn.rawInsert("""
      INSERT INTO ${Matrix.getTableName()}(
      ${Matrix.cDeliveryNumber},
      ${Matrix.cName},
      ${Matrix.cLength},
      ${Matrix.cDuration}
      ) VALUES 
        ('$firstDeliveryNumber','$BASE_NAME-$firstStopName',50000,20),
        ('$firstDeliveryNumber','$BASE_NAME-$secondStopName',55000,40),
        ('$firstDeliveryNumber','$firstStopName-$BASE_NAME',48000,50),
        ('$firstDeliveryNumber','$secondStopName-$BASE_NAME',53000,36),
        ('$firstDeliveryNumber','$firstStopName-$secondStopName',20000,20),
        ('$firstDeliveryNumber','$secondStopName-$firstStopName',20000,20),
        ('$firstDeliveryNumber','$BASE_NAME-$thirdStopName',123,40),
        ('$firstDeliveryNumber','$firstStopName-$thirdStopName',123,50),
        ('$firstDeliveryNumber','$secondStopName-$thirdStopName',123,60),
        ('$firstDeliveryNumber','$thirdStopName-$BASE_NAME',123,70),
        ('$firstDeliveryNumber','$thirdStopName-$firstStopName',123,80),
        ('$firstDeliveryNumber','$thirdStopName-$secondStopName',123,90),
        
        ('$firstDeliveryNumber','$BASE_NAME-$fourthStop',123,10),
        ('$firstDeliveryNumber','$firstStopName-$fourthStop',123,70),
        ('$firstDeliveryNumber','$secondStopName-$fourthStop',123,30),
        ('$firstDeliveryNumber','$thirdStopName-$fourthStop',123,30),
        
        ('$firstDeliveryNumber','$fourthStop-$BASE_NAME',123,80),
        ('$firstDeliveryNumber','$fourthStop-$firstStopName',123,190),
        ('$firstDeliveryNumber','$fourthStop-$secondStopName',123,10),
        ('$firstDeliveryNumber','$fourthStop-$thirdStopName',123,80),
        
        ('$firstDeliveryNumber','$BASE_NAME-$fifthStop',123,10),
        ('$firstDeliveryNumber','$firstStopName-$fifthStop',123,50),
        ('$firstDeliveryNumber','$secondStopName-$fifthStop',123,40),
        ('$firstDeliveryNumber','$thirdStopName-$fifthStop',123,10),
        ('$firstDeliveryNumber','$fourthStop-$fifthStop',123,20),
        
        ('$firstDeliveryNumber','$fifthStop-$BASE_NAME',123,10),
        ('$firstDeliveryNumber','$fifthStop-$firstStopName',123,20),
        ('$firstDeliveryNumber','$fifthStop-$secondStopName',123,30),
        ('$firstDeliveryNumber','$fifthStop-$thirdStopName',123,40),
        ('$firstDeliveryNumber','$fifthStop-$fourthStop',123,50)
     """);
  });
}

 void seedDatabase() async{
  seedData1();
  seedData2();
  seedData3();
}