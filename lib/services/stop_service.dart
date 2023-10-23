
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
    String? originDestination = await getFromToName(stopData);
    if (originDestination == null){
      return null;
    }
    return eta.add(Duration(minutes: stopData.unloadingTime));
  }

  static Future<String?> getFromToName(Stop stopData) async{
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
        DateTime selectedDateTime = deliveryData.plannedStartTime.isBefore(systemTime) ? systemTime : deliveryData.plannedStartTime;
        startingDateTime = selectedDateTime;
        startingDateTime.add(Duration(minutes: OVERHEAD_STARTING_TIME_MINUTE));
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

    String? originDestination = await getFromToName(stopData);
    if (originDestination == null){
      return null;
    }
    Matrix? matrix = await Matrix.getByName(originDestination);
   if (matrix == null){
     return null;
   }

   DateTime etaDatetime = DateTime.fromMillisecondsSinceEpoch(startingDateTime.millisecondsSinceEpoch,isUtc: true);
    etaDatetime.add(Duration(minutes: matrix.duration)) ;

    return etaDatetime;
  }

  static Future<DateTime?> getRoundedETA(Stop stopData, Delivery deliveryData)async {
    DateTime? etaDatetime = await getEta(stopData,deliveryData);
    if (etaDatetime == null){
      return null;
    }
    return roundingMinutes(etaDatetime);
  }

  static DateTime roundingMinutes(DateTime date){
    final int remainder = date.minute % 5;
    final int minutesToAdd = 5 - remainder;
    final DateTime roundedDateTime = date.add(Duration(minutes: minutesToAdd));
    return DateTime(
      roundedDateTime.year,
      roundedDateTime.month,
      roundedDateTime.day,
      roundedDateTime.hour,
      roundedDateTime.minute,
    );
  }

  static Future<String> getTimeWindow(Stop stopData, Delivery deliveryData) async {
    var expectedStopTime = await getExpectedStopFinishTime(stopData, deliveryData);
    if (expectedStopTime == null){
      return "ERROR";
    }
    DateTime res;
    if (expectedStopTime.isBefore(systemTime)){
      //New ETA
      res = systemTime.subtract(Duration(minutes: stopData.unloadingTime));
      res = roundingMinutes(res);
    }else{
      var temp = await getRoundedETA(stopData,deliveryData);
      if (temp == null){
        return "ERROR";
      }
      res = temp;
      res.add(const Duration(minutes: 15));
    }
    return DateFormat.Hm().format(res);
  }

}