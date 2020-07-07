import 'package:flutter/material.dart';

class Transaction {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final String designation;
  final num phoneNo;

  Transaction({
    @required this.id,
    @required this.title,
    @required this.amount,
    @required this.date,
    @required this.designation,
    @required this.phoneNo,
  });
}
