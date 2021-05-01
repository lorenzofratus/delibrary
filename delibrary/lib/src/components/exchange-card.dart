import 'package:delibrary/src/model/exchange.dart';
import 'package:delibrary/src/routes/exchange-info.dart';
import 'package:flutter/material.dart';

class ExchangeCard extends StatelessWidget {
  final Exchange exchange;

  ExchangeCard({@required this.exchange});

  void _tappedExchange(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExchangeInfoPage(
          exchange: exchange,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (exchange == null) return null;
    return Card(
      margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: InkWell(
        onTap: () => _tappedExchange(context),
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Row(
            children: [
              _BookImage(
                image: exchange.myBookImage,
                title: "Cedi",
              ),
              Spacer(),
              Flexible(
                flex: 2,
                fit: FlexFit.tight,
                child: FittedBox(
                  child: Icon(
                    Icons.swap_horiz,
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ),
              Spacer(),
              _BookImage(
                image: exchange.otherBookImage,
                title: "Ricevi",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ExchangeCardPreview extends StatelessWidget {
  final Exchange exchange;

  ExchangeCardPreview({@required this.exchange});

  void _tappedExchange(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExchangeInfoPage(
          exchange: exchange,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (exchange == null) return null;
    return InkWell(
      onTap: () => _tappedExchange(context),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: exchange.isBuyer
                  ? exchange.otherBookImage
                  : exchange.myBookImage,
            ),
          ),
          FloatingActionButton(
            heroTag: null,
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Theme.of(context).accentColor,
            onPressed: null,
            child: Icon(exchange.isBuyer ? Icons.login : Icons.logout),
            mini: true,
          ),
        ],
      ),
    );
  }
}

class _BookImage extends StatelessWidget {
  final String title;
  final Widget image;

  _BookImage({@required this.image, this.title = ""});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 3,
      fit: FlexFit.tight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline6.copyWith(
                  color: Theme.of(context).accentColor,
                ),
          ),
          SizedBox(height: 10.0),
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: image,
          ),
        ],
      ),
    );
  }
}
