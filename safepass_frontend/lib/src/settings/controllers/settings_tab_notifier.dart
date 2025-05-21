import 'package:flutter/material.dart';

class SettingsTabNotifier with ChangeNotifier {
  int _tabIndex = 1;
  int get getTabIndex => _tabIndex;
  set setTabIndex(int index) {
    _tabIndex = index;
    notifyListeners();
  }
}