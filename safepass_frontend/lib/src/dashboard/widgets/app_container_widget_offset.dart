import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:safepass_frontend/common/const/kcolors.dart';
import 'package:safepass_frontend/common/const/kconstants.dart';
import 'package:safepass_frontend/common/const/app_theme/app_text_styles.dart';

class AppIconCardWidget extends StatefulWidget {
  final String svgAssetPath;
  final String label;
  final VoidCallback? onTap;

  const AppIconCardWidget({
    super.key,
    required this.svgAssetPath,
    required this.label,
    this.onTap,
  });

  @override
  State<AppIconCardWidget> createState() => _AppIconCardWidgetState();
}

class _AppIconCardWidgetState extends State<AppIconCardWidget> {
  bool _isHovered = false;
  bool _isPressed = false;

  void _updateHover(bool hovered) {
    setState(() {
      _isHovered = hovered;
    });
  }

  void _updatePressed(bool pressed) {
    setState(() {
      _isPressed = pressed;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isActive = _isHovered || _isPressed;
    final bgColor = isActive ? AppColors.kDarkBlue : AppColors.kWhite;
    final iconColor = isActive ? Colors.white : AppColors.kDarkBlue;
    final textColor = isActive ? Colors.white : AppColors.kDark;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _updateHover(true),
      onExit: (_) => _updateHover(false),
      child: GestureDetector(
        onTapDown: (_) => _updatePressed(true),
        onTapUp: (_) => _updatePressed(false),
        onTapCancel: () => _updatePressed(false),
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 350,
          height: 160,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: AppConstants.kAppBorderRadius,
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(255, 238, 232, 232),
                blurRadius: 12,
                offset: Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  widget.svgAssetPath,
                  width: 32,
                  height: 32,
                  colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                ),
                const SizedBox(width: 32),
                Flexible(
                  child: Text(
                    widget.label,
                    style: AppTextStyles.bigStyle.copyWith(
                      fontWeight: FontWeight.w700,
                      color: textColor,
                      fontSize: 20,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
