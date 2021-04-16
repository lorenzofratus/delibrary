import 'package:flutter/material.dart';

import 'logo.dart';

class CustomAppBar extends AppBar {
  CustomAppBar()
      : super(
          title: DelibraryLogo(),
          centerTitle: true,
          bottomOpacity: 0.0,
          elevation: 0.0,
        );
}
