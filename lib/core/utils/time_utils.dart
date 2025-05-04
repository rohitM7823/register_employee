import 'package:flutter/material.dart';

extension TimeUtils on TimeOfDay {
  String get toTimeStamp {
    var date = DateTime.now();
    return DateTime(date.year, date.month, date.day, this.hour, this.minute)
        .toString();
  }

  DateTime get toDateTime {
    var date = DateTime.now();
    return DateTime(date.year, date.month, date.day, this.hour, this.minute);
  }
}


extension DateUtils on DateTime {
  TimeOfDay get toTimeOfDay {
    return TimeOfDay(hour: this!.hour, minute: this!.minute);
  }
}

