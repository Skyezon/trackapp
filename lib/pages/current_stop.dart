import 'package:android/const/strings.dart';
import 'package:flutter/material.dart';

class CurrentDelivery extends StatefulWidget {
  const CurrentDelivery({super.key});

  @override
  State<CurrentDelivery> createState() => _CurrentDeliveryState();
}

class _CurrentDeliveryState extends State<CurrentDelivery> {
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
                      Text("Current stop name"),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text("Address"),
                      ),
                      Text("Time window")
                    ],
                  ),
                  Column(
                    children: [
                      Text("Next stop name"),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text("Address"),
                      ),
                      Text("Time window")
                    ],
                  )
                ],
              )),
          Expanded(
              child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {}, child: Text("Finish current stop")),
                SizedBox(height: 16),
                ElevatedButton(onPressed: () {}, child: Text("Reorder stops"))
              ],
            ),
          ))
        ],
      ),
    );
  }
}
