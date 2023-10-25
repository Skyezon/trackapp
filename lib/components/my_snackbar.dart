import 'package:flutter/material.dart';

SnackBar Function(String text) ErrorSnackbar = (text) => SnackBar(
  content: Text(text),
  backgroundColor: Colors.red,
);
