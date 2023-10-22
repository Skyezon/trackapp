import '../data/delivery.dart';

class DeliveryService{

  static bool isDeliveryExists(String input){
   var delivery = Delivery.get(input);
   if(delivery != null){
     return true;
   }
   return false;
  }

}