import 'package:flutter/foundation.dart';

class SessionPriceResponse {
  final price;
  final currency;

  SessionPriceResponse({
    @required this.price,
    @required this.currency,
  });

  factory SessionPriceResponse.fromJson(Map<String, dynamic> json) {
    return SessionPriceResponse(
      price: json['price'],
      currency: json['currency'],
    );
  }
}
