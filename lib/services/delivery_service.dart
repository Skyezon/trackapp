import 'package:android/env.dart';
import 'package:intl/intl.dart';

import '../data/delivery.dart';

class DeliveryService{

  static Future<bool> isDeliveryExists(String input)async {
    var delivery = await Delivery.get(input);

   if(delivery != null){
     return true;
   }
   return false;
  }

  static Future<Delivery?> getDelivery(String input) async{
    var delivery = await Delivery.get(input);
    return delivery;
  }

  static String printStartTimeBasedOnSystemTime(Delivery deliveryData){
    return DateFormat.Hm().format(getRealizedStartingTime(deliveryData));
  }

  static DateTime getRealizedStartingTime(Delivery deliveryData){
    if (deliveryData.startTime != null){
      return deliveryData.startTime!;
    }
   if (systemTime.isAfter(deliveryData.plannedStartTime)){
     //late
     return systemTime;
   }else{
     return deliveryData.plannedStartTime;
   }
  }

}