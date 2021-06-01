import 'dart:math';

import 'package:flutter/material.dart';
import 'package:layout/layout.dart';

class PaddedGrid extends StatelessWidget {
  final ScrollController controller;
  final List<Widget> leading;
  final List<Widget> children;
  final bool grid;
  final double maxWidth;

  PaddedGrid({
    this.controller,
    this.leading,
    this.children,
    this.grid = true,
    this.maxWidth = double.infinity,
  });

  final double pad = 40.0;

  @override
  Widget build(BuildContext context) {
    final double lPad =
        max((MediaQuery.of(context).size.width - maxWidth) / 2, pad);

    final int count = context.layout.value(xs: 1, sm: 2, md: 3);
    final EdgeInsets leadingPadding = context.layout.value(
      xs: EdgeInsets.only(left: pad, right: pad, top: pad),
      sm: EdgeInsets.only(left: pad * 1.5, right: pad * 1.5, top: pad * 2),
    );
    final EdgeInsets childrenPadding = context.layout.value(
      xs: EdgeInsets.only(left: lPad, right: lPad, bottom: pad),
    );

    return CustomScrollView(
      controller: controller,
      slivers: [
        if ((leading?.length ?? 0) > 0)
          SliverPadding(
            padding: leadingPadding,
            sliver: SliverList(
              delegate: SliverChildListDelegate(leading),
            ),
          ),
        if ((children?.length ?? 0) > 0)
          SliverPadding(
            padding: childrenPadding,
            sliver: grid
                ? SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 0.95,
                      crossAxisCount: count,
                      crossAxisSpacing: 40.0,
                    ),
                    delegate: SliverChildListDelegate(children),
                  )
                : SliverList(
                    delegate: SliverChildListDelegate(children),
                  ),
          ),
      ],
    );
  }
}
