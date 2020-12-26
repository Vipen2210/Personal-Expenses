import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class Transaction {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  Transaction(
      {@required this.amount,
      @required this.date,
      @required this.id,
      @required this.title});
}
