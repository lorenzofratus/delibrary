import 'package:delibrary/src/model/property.dart';

class Exchange {
  final int id;
  final String buyerUsername;
  final String sellerUsername;
  final Property property;
  final Property payment;
  final String status;

  Exchange(
      {this.id,
      this.buyerUsername,
      this.sellerUsername,
      this.property,
      this.payment,
      this.status});

  factory Exchange.fromJson(Map<String, dynamic> json) {
    return Exchange(
        id: json['id'],
        buyerUsername: json['buyer'],
        sellerUsername: json['seller'],
        property: Property.fromJson(json['property']),
        payment:
            json['payment'] != null ? Property.fromJson(json['payment']) : null,
        status: json['status']);
  }
}
