import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

class DatetimeTimestampConverter implements JsonConverter<DateTime, Timestamp> {
  const DatetimeTimestampConverter();

  @override
  DateTime fromJson(Timestamp timestamp) {
    return timestamp.toDate();
  }

  @override
  Timestamp toJson(
    DateTime date,
  ) {
    final utcDate = date.toUtc();
    log("message: 'utcDate: $utcDate");
    return Timestamp.fromDate(utcDate);
  }
}

class DatetimeTimestampNullableConverter
    implements JsonConverter<DateTime?, Timestamp?> {
  const DatetimeTimestampNullableConverter();

  @override
  DateTime? fromJson(Timestamp? timestamp) {
    return timestamp == null ? null : timestamp.toDate();
  }

  @override
  Timestamp? toJson(DateTime? date, {bool? stringDate}) {
    return date == null ? null : Timestamp.fromDate(date);
  }
}
