import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StopListItem extends StatefulWidget {
  final Key key;


  const StopListItem({required this.key}) : super(key:key);

  @override
  State<StopListItem> createState() => _StopListItemState();
}

class _StopListItemState extends State<StopListItem> {

  _increaseOrder(){

  }

  _decreaseOrder(){

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal:0, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            flex: 1,
            child:  Icon(
              Icons.radio_button_off,
              color: Colors.red,
              size: 24,
            ),
          ),
         Expanded(
           flex: 4,
           child: Column(
           children: [
             Row(
               children: [
                 Expanded(child: Text("Stop name",
                 style: Theme.of(context).textTheme.bodyLarge,
                 )),
                 Text("Time window")
               ],
             ),
             const SizedBox(height: 12,),
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Text("Address"),
               ],
             )
           ],
         ),
         ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment:MainAxisAlignment.spaceAround ,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_circle_up),
                  iconSize: 32,
                  onPressed: _decreaseOrder,
                ),
                IconButton(
                    onPressed: _increaseOrder,
                    iconSize: 32,
                    icon: Icon(Icons.arrow_circle_down))
              ],
            ),
          )
        ],
      ),
    );
  }
}
