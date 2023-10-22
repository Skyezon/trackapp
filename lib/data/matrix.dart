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


}
