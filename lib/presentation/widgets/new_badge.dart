import 'package:flutter/material.dart';
import 'package:minimal_furniture_app/core/app_colors.dart';
import 'package:minimal_furniture_app/core/app_textstyles.dart';

class NewBadge extends StatelessWidget {
  const NewBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.newBadgeColor,
        borderRadius: .circular(32),
      ),
      padding: .symmetric(horizontal: 11, vertical: 4),
      child: Text('New', style: AppTextStyles.badgeStyle,),
    );
  }
}
