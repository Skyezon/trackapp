import 'dart:async';

import 'package:android/components/stop_list_item.dart';
import 'package:android/const/strings.dart';
import 'package:android/data/delivery.dart';
import 'package:android/data/stop.dart';
import 'package:android/env.dart';
import 'package:android/pages/current_stop.dart';
import 'package:android/pages/search.dart';
import 'package:android/services/delivery_service.dart';
import 'package:android/services/stop_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StopList extends StatefulWidget {
  final String selectedDeliveryNumber;

  const StopList({super.key, required this.selectedDeliveryNumber});

  @override
  State<StopList> createState() => _StopListState();
}

class _StopListState extends State<StopList> {
   Future<Delivery?> _deliveryData = Future(() => null);
   Timer _timer = Timer(Duration(),(){});
   Future<List<Stop>> _stopDataList = Future(() => []);
   String _startTime = "";
   bool _isSnackbarShown = false;

  _navigateCurrentStop(AsyncSnapshot<Delivery?> snapshot) async {
    if (!snapshot.hasData){
      return;
    }
   if(snapshot.data!.finishTime != null){
     //means delivery completed and if button push will go back to search delivery number;
     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Search()));
   }

   if (snapshot.data!.startTime == null){
     DeliveryService.startDelivery(snapshot.data!);
   }


    List<Stop>? stopList = await snapshot.data!.getStops();
    if (stopList == null){
      return;
    }
    stopList.sort((a,b) => a.stopIndex.compareTo(b.stopIndex));

    Stop selFirst = stopList.firstWhere((element) => (element.stopStartTime == null || element.stopEndTime == null));

    if(selFirst.stopIndex == stopList.length){
      //last one
      await StopService.startCurrentStopDelivery(selFirst);
      if (context.mounted){
        await Navigator.push(context, MaterialPageRoute(builder: (context) => CurrentDelivery(currentStop: selFirst, nextStop: null,deliveryData: snapshot.data!)));
        _refreshList();
      }
      return;
    }
    //bring the next one
    Stop selNext = stopList.firstWhere((element) => (element.stopIndex == (selFirst.stopIndex + 1)));
    await StopService.startCurrentStopDelivery(selFirst);
    if (context.mounted){
      await Navigator.push(context, MaterialPageRoute(builder: (context) => CurrentDelivery(currentStop: selFirst, nextStop: selNext, deliveryData: snapshot.data! )));
      _refreshList();
    }
  }

  @override
  void initState() {
    _refreshList();
    _timer = Timer.periodic(REALTIME_REFRESH_DURATION, (Timer t) {
      if(mounted){
        _refreshList();
      }
    });
  }


  _refreshList()async {
    final _newDeliveryData = await DeliveryService.getDelivery(widget.selectedDeliveryNumber);
    final _newGetStopData = await _newDeliveryData!.getStops();
    final _newStartTime = await DeliveryService.printStartTimeBasedOnSystemTime(_newDeliveryData);
    if (mounted){
      setState(() {
        _deliveryData = Future.value(_newDeliveryData);
        _stopDataList = Future.value(_newGetStopData);
        _startTime = _newStartTime;
      }); 
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    var myAppbar = AppBar(
      title: LOGO,
      centerTitle: true,
      backgroundColor: Theme
          .of(context)
          .colorScheme
          .primary,
    );
    return FutureBuilder(
        future: _deliveryData,
        builder: (context, AsyncSnapshot<Delivery?> snapshot) {
          if (!snapshot!.hasData) {
            return Scaffold(
              appBar: myAppbar,
              body: const Center(child: CircularProgressIndicator()),
            );
          }
          return Scaffold(
              appBar: myAppbar,
              body: Column(children: [
                FutureBuilder(future: _stopDataList, builder:
                    (context, AsyncSnapshot<List<Stop>?> snapshotStop) {
                  if (!snapshotStop.hasData){
                    return const Expanded(flex: 6,child: Center(child: CircularProgressIndicator()));
                  }
                  //order Stop list by stopIndex
                  snapshotStop.data!.sort((a,b) => a.stopIndex.compareTo(b.stopIndex));
                  return Expanded(
                    flex: 6,
                    child: ReorderableListView(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shrinkWrap: true,
                      onReorder: (oldIndex, newIndex) async{
                        oldIndex++;
                        newIndex++;
                       var res = await StopService.stackingOrderUpdate(snapshotStop.data!, oldIndex, newIndex);
                       if (res != null){
                         if (context.mounted){
                           if (!_isSnackbarShown){
                             ScaffoldMessenger.of(context).showSnackBar(res).closed.then((value) => _isSnackbarShown = false);
                           }
                         }
                         return;
                       }
                        _refreshList();
                      },
                      header: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            widget.selectedDeliveryNumber,
                            style: Theme
                                .of(context)
                                .textTheme
                                .headlineSmall,
                          ),
                          Text(_startTime)
                        ],
                      ),
                      children: <StopListItem>[
                        for(var stop in snapshotStop!.data!)
                          StopListItem(data: stop,deliveryData: snapshot.data!, refreshList: _refreshList)
                      ],
                    ),
                  );
                }
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: ElevatedButton(
                          onPressed: () => _navigateCurrentStop(snapshot),
                          child: ((){
                            if (snapshot.data!.startTime == null){
                              return FIRST_DELIVERY_TEXT;
                            }else{
                              if (snapshot.data!.finishTime == null){
                                return WHILE_DELIVERY_TEXT;
                              }else{
                                return BACK_TO_SEARCH_TEXT;
                              }
                            }
                          }())
                      )
                  ),
                ),
                SizedBox(height: 48)
              ]));
        });
  }
}
