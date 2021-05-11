import 'package:delibrary/src/components/utils/logo.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends AppBar {
  CustomAppBar()
      : super(
          title: DelibraryLogo(),
          centerTitle: true,
          bottomOpacity: 0.0,
          elevation: 0.0,
        );
}
