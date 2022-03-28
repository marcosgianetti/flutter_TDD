import 'package:flutter/material.dart';

void showErrorMessage(BuildContext context, {@required String mensage}) {
  Scaffold.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.red.shade900,
      content: Text(
        mensage,
        textAlign: TextAlign.center,
      ),
    ),
  );
}
