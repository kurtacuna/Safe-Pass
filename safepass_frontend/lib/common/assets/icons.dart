// Defined paths of all icons

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:safepass_frontend/common/const/kcolors.dart';

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
  static Widget get dashboardIcon => SvgPicture.asset(
    'assets/images/dashboard.svg',
    width: 26,
    height: 26,
    colorFilter: ColorFilter.mode(AppColors.kDarkBlue, BlendMode.srcIn),
  );

  static Widget get logsIcon => SvgPicture.asset(
    'assets/images/logs.svg',
    width: 26,
    height: 26,
    colorFilter: ColorFilter.mode(AppColors.kDarkBlue, BlendMode.srcIn),
  );

  static Widget get settingsIcon => SvgPicture.asset(
    'assets/images/settings.svg',
    width: 26,
    height: 26,
    colorFilter: ColorFilter.mode(AppColors.kDarkBlue, BlendMode.srcIn),
  );

  static Widget dashboardIconWithColor(bool isSelected) => SvgPicture.asset(
    'assets/images/dashboard.svg',
    width: 26,
    height: 26,
    colorFilter: ColorFilter.mode(
      isSelected ? Colors.white : AppColors.kDarkBlue,
      BlendMode.srcIn
    ),
  );

  static Widget logsIconWithColor(bool isSelected) => SvgPicture.asset(
    'assets/images/logs.svg',
    width: 26,
    height: 26,
    colorFilter: ColorFilter.mode(
      isSelected ? Colors.white : AppColors.kDarkBlue,
      BlendMode.srcIn
    ),
  );

  static Widget settingsIconWithColor(bool isSelected) => SvgPicture.asset(
    'assets/images/settings.svg',
    width: 26,
    height: 26,
    colorFilter: ColorFilter.mode(
      isSelected ? Colors.white : AppColors.kDarkBlue,
      BlendMode.srcIn
    ),
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