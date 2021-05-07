import 'package:delibrary/src/model/property.dart';
import 'package:flutter/material.dart';

@immutable
class TempExchange {
  final int id;
  final String buyerUsername;
  final String sellerUsername;
  final Property property;
  final Property payment;
  final String status;
  final bool isBuyer;

  TempExchange({
    this.id,
    this.buyerUsername,
    this.sellerUsername,
    this.property,
    this.payment,
    this.status,
    this.isBuyer,
  });

  factory TempExchange.fromJson(Map<String, dynamic> json, bool isBuyer) {
    return TempExchange(
      id: json['id'],
      buyerUsername: json['buyer'],
      sellerUsername: json['seller'],
      property: Property.fromJson(json['property']),
      payment:
          json['payment'] != null ? Property.fromJson(json['payment']) : null,
      status: json['status'],
      isBuyer: isBuyer,
    );
  }
}