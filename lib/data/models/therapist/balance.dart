import 'package:flutter/foundation.dart';

class Balance {
  final BalanceAmount balance;
  final List<Transaction> transactions;

  Balance(this.balance, this.transactions);
}

class BalanceAmount {
  final usd;
  final egp;

  BalanceAmount({
    @required this.usd,
    @required this.egp,
  });

  factory BalanceAmount.fromJson(Map<String, dynamic> json) {
    return BalanceAmount(usd: json['usd'], egp: json['egp']);
  }
}

class Transaction {
  final id;
  final String amount;
  final String currency;
  final String transferred;
  final String doctorId;
  final String chargeId;
  final String createdAt;

  Transaction({
    @required this.id,
    @required this.amount,
    @required this.currency,
    @required this.transferred,
    @required this.doctorId,
    @required this.chargeId,
    @required this.createdAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      amount: json['amount'],
      currency: json['currency'],
      transferred: json['transferred'],
      doctorId: json['doctor_id'],
      chargeId: json['charge_id'],
      createdAt: json['created_at'],
    );
  }
}
