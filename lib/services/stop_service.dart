
import 'dart:developer';

import 'package:android/const/strings.dart';
import 'package:android/data/delivery.dart';
import 'package:android/data/stop.dart';
import 'package:android/env.dart';
import 'package:intl/intl.dart';

import '../data/matrix.dart';

class StopService{

  static Future<DateTime?> getExpectedStopFinishTime(Stop stopData, Delivery deliveryData) async{
    DateTime? eta = await getEta(stopData, deliveryData);
    if (eta == null){
      return null;
    }
    String? originDestination = await getOriginToDestinationName(stopData);
    if (originDestination == null){
      return null;
    }

    eta = eta.add(Duration(minutes: stopData.unloadingTime));

    /*
    if (systemTime.isAfter(eta)){
      eta = systemTime;
    }

     */
    return eta;
  }

  static Future<String?> getOriginToDestinationName(Stop stopData) async{
    String originName = "";
    String destinationName = stopData.name;
    if (stopData.stopIndex <= 1){
      originName = BASE_NAME;
    }else{
      Stop? stopDataBeforeIndex = await Stop.getStopByIndex(stopData.stopIndex -1, stopData.deliveryNumber);
      if (stopDataBeforeIndex == null){
        return null;
      }
      originName = stopDataBeforeIndex.name;
    }
    return "$originName-$destinationName";
  }

  static Future<DateTime?> getStartingTime(Stop stopData, Delivery deliveryData) async{
    DateTime startingDateTime;
    if (stopData.stopStartTime != null){
      startingDateTime = stopData.stopStartTime!;
    }else{
      if (stopData.stopIndex <= 1){
        //DateTime selectedDateTime = deliveryData.plannedStartTime.isBefore(systemTime) ? systemTime : deliveryData.plannedStartTime;
        DateTime selectedDateTime = deliveryData.plannedStartTime;
        startingDateTime = selectedDateTime;
        startingDateTime = startingDateTime.add(Duration(minutes: OVERHEAD_STARTING_TIME_MINUTE));
        return startingDateTime;
      }else{
        Stop? stopDataBefore = await Stop.getStopByIndex(stopData.stopIndex -1, stopData.deliveryNumber);
        if (stopDataBefore == null){
          return null;
        }
        DateTime? expectedStopFinishTimeBefore = await getExpectedStopFinishTime(stopDataBefore, deliveryData);
        if (expectedStopFinishTimeBefore == null){
          return null;
        }

        if (systemTime.isAfter(expectedStopFinishTimeBefore)){
         expectedStopFinishTimeBefore = getNewExpectedStopFinishTime();
        }
       startingDateTime = expectedStopFinishTimeBefore;
        return startingDateTime;
      }
    }
  }

  static Future<DateTime?> getEta(Stop stopData, Delivery deliveryData) async{
    if (stopData.stopEndTime != null){
      return stopData.stopEndTime;
    }

    DateTime? startingDateTime = await getStartingTime(stopData,deliveryData);
    if (startingDateTime == null){
      return null;
    }

    String? originDestination = await getOriginToDestinationName(stopData);
    if (originDestination == null){
      return null;
    }
    Matrix? matrix = await Matrix.getByName(originDestination);
   if (matrix == null){
     return null;
   }

   DateTime etaDatetime = DateTime.fromMillisecondsSinceEpoch(startingDateTime.millisecondsSinceEpoch);
    etaDatetime = etaDatetime.add(Duration(minutes: matrix.duration)) ;

    return etaDatetime;
  }

  static Future<DateTime?> getRoundedETA(Stop stopData, Delivery deliveryData)async {
    DateTime? etaDatetime = await getEta(stopData,deliveryData);
    if (etaDatetime == null){
      return null;
    }
    return roundingMinutes(etaDatetime);
  }

  static DateTime getNewETA(Stop stopData){
    return systemTime.subtract(Duration(minutes: stopData.unloadingTime));
  }

  static DateTime getRoundedNewETA(Stop stopData){
    return roundingMinutes(getNewETA(stopData));
  }

  static DateTime getNewExpectedStopFinishTime(){
    return systemTime;
  }

  static DateTime roundingMinutes(DateTime dateTime) {

    int minutes = dateTime.minute;

    int remainder = minutes % 5;

    if (remainder >= 3) {
      minutes = minutes - remainder + 5;
      if (minutes == 60) {
        minutes = 0;
        dateTime = dateTime.add(Duration(hours: 1));
      }
    } else {
      minutes = minutes - remainder;
    }

    return DateTime(dateTime.year, dateTime.month, dateTime.day, dateTime.hour, minutes);

  }

  static Future<String> getTimeWindow(Stop stopData, Delivery deliveryData) async {
    var expectedStopTime = await getExpectedStopFinishTime(stopData, deliveryData);
    if (expectedStopTime == null){
      return "ERROR";
    }
    DateTime res;
    if (systemTime.isAfter(expectedStopTime)){
      //New ETA
      res = getRoundedNewETA(stopData);
    }else{
      var temp = await getRoundedETA(stopData,deliveryData);
      if (temp == null){
        return "ERROR";
      }
      res = temp;
    }

    const Duration durationSpec = Duration(minutes: 15);
    return'${DateFormat.Hm().format(res.copyWith().subtract(durationSpec))} - ${DateFormat.Hm().format(res.copyWith().add(durationSpec))}';
    //return '${DateFormat.Hm().format(res)}';

  }

  static Future<void> switchOrder(int index1, index2, String deliveryNumber) async{
    var stop1 = await Stop.getStopByIndex(index1, deliveryNumber);
    var stop2 = await Stop.getStopByIndex(index2, deliveryNumber);

    if (!isValidToChangeOrder(stop1) || !isValidToChangeOrder(stop2)){
      print("invalid order change: one or both stop is still on progress");
      return;
    }

    await Stop.updateOrder(stop1!.id, stop2!.stopIndex);
    await Stop.updateOrder(stop2!.id, stop1!.stopIndex);
  }

  static bool isValidToChangeOrder(Stop? stopData) {
    if (stopData == null){
      return false;
    }
    if (stopData.stopStartTime != null || stopData.stopEndTime != null){
      return false;
    }
    return true;
  }

}