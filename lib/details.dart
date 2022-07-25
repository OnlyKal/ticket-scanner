
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

messageError(msg){
  Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
}
messageSuccess(msg){
  Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor:const Color.fromARGB(255, 5, 148, 5),
        textColor: Colors.white,
        fontSize: 16.0
    );
}