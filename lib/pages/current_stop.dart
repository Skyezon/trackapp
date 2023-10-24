import 'package:android/const/strings.dart';
import 'package:android/data/delivery.dart';
import 'package:android/services/stop_service.dart';
import 'package:flutter/material.dart';

import '../data/stop.dart';

class CurrentDelivery extends StatefulWidget {
  final Stop currentStop;
  final Delivery deliveryData;
  final Stop? nextStop;
  CurrentDelivery({super.key, required this.currentStop, required this.nextStop, required this.deliveryData});

  @override
  State<CurrentDelivery> createState() => _CurrentDeliveryState();
}

class _CurrentDeliveryState extends State<CurrentDelivery> {

  String tw1 = "";
  String tw2 = "";

  @override
  void initState() {
    _getRequiredData();
    super.initState();
  }

  _getRequiredData() async {
    var temp1 = await StopService.getTimeWindow(widget.currentStop, widget.deliveryData);
    if (widget.nextStop  == null){
      setState(() {
        tw1 = temp1;
      });
      return;
    }
    var temp2 = await StopService.getTimeWindow(widget.nextStop!, widget.deliveryData);
    setState(() {
      tw1 = temp1;
      tw2 = temp2;
    });
  }

  @override
  void didUpdateWidget(covariant CurrentDelivery oldWidget) {
    _getRequiredData();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: LOGO,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(widget.currentStop.name),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(widget.currentStop.address),
                      ),
                      Text(tw1)
                    ],
                  ),
        (() {
          if (widget.nextStop != null){
            return  Column(
              children: [
                Text(widget.nextStop!.name),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(widget.nextStop!.address),
                ),
                Text(tw2)
              ],
            );
          }
          return const SizedBox.shrink();
        }())

                ],
              )),
          Expanded(
              child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ((){
                  if(widget.nextStop == null){
                    return SizedBox.shrink();
                  }
                  return ElevatedButton(
                      onPressed: () {
                        //end current stop and go back
                        Navigator.pop(context);
                      }, child: FINISH_CURRENT_STOP_BUTTON_TEXT);
                }())
                ,
                const SizedBox(height: 16),
                ElevatedButton(onPressed: () {
                  if (widget.nextStop == null){
                    //end current stop
                   //finish delivery
                  }
                  Navigator.pop(context);
                  }, child: widget.nextStop == null ? FINISH_FINAL_STOP_BUTTON_TEXT: REORDER_BUTTON_TEXT)
              ],
            ),
          ))
        ],
      ),
    );
  }
}
