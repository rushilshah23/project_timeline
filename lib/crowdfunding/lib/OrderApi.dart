// To parse this JSON data, do
//
//     final orderApi = orderApiFromJson(jsonString);

import 'dart:convert';

OrderApi orderApiFromJson(String str) => OrderApi.fromJson(json.decode(str));

String orderApiToJson(OrderApi data) => json.encode(data.toJson());

class OrderApi {
  OrderApi({
    this.amount,
    this.currency,
    this.receipt,
  });

  int amount;
  String currency;
  String receipt;

  factory OrderApi.fromJson(Map<String, dynamic> json) => OrderApi(
    amount: json["amount"],
    currency: json["currency"],
    receipt: json["receipt"],
  );

  Map<String, dynamic> toJson() => {
    "amount": amount,
    "currency": currency,
    "receipt": receipt,
  };
}
