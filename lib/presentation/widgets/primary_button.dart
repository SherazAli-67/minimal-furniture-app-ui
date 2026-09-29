import 'package:flutter/material.dart';
import 'package:minimal_furniture_app/core/app_colors.dart';
import 'package:minimal_furniture_app/core/app_textstyles.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onTap,
    this.light = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool light;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = light ? AppColors.whiteColor : AppColors.blackColor;
    final textStyle = light ? AppTextStyles.buttonStyle : AppTextStyles.buttonLightStyle;
    return Material(
      color: backgroundColor,
      borderRadius: .circular(28),
      child: InkWell(
        onTap: onTap,
        borderRadius: .circular(28),
        child: Container(
          alignment: .center,
          height: 56,
          padding: .symmetric(horizontal: 24),
          child: Text(label, style: textStyle,),
        ),
      ),
    );
  }
}
