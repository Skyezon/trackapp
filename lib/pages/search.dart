import 'package:android/const/strings.dart';
import 'package:android/data/delivery.dart';
import 'package:android/pages/stop_list.dart';
import 'package:android/services/delivery_service.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final _searchKey = GlobalKey<FormState>();

  String deliveryNumberInput = "";

  _navigateStopList() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) =>  StopList(selectedDeliveryNumber: deliveryNumberInput)));
  }

  String? _validator(value)  {
      //NOT PRIORITY : add snackbar if error becoz cool
      if (value == null || value.isEmpty  ) {
        return DATA_EMPTY_ERR;
      }
      setState(() {
       deliveryNumberInput = value.toUpperCase();
      });
      return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: LOGO,
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        body: Form(
          key: _searchKey,
          child: Column(
            children: [
              const Spacer(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  validator: _validator,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: INPUT_DELIVERY_INSTRUCTION),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 24),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(10.0)))),
                    child: const Text("Submit"),
                    onPressed: () async {
                      if (!_searchKey.currentState!.validate()) {
                        //TODO : pass variable from validator to next page
                        return;
                      }
                      bool res = await DeliveryService.isDeliveryExists(deliveryNumberInput);
                      if (!res){
                      ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text(DATA_NOT_FOUND_ERR)),
                      );
                        return;
                      }
                      _navigateStopList();
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 32,
              )
            ],
          ),
        ));
  }
}
