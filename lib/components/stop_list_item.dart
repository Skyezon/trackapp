import 'dart:async';

import 'package:android/data/stop.dart';
import 'package:android/env.dart';
import 'package:android/services/stop_service.dart';
import 'package:flutter/material.dart';

import '../data/delivery.dart';

class StopListItem extends StatefulWidget {
  final Key key;
  final Stop data;
  final Delivery deliveryData;
  final Function refreshList;

  StopListItem({required this.data,required this.deliveryData, required this.refreshList }): key = ValueKey(data.id);

  @override
  State<StopListItem> createState() => _StopListItemState();
}

class _StopListItemState extends State<StopListItem> {
  late String timeWindow = "";
  late Timer _timer;

  bool _isSnackbarShowen = false;

  _increaseOrder(Stop stopData) async {
    int indexAfter = stopData.stopIndex + 1;
    List<Stop>? stops = await widget.deliveryData.getStops();
    if (indexAfter > stops!.length){
      //error out of bound;
      print('user is trying to change order out of bound, just ignore');
      return;
    }
    SnackBar? res = await StopService.switchOrder(stopData.stopIndex, indexAfter, stopData.deliveryNumber);
    if (res != null){
      //error
      _showErrorSnackBar(res);
    }
     widget.refreshList();
  }

  _showErrorSnackBar(res){
    print("ongoing delivery tried to change");
    if (context.mounted && !_isSnackbarShowen){
      _isSnackbarShowen = true;
      ScaffoldMessenger.of(context).showSnackBar(res).closed.then((value) => _isSnackbarShowen = false);
    }
  }

  _decreaseOrder(Stop stopData) async {
    int indexBefore = stopData.stopIndex -1;
    if (indexBefore <= 0){
      //error out of bound
      print('user is trying to change order out of bound, just ignore');
      return;
    }
    SnackBar? res = await StopService.switchOrder(stopData.stopIndex, indexBefore, stopData.deliveryNumber);
    if (res != null){
      //error
      _showErrorSnackBar(res);
    }
     widget.refreshList();
  }

  _getRequiredData() async{
    var tempTimewindow = await StopService.getTimeWindow(widget.data, widget.deliveryData);
    setState(() {
      timeWindow = tempTimewindow;
    });
  }

  @override
  void initState() {
    _getRequiredData();
    _timer = Timer.periodic(REALTIME_REFRESH_DURATION, (timer) => mounted? _getRequiredData(): null);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _getRequiredData();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  bool _isFinished(){
    return (widget.data.stopEndTime != null);
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            flex: 1,
            child:  Icon(
              Icons.radio_button_off,
              color: _isFinished() ? Colors.green : Colors.red,
              size: 24,
            ),
          ),
          Expanded(
            flex: 4,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Text(
                      widget.data.name,
                      style: Theme.of(context).textTheme.bodyLarge,
                    )),
                    Text(timeWindow)
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.data.address),
                  ],
                )
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_circle_up),
                  iconSize: 32,
                  onPressed: () => _decreaseOrder(widget.data),
                ),
                IconButton(
                    onPressed: () => _increaseOrder(widget.data),
                    iconSize: 32,
                    icon: const Icon(Icons.arrow_circle_down))
              ],
            ),
          )
        ],
      ),
    );
  }
}
