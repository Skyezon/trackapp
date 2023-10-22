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
      cStopStartTime : stopStartTime,
      cStopEndTime : stopEndTime,
      cUnloadingTime : unloadingTime,
      cDeliveryNumber : deliveryNumber
    };
    return map;
  }

  Stop.fromMap(Map<String, Object?> map):
    id = map[cId] as int,
    name = map[cName] as String,
    address = map[cAddress] as String,
    stopIndex = map[cStopIndex] as int,
    stopStartTime = map[cStopStartTime] as DateTime,
    stopEndTime = map[cStopEndTime] as DateTime,
    unloadingTime = map[cUnloadingTime] as int,
    deliveryNumber = map[cDeliveryNumber] as String;

}
