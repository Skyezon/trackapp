import 'package:android/data/database.dart';
import 'package:android/env.dart';

class Stop {
  static const String tableName = "stops";

  //column name
  static const String cId = "id";
  static const String cName = "name";
  static const String cAddress = "address";
  static const String cStopIndex = "stop_index";
  static const String cStopStartTime = "stop_start_time";
  static const String cStopEndTime = "stop_end_time";
  static const String cDeliveryNumber = "delivery_number";
  static const String cUnloadingTime = "unloading_time";

  int id;
  String name;
  String address;
  int stopIndex;
  DateTime? stopStartTime;
  DateTime? stopEndTime;
  int unloadingTime;
  String deliveryNumber;

  static String getTableName() {
    return tableName;
  }

  Map<String, Object?> toMap(){
    var map = <String, Object?>{
      cId : id,
      cName : name,
      cAddress: address,
      cStopIndex : stopIndex,
      cStopStartTime : stopStartTime?.toIso8601String(),
      cStopEndTime : stopEndTime?.toIso8601String(),
      cUnloadingTime : unloadingTime,
      cDeliveryNumber : deliveryNumber
    };
    return map;
  }

  void setIndex(int newIndex){
   stopIndex = newIndex;
  }

  void setStartTime(DateTime newStartTime){
    stopStartTime = newStartTime;
  }

  void setFinishTime(DateTime newEndTime){
    stopEndTime = newEndTime;
  }

  Stop.fromMap(Map<String, Object?> map):
    id = map[cId] as int,
    name = map[cName] as String,
    address = map[cAddress] as String,
    stopIndex = map[cStopIndex] as int,
    stopStartTime = DateTime.tryParse(map[cStopStartTime].toString()),
    stopEndTime = DateTime.tryParse(map[cStopEndTime].toString()),
    unloadingTime = map[cUnloadingTime] as int,
    deliveryNumber = map[cDeliveryNumber] as String;

  static Future<Stop?> getStopByIndex(int index,String deliveryNumber) async {
    db = await getDatabase();
    var maps = await db!.query(Stop.getTableName(),
    where: "${Stop.cDeliveryNumber} = '$deliveryNumber' and ${Stop.cStopIndex} = ?",
      whereArgs: [index]
    );
    if (maps.length > 0){
      return Stop.fromMap(maps.first);
    }else{
      return null;
    }
  }


  static Future<Stop?> getById(int id) async{
   db = await getDatabase();
   var maps = await db!.query(Stop.getTableName(),
    where: "${Stop.cId} = ?",
   whereArgs: [id]
   );
   if (maps.length > 0){
     return Stop.fromMap(maps.first);
   }
   return null;
  }

  static Future<void> updateOrder(int id, int indexTo ) async {
    if (indexTo <=0){
      print("invalid index");
      return null;
    }
    db = await getDatabase();
    Stop? selStop = await getById(id);
    if (selStop == null){
      print("error selStop empty");
      return;
    }

    if (selStop.stopStartTime != null || selStop.stopEndTime != null){
      print("cannot change ongoing delivery stop");
      return;
    }
    selStop.setIndex(indexTo);

    await db!.update(Stop.getTableName(), selStop.toMap(),
    where: 'id = ?',
      whereArgs: [id]
    );
  }

  static Future<void> startCurrentStopDelivery(Stop stopData) async{
    if (stopData.stopStartTime != null){
      return;
    }
    stopData.setStartTime(systemTime);
    db = await getDatabase();
    await db!.update(Stop.getTableName(), stopData.toMap(),
    where: "${Stop.cId} = ${stopData.id}"
    );


  }

  static Future<void> endCurrentStopDelivery(Stop stopData) async{
    if (stopData.stopEndTime != null){
      return;
    }
    stopData.setFinishTime(systemTime);
    db = await getDatabase();
    await db!.update(Stop.getTableName(), stopData.toMap(),
    where: "${Stop.cId} = ${stopData.id}"
    );
  }


}
