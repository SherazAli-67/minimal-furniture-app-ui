import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:minimal_furniture_app/core/app_colors.dart';
import 'package:minimal_furniture_app/core/app_textstyles.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({
    super.key,
    this.title,
    this.leadingIconPath,
    this.onLeadingTap,
    this.trailing,
    this.light = false,
  });

  final String? title;
  final String? leadingIconPath;
  final VoidCallback? onLeadingTap;
  final Widget? trailing;
  final bool light;

  @override
  Widget build(BuildContext context) {
    final titleStyle = light ? AppTextStyles.screenTitleLightStyle : AppTextStyles.screenTitleStyle;
    final leadingIconColor = light ? AppColors.blackColor : AppColors.blackColor;
    final buttonFill = light ? AppColors.whiteColor : AppColors.whiteColor;
    return Row(
      children: [
        if (leadingIconPath != null)
          _HeaderIconButton(
            iconPath: leadingIconPath!,
            iconColor: leadingIconColor,
            backgroundColor: buttonFill,
            onTap: onLeadingTap,
          ),
        if (title != null) ...[
          Expanded(
            child: Text(title!, style: titleStyle, textAlign: .center,),
          ),
        ] else
          const Spacer(),
        if (trailing != null)
          trailing!
        else if (title != null)
          SizedBox(width: 48, height: 48,),
      ],
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({
    required this.iconPath,
    required this.iconColor,
    required this.backgroundColor,
    this.onTap,
  });

  final String iconPath;
  final Color iconColor;
  final Color backgroundColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 48,
          height: 48,
          child: Center(
            child: SvgPicture.asset(iconPath, height: 22, colorFilter: .mode(iconColor, .srcIn),),
          ),
        ),
      ),
    );
  }
}
