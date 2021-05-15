import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class AppUtils {
  static final AppUtils _singleton = AppUtils._internal();
  AppUtils._internal();
  factory AppUtils() {
    return _singleton;
  }
  BuildContext context;
  //BuildContext mainContext=AppUtils().routeObserver.navigator.context;

  final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();


}
