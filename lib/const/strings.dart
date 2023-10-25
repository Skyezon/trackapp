import 'package:flutter/material.dart';

const LOGO = Text(
  "Logo",
  style: TextStyle(color: Colors.white),
);
const INPUT_DELIVERY_INSTRUCTION = "Please Input Delivery Number";
const FIRST_DELIVERY_TEXT = Text("Start Delivery");
const WHILE_DELIVERY_TEXT = Text("Submit Stop Order");
const BACK_TO_SEARCH_TEXT = Text("Back to search");

const DATABASE_FILE_NAME = "trackapp.db";

const BASE_NAME = "base";

const FINISH_CURRENT_STOP_BUTTON_TEXT = Text("Finish current stop");
const FINISH_FINAL_STOP_BUTTON_TEXT = Text("Finish Delivery");
const REORDER_BUTTON_TEXT = Text("Reorder stops");

//Error
const DATA_EMPTY_ERR = "Please fill the form";
const DATA_NOT_FOUND_ERR = "Data not found";
const INVALID_ORDER_CHANGE = "One of the stop have been started, cannot change order";
