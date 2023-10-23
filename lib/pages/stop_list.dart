import 'package:android/components/stop_list_item.dart';
import 'package:android/const/strings.dart';
import 'package:android/data/delivery.dart';
import 'package:android/data/stop.dart';
import 'package:android/pages/current_stop.dart';
import 'package:android/services/delivery_service.dart';
import 'package:flutter/material.dart';

class StopList extends StatefulWidget {
  final String selectedDeliveryNumber;

  const StopList({super.key, required this.selectedDeliveryNumber});

  @override
  State<StopList> createState() => _StopListState();
}

class _StopListState extends State<StopList> {
  late final Future<Delivery?> _deliveryData;

  _navigateCurrentStop(AsyncSnapshot<Delivery?> snapshotStop) {
    if (!snapshotStop.hasData){
      //error
      return;
    }

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => CurrentDelivery()));
  }

  @override
  void initState() {
    //get delivery & stop data
    _deliveryData = DeliveryService.getDelivery(widget.selectedDeliveryNumber);
    super.initState();
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
                  return Expanded(
                    flex: 6,
                    child: ReorderableListView(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shrinkWrap: true,
                      onReorder: (oldIndex, newIndex) {
                        setState(() {
                          if (oldIndex < newIndex) {
                            newIndex -= 1;
                          }
                          final Stop item = snapshotStop.data!.removeAt(
                              oldIndex);
                          snapshotStop.data!.insert(newIndex, item);
                        });
                        //TODO : reupdate time window inside list
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
                          Text(snapshot!.data!.plannedStartTime.toIso8601String())
                        ],
                      ),
                      children: <StopListItem>[
                        for(var stop in snapshotStop!.data!)
                          StopListItem(data: stop,deliveryData: snapshot.data!)
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
