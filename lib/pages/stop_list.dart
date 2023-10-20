import 'package:android/components/stop_list_item.dart';
import 'package:android/const/strings.dart';
import 'package:android/pages/current_stop.dart';
import 'package:flutter/material.dart';

class StopList extends StatefulWidget {
  const StopList({super.key});

  @override
  State<StopList> createState() => _StopListState();
}

class _StopListState extends State<StopList> {
  final List<int> _items = List<int>.generate(50, (int index) => index);

  _navigateCurrentStop(){
      Navigator.push(context, MaterialPageRoute(builder: (context) => CurrentDelivery()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: LOGO,
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        children: [
          Expanded(
            flex:6,
            child: ReorderableListView(
              padding: EdgeInsets.symmetric(vertical: 16),
              shrinkWrap: true,
              onReorder: (oldIndex,newIndex){
                setState(() {
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }
                  final int item = _items.removeAt(oldIndex);
                  _items.insert(newIndex, item);
                });
                //TODO : reupdate time window inside list
              },
              header: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("Delivery Number",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Text("Delivery Date")
                ],
              ),
              children: <Widget>[
                for (int index = 0; index < 10; index += 1)
                  StopListItem(key: ValueKey(index))
              ],
            ),
          ),
          Expanded(
            flex: 1,
              child:
              Container(
                padding: EdgeInsets.symmetric(vertical: 24),
               child: ElevatedButton(onPressed: _navigateCurrentStop,
                   //TODO : if last stop then change text
                   child: FIRST_DELIVERY_TEXT
               )
              ),
              )

        ],
      )
    );
  }
}
