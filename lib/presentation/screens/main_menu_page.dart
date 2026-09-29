import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:minimal_furniture_app/core/app_textstyles.dart';
import 'package:minimal_furniture_app/core/asset_res.dart';
import '../../core/app_colors.dart';

class MainMenuPage extends StatelessWidget {
  const MainMenuPage({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: .fixed,
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(index),
        backgroundColor: AppColors.whiteColor,
        selectedItemColor: AppColors.blackColor,
        unselectedItemColor: AppColors.unSelectedItemColor,
        selectedLabelStyle: AppTextStyles.labelStyle.copyWith(color: Colors.black),
        unselectedLabelStyle: AppTextStyles.labelStyle.copyWith(color: AppColors.unSelectedItemColor),
        items: [
          buildBottomNavigationBarItem(icon: AssetRes.icHome, label: 'Home', index: 0),
          buildBottomNavigationBarItem(icon: AssetRes.icMenu, label: 'Menu', index: 1),
          buildBottomNavigationBarItem(icon: AssetRes.icCart, label: 'Cart', index: 2),
          buildBottomNavigationBarItem(icon: AssetRes.icLike, label: 'Like', index: 3),
        ],
      ),
      body: navigationShell,
    );
  }

  BottomNavigationBarItem buildBottomNavigationBarItem({required String icon, required String label, bool isHome = false, required int index}) {
    bool isSelected = index == navigationShell.currentIndex;
    return  BottomNavigationBarItem(
      icon: SvgPicture.asset(icon, height: 24, fit: .cover, colorFilter: .mode(isSelected ? AppColors.blackColor : AppColors.unSelectedItemColor, .srcIn),),
      label: label,
    );
  }
}