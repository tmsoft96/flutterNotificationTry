import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:try_notification_2/constants/route_name.dart';
import 'package:try_notification_2/secondScreen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case SecondScreenViewRoute:
      var postToEdit = settings.arguments;
      print("5555555555555555555555555555555555555555");
      print(postToEdit);
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: SecondScreen(json.encode(postToEdit)),
      );
    default:
      return MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Center(
            child: Text('No route defined for ${settings.name}'),
          ),
        ),
      );
  }
}

PageRoute _getPageRoute({String routeName, Widget viewToShow}) {
  return MaterialPageRoute(
      settings: RouteSettings(name: routeName), builder: (_) => viewToShow);
}
