import 'package:android/data/database.dart';

class Matrix {

  static const String tableName = "matrixs";

  //column name
  static const String cName = "name";
  static const String cLength = "length";
  static const String cDuration = "duration";
  static const String cDeliveryNumber = "delivery_number";

  String deliveryNumber;
  String name;
  int length;
  int duration;

  static String getTableName(){
    return tableName;
  }

  Map <String,Object?> toMap(){
    var map = <String,Object?>{
      cDeliveryNumber : deliveryNumber,
      cName : name,
      cLength : length,
      cDuration : duration
    };
    return map;
  }

  Matrix.fromMap(Map<String,Object?> map):
    deliveryNumber = map[cDeliveryNumber] as String,
    name = map[cName] as String,
    length = map[cLength] as int,
    duration = map[cDuration] as int;

  static Future<Matrix?> get(String name, String deliveryNumber) async {
    var db = await getDatabase();
    var maps = await db!.query(Matrix.getTableName(),
    where: "${Matrix.cName} = ? and ${Matrix.cDeliveryNumber} = ?",
      whereArgs: [name, deliveryNumber]
    );
    if (maps.length >0){
      return Matrix.fromMap(maps.first);
    }else{
      return null;
    }
  }
}
