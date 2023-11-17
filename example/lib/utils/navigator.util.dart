import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigatorUtil {
  replacePage(BuildContext context, Widget screenToNavigateTo ) {
    Route route = MaterialPageRoute(builder: (context) => screenToNavigateTo);
    Navigator.pushReplacement(context, route);
  }
}