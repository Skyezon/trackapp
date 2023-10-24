import 'package:android/components/stop_list_item.dart';
import 'package:android/const/strings.dart';
import 'package:android/data/delivery.dart';
import 'package:android/data/stop.dart';
import 'package:android/pages/current_stop.dart';
import 'package:android/services/delivery_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StopList extends StatefulWidget {
  final String selectedDeliveryNumber;

  const StopList({super.key, required this.selectedDeliveryNumber});

  @override
  State<StopList> createState() => _StopListState();
}

class _StopListState extends State<StopList> {
  late final Future<Delivery?> _deliveryData;

  _navigateCurrentStop(AsyncSnapshot<Delivery?> snapshot) async {
    if (!snapshot.hasData){
      return;
    }
    List<Stop>? stopList = await snapshot.data!.getStops();
    if (stopList == null){
      return;
    }
    stopList.sort((a,b) => a.stopIndex.compareTo(b.stopIndex));

    Stop selFirst = stopList.firstWhere((element) => (element.stopStartTime == null || element.stopEndTime == null));
    if(selFirst.stopIndex == stopList.length){
      //last one
      if (context.mounted){
        Navigator.push(context, MaterialPageRoute(builder: (context) => CurrentDelivery(currentStop: selFirst, nextStop: null,deliveryData: snapshot.data!)));
      }
      return;
    }
    //bring the next one
    Stop selNext = stopList.firstWhere((element) => (element.stopIndex == (selFirst.stopIndex + 1)));
    if (context.mounted){
      Navigator.push(context, MaterialPageRoute(builder: (context) => CurrentDelivery(currentStop: selFirst, nextStop: selNext, deliveryData: snapshot.data!)));
    }
  }

  @override
  void initState() {
    //get delivery & stop data
    _deliveryData = DeliveryService.getDelivery(widget.selectedDeliveryNumber);
    super.initState();
  }

  _updateFromItemList(){
    //changes order of the stop;
    setState(() {

    });
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
                FutureBuilder(future: snapshot.data!.getStops(), builder:
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
                      onReorder: (oldIndex, newIndex) {

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
                          Text(DeliveryService.printStartTimeBasedOnSystemTime(snapshot.data!))
                        ],
                      ),
                      children: <StopListItem>[
                        for(var stop in snapshotStop!.data!)
                          StopListItem(data: stop,deliveryData: snapshot.data!, refreshList: _updateFromItemList)
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
                          //TODO : if last stop then change text
                          child: FIRST_DELIVERY_TEXT)),
                )
              ]));
        });
  }
}
