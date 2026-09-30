import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:minimal_furniture_app/presentation/screens/cart_screen.dart';
import 'package:minimal_furniture_app/presentation/screens/home_screen.dart';
import 'package:minimal_furniture_app/presentation/screens/product_detail_screen.dart';

import '../presentation/screens/main_menu_page.dart';

GoRouter router = GoRouter(
    initialLocation: NamedRoutes.home.routeName,
    routes: [
      StatefulShellRoute.indexedStack(
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: NamedRoutes.home.routeName, builder: (_, state) => const HomeScreen(),),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: NamedRoutes.menu.routeName, builder: (_, state) => Center(child: Text("Menu"),)),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: NamedRoutes.cart.routeName, builder: (_, state) => const CartScreen(),),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: NamedRoutes.like.routeName, builder: (_, state) => Center(child: Text("Favorite"),)),
          ]),
        ],
        builder: (ctx, state, navigationShell) => MainMenuPage(navigationShell: navigationShell),
      ),
      GoRoute(
        path: '${NamedRoutes.productDetail.routeName}/:id',
        builder: (_, state) => ProductDetailScreen(productId: state.pathParameters['id']!,),
      ),
    ],
);

enum NamedRoutes {
  home('/home'),
  menu('/menu'),
  cart('/cart'),
  like('/like'),
  productDetail('/product')
  ;

  final String routeName;
  const NamedRoutes(this.routeName);
}
