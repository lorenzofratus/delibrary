import 'package:delibrary/src/components/cards/exchange-card.dart';
import 'package:delibrary/src/controller/external/book-services.dart';
import 'package:delibrary/src/controller/internal/property-services.dart';
import 'package:delibrary/src/model/primary/book.dart';
import 'package:delibrary/src/model/primary/item.dart';
import 'package:delibrary/src/model/primary/user.dart';
import 'package:delibrary/src/model/secondary/property.dart';
import 'package:flutter/material.dart';

@immutable
class Exchange extends Item {
  final User buyer;
  final User seller;
  final Book property;
  final Book payment;
  final bool isBuyer;
  final ExchangeStatus status;

  static final AssetImage unknown = AssetImage("lib/assets/unknown.png");

  Exchange({
    id,
    this.buyer,
    this.seller,
    this.property,
    this.payment,
    this.status,
    this.isBuyer,
  }) : super(id: id);

  String get myUsername => isBuyer ? buyer.username : seller.username;
  String get otherUsername => isBuyer ? seller.username : buyer.username;
  String get otherEmail => isBuyer ? seller.email : buyer.email;
  Widget get myBookImage => _getImage(isBuyer ? payment : property);
  Widget get otherBookImage => _getImage(isBuyer ? property : payment);

  @override
  Widget get backgroundImage => otherBookImage;

  static Widget _getImage(Book book) {
    return book == null
        ? Image(
            image: unknown,
            fit: BoxFit.cover,
            height: 130.0,
          )
        : book.smallImage;
  }

  @override
  ExchangeCard getCard({
    bool preview = false,
    bool wished = false,
    bool showOwner = false,
    Exchange parent,
  }) =>
      ExchangeCard(
        exchange: this,
        preview: preview,
      );

  //TODO: needs revision
  bool involves(Book book) {
    if (book == null) return false;
    return book.match(property) || book.match(payment);
  }

  Exchange setStatus(ExchangeStatus newStatus) {
    return Exchange(
      id: id,
      buyer: buyer,
      seller: seller,
      property: property,
      payment: payment,
      status: newStatus ?? status,
      isBuyer: isBuyer,
    );
  }

  Exchange setPayment(Book newPayment) {
    if (payment != null || newPayment == null) return this;
    return Exchange(
      id: id,
      buyer: buyer,
      seller: seller,
      property: property,
      payment: newPayment,
      status: ExchangeStatus.agreed,
      isBuyer: isBuyer,
    );
  }

  static Future<Exchange> fromJsonProperty(
      Map<String, dynamic> json, bool isBuyer) async {
    PropertyServices propertyServices = PropertyServices();
    Book property = await propertyServices
        .getBookFromProperty(Property.fromJson(json['property']));
    Book payment = await propertyServices
        .getBookFromProperty(Property.fromJson(json['payment']));

    json['property'] = property;
    json['payment'] = payment;
    json['isBuyer'] = isBuyer;

    return Exchange.fromJson(json);
  }

  static Future<Exchange> fromJsonBook(
      Map<String, dynamic> json, bool isBuyer) async {
    BookServices bookServices = BookServices();

    Book property = await bookServices.getById(json['propertyBookId']);
    Book payment;
    if (json['paymentBookId'] != null)
      payment = await bookServices.getById(json['paymentBookId']);

    json['property'] = property;
    json['payment'] = payment;
    json['isBuyer'] = isBuyer;

    return Exchange.fromJson(json);
  }

  factory Exchange.fromJson(Map<String, dynamic> json) {
    return Exchange(
      id: json['id'].toString(),
      buyer: User.fromJson(json['buyer']),
      seller: User.fromJson(json['seller']),
      property: json['property'],
      payment: json['payment'],
      status: ExchangeStatus.from[json['status']],
      isBuyer: json['isBuyer'],
    );
  }
}

enum ExchangeStatus { from, proposed, agreed, refused, happened }

extension ExchangeStatusIndex on ExchangeStatus {
  operator [](String key) => (name) {
        switch (name) {
          case 'proposed':
            return ExchangeStatus.proposed;
          case 'agreed':
            return ExchangeStatus.agreed;
          case 'refused':
            return ExchangeStatus.refused;
          case 'happened':
            return ExchangeStatus.happened;
          default:
            throw RangeError("Stato dell'Exchange non valido.");
        }
      }(key);

  String get string {
    switch (this) {
      case ExchangeStatus.proposed:
        return "Scambio proposto";
      case ExchangeStatus.agreed:
        return "Scambio confermato";
      case ExchangeStatus.refused:
        return "Scambio rifiutato";
      case ExchangeStatus.happened:
        return "Scambio terminato";
      default:
        return "Scambio";
    }
  }

  String get description {
    //TODO: better descriptions PLEASE, maybe different for the two users
    switch (this) {
      case ExchangeStatus.proposed:
        return "Lo scambio rimarrà in attesa fino a che il proprietario del libro non sceglierà se accettare o rifiutare.";
      case ExchangeStatus.agreed:
        return "Gli utenti si sono accordati sui libri da scambiare, lo scambio dovrà avvenire all'esterno di Delibrary.";
      case ExchangeStatus.refused:
        return "Purtroppo lo scambio è stato rifiutato da uno dei due utenti.";
      case ExchangeStatus.happened:
        return "Lo scambio è avvenuto, i nuovi libri sono ora disponibili nelle rispettive librerie.";
      default:
        return "Scambio";
    }
  }
}
