import 'package:flutter/material.dart';

class PasswordNotifier with ChangeNotifier {
  bool _obscurePassword = true;
  bool get getObscurePassword => _obscurePassword;
  set setObscurePassword(bool state) {
    _obscurePassword = state;
    notifyListeners();
  }
}