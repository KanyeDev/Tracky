
import 'package:flutter/material.dart';

class MyDataTimePicker{


  Future<String> selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );
    if (picked != null) {

        return  picked.toString().split(" ")[0];
    }

    return "";
  }

  Future<String> selectTime(BuildContext context) async {
    TimeOfDay? picked =
    await showTimePicker(
        context: context, initialTime: TimeOfDay.now());

    if (picked != null) {

        return  "${picked.hour}:${picked.minute}";

    }

    return "";

  }

}