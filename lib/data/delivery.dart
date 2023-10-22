
import 'package:android/data/database.dart';
import 'package:android/data/matrix.dart';
import 'package:android/data/stop.dart';

class Delivery {
  static const String tableName = "deliveries";

  //c = Column name
  static const String cDeliveryNumber = "delivery_number";
  static const String cStartTime = "start_time";
  static const String cFinishTime = "finish_time";
  static const String cPlannedStartTime = "planned_start_time";

   String deliveryNumber;
   DateTime? startTime;
   DateTime? finishTime;
   DateTime plannedStartTime;
   List<Stop>? stops;
   List<Matrix>? matrixs;


   Map<String, Object?> toMap(){
     var map = <String,Object?>{
       cDeliveryNumber: deliveryNumber,
       cStartTime : startTime?.toIso8601String(),
       cFinishTime : finishTime?.toIso8601String(),
       cPlannedStartTime : plannedStartTime.toIso8601String(),
     };

     return map;
   }

   Delivery.fromMap(Map<String, Object?> map):
     deliveryNumber = map[cDeliveryNumber] as String,
     startTime = map[cStartTime] as DateTime,
     finishTime = map[cFinishTime] as DateTime,
     plannedStartTime = map[cPlannedStartTime] as DateTime;


  static String getTableName() {
    return tableName;
  }

  Future<List<Stop>?> getStops() async{
    /*
     if (stops != null){
       return stops;
     }
     */
     stops = [];
     //query stops
     db = await getDatabase();
     List<Map> maps = await db!.query(Stop.getTableName(),
     where: '${Stop.cDeliveryNumber} = $deliveryNumber'
     );
     if (maps.length > 0){
       maps.forEach((element) { 
         maps.forEach((element) {
          stops!.add(Stop.fromMap(element as Map<String, Object?>));
         });
       });
     }
     return stops;
  }

  Future<List<Matrix>?> getMatrixs() async{
    /*
    if (matrixs != null){
      return matrixs;
    }
     */
    matrixs = [];
    //query matrixs
    db = await getDatabase();
    List<Map> maps = await db!.query(Matrix.getTableName(),
      where: '${Matrix.cDeliveryNumber} = $deliveryNumber'
    );
    if (maps.length > 0){
      maps.forEach(( element) {
        matrixs!.add(Matrix.fromMap(element as Map<String,Object?>));
      });
    }
    return matrixs;
  }

  static Future<Delivery?> get(String input) async{
    db = await getDatabase();
    List <Map> maps = await db!.query(getTableName(),
    where: '$cDeliveryNumber = ?',
        whereArgs: [input]
    );
    if (maps.length > 0){
      return Delivery.fromMap(maps.first as Map<String,Object?>);
    }
    return null;
  }
}
