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

}