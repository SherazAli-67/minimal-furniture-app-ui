import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
        items: [
          buildBottomNavigationBarItem(icon: AssetRes.icHome, label: '', index: 0),
          buildBottomNavigationBarItem(icon: AssetRes.icMenu, label: '', index: 1),
          buildBottomNavigationBarItem(icon: AssetRes.icCart, label: '', isHome: true, index: 2),
          buildBottomNavigationBarItem(icon: AssetRes.icLike, label: '', index: 3),
        ],
      ),
      body: navigationShell,
    );
  }

  BottomNavigationBarItem buildBottomNavigationBarItem({required String icon, required String label, bool isHome = false, required int index}) {
    bool isSelected = index == navigationShell.currentIndex;
    return  BottomNavigationBarItem(
      icon: isHome ?  Container(
        width: 55,
        height: 55,
        decoration: BoxDecoration(
          color: AppColors.primaryDark,
          shape: .circle,
          border: .all(color: AppColors.primaryColor, width: 2),
        ),
        alignment: .center,
        child: SvgPicture.asset(AppIcons.icHome, width: 28, height: 28, colorFilter: .mode(AppColors.whiteColor, .srcIn),),
      ) : SvgPicture.asset(icon, colorFilter: .mode(isSelected ? AppColors.primaryColor : AppColors.unSelectedItemColor, .srcIn),),
      label: label,
    );
  }
}