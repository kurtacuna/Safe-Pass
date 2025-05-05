// Defined paths of all icons

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

// Variable name is the same as font name:
    //
    // AntDesign
    // Entypo
    // EvilIcons
    // Feather
    // FontAwesome
    // Foundation
    // Ionicons
    // MaterialCommunityIcons
    // MaterialIcons
    // Octicons
    // SimpleLineIcons
    // Zocial
    // FontAwesome5Brands
    // FontAwesome5Regular
    // FontAwesome5Solid

class AppIcons {
  static Icon get chartIcon => Icon(
    Icons.bar_chart
  );
  static Icon get menuIcon => Icon(
    Icons.menu
  );
  static Icon get kEmailIcon => Icon(
    Ionicons.mail
  );
  static Icon get kPasswordIcon => Icon(
    Icons.perm_identity,
  );
  static Icon get kCloseEyeIcon => Icon(
    Ionicons.eye_off
  );
  static Icon get kOpenEyeIcon => Icon(
    Ionicons.eye
  );
}