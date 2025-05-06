import 'package:flutter/material.dart';

class AppGlobalKeys {
  static final GlobalKey<NavigatorState> navigator = GlobalKey<NavigatorState>();  
  static final GlobalKey<ScaffoldState> drawer = GlobalKey<ScaffoldState>();
  
  static final GlobalKey<FormState> login = GlobalKey<FormState>();
}