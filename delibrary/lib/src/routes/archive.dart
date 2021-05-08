import 'package:delibrary/src/components/custom-app-bar.dart';
import 'package:delibrary/src/components/page-title.dart';
import 'package:delibrary/src/components/section-container.dart';
import 'package:delibrary/src/controller/internal/exchange-services.dart';
import 'package:delibrary/src/model/primary/exchange-list.dart';
import 'package:delibrary/src/model/session.dart';
import 'package:delibrary/src/shortcuts/padded-list-view.dart';
import 'package:delibrary/src/shortcuts/refreshable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ArchivePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {
  final ExchangeServices _exchangeServices = ExchangeServices();

  @override
  void initState() {
    super.initState();
    _downloadLists();
  }

  Future<void> _downloadLists() async {
    _exchangeServices.updateSession(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Refreshable(
        onRefresh: _downloadLists,
        child: PaddedListView(
          children: [
            PageTitle("I tuoi scambi archiviati"),
            ExchangesSectionContainer(
              title: "Rifiutati",
              provider: (context) =>
                  context.select<Session, ExchangeList>((s) => s.refused),
            ),
            ExchangesSectionContainer(
              title: "Completati",
              provider: (context) =>
                  context.select<Session, ExchangeList>((s) => s.happened),
            ),
          ],
        ),
      ),
    );
  }
}
