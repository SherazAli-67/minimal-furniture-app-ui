import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:minimal_furniture_app/constants/number_constant.dart';
import 'package:minimal_furniture_app/constants/string_const.dart';
import 'package:minimal_furniture_app/core/app_colors.dart';
import 'package:minimal_furniture_app/core/app_data.dart';
import 'package:minimal_furniture_app/core/app_textstyles.dart';
import 'package:minimal_furniture_app/core/asset_res.dart';
import 'package:minimal_furniture_app/core/models/product.dart';
import 'package:minimal_furniture_app/presentation/widgets/new_badge.dart';
import 'package:minimal_furniture_app/routing/router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor,
      body: SafeArea(
        child: Padding(
          padding: .fromLTRB(NumberConstant.horizontalPadding, 16, NumberConstant.horizontalPadding, 0),
          child: Column(
            crossAxisAlignment: .start,
            spacing: 10,
            children: [
              Column(
                crossAxisAlignment: .start,
                spacing: 17,
                children: [
                  _buildHeaderRow(),
                  Row(
                    children: [
                      //homeHeadline, heroTitleStyle
                      Expanded(flex: 2, child: const SizedBox()),
                      Expanded(child: const SizedBox())
                    ],
                  ),
                  _buildSearchFilterRow(),
                  //bestOffer, sectionTitleStyle
                ],
              ),
              Expanded(child: _buildOfferCarousel(),),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderRow() {
    return Row(
      children: [
        InkWell(
          onTap: () {},
          borderRadius: .circular(8),
          child: Padding(
            padding: .all(8),
            //icDrawer
            child: const SizedBox()
          ),
        ),
        const Spacer(),
        ClipOval(child:
        //profileAvatar, width: 53, height: 53
         const SizedBox()
        ),
      ],
    );
  }

  Widget _buildSearchFilterRow() {
    return Row(
      spacing: 12,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              // color: AppColors.searchFieldColor,
              borderRadius: .circular(42),
            ),
            padding: .symmetric(horizontal: 20, vertical: 17),
            child: Row(
              spacing: 10,
              children: [
                //icSearch

                //searchHint, searchHintStyle
              ],
            ),
          ),
        ),
        Material(
          // color: AppColors.cardDarkColor,
          borderRadius: .circular(10),
          child: InkWell(
            onTap: () {},
            borderRadius: .circular(10),
            child: Padding(
              padding: .symmetric(horizontal: 15.5, vertical: 18),
              //icFilter
              child: const SizedBox()
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOfferCarousel() {
    return ListView.separated(
      padding: .only(bottom: 16),
      scrollDirection: .horizontal,
      itemCount: AppData.products.length,
      separatorBuilder: (context, index) => const SizedBox(width: NumberConstant.offerCardGap,),
      itemBuilder: (context, index) => _buildHomeOfferCard(context, product: AppData.products[index],),
    );
  }


  Widget _buildHomeOfferCard(BuildContext context, {required Product product}) {
    return GestureDetector(
      onTap: () => context.push('${NamedRoutes.productDetail.routeName}/${product.id}'),
      child: SizedBox(
        width: NumberConstant.offerCardWidth,
        height: NumberConstant.offerCardHeight,
        child: Stack(
          clipBehavior: .none,
          children: [
            Positioned(
              top: 33,
              left: 0,
              right: 0,
              child: Container(
                height: 330,
                decoration: BoxDecoration(
                  // color: AppColors.whiteColor,
                  borderRadius: .circular(18),
                  /*boxShadow: [
                    BoxShadow(
                      color: AppColors.blackColor.withValues(alpha: 0.1),
                      blurRadius: 40,
                      offset: const Offset(0, 4),
                    ),
                  ],*/
                ),
              ),
            ),
            Positioned(
              top: -10,
              left: 28,
              //product.image, height: 243, width: 190, alignment: bottomCenter, fit.cover
              child: const SizedBox()
            ),
            Positioned(
              bottom: 100,
              left: 8,
              right: 8,
              child: Container(
                decoration: BoxDecoration(
                  // color: AppColors.cardDarkColor,
                  borderRadius: .circular(11),
                ),
                padding: .symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: .start,
                      spacing: 4,
                      children: [
                        // if (product.isNew) const NewBadge(),
                        //product.name, offerCardNameStyle
                        //\$${product.price.toStringAsFixed(1)}, offerCardPrice
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        // color: AppColors.greyBgColor,
                        shape: .circle,
                      ),
                      padding: .all(15),
                      //icCartMenu, color: white
                      child: const SizedBox()
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
