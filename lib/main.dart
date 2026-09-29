import 'package:flutter/material.dart';
import 'package:minimal_furniture_app/constants/string_const.dart';
import 'package:minimal_furniture_app/core/app_colors.dart';
import 'package:minimal_furniture_app/routing/router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        title: StringConst.appTitle,
        theme: ThemeData(
          brightness: .light,
          fontFamily: StringConst.appFontFamily,
          scaffoldBackgroundColor: AppColors.scaffoldBgColor
        ),
      routerConfig: router,
      builder: (ctx, child) => child!,
    );
  }
}

