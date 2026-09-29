import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:minimal_furniture_app/constants/string_const.dart';
import 'package:minimal_furniture_app/core/app_colors.dart';
import 'package:minimal_furniture_app/core/app_data.dart';
import 'package:minimal_furniture_app/core/app_textstyles.dart';
import 'package:minimal_furniture_app/core/asset_res.dart';
import 'package:minimal_furniture_app/core/models/product.dart';
import 'package:minimal_furniture_app/presentation/widgets/new_badge.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _horizontalPadding = 20.0;
  static const _offerCardWidth = 257.0;
  static const _offerCardHeight = 367.0;
  static const _offerCardGap = 20.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Padding(
              padding: .fromLTRB(_horizontalPadding, 16, _horizontalPadding, 0),
              child: Column(
                crossAxisAlignment: .start,
                spacing: 17,
                children: [
                  _buildHeaderRow(),
                  SizedBox(
                    width: 218,
                    child: Text(StringConst.homeHeadline, style: AppTextStyles.heroTitleStyle,),
                  ),
                  _buildSearchFilterRow(),
                  Text(StringConst.bestOffer, style: AppTextStyles.sectionTitleStyle,),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(child: _buildOfferCarousel(),),
          ],
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
            child: SvgPicture.asset(AssetRes.icDrawerMenu, height: 17, width: 20, colorFilter: .mode(AppColors.blackColor, .srcIn),),
          ),
        ),
        const Spacer(),
        ClipOval(
          child: Image.asset(AssetRes.profileAvatar, width: 53, height: 53, fit: .cover,),
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
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.searchFieldColor,
              borderRadius: .circular(42),
            ),
            padding: .fromLTRB(20, 0, 16, 0),
            child: Row(
              spacing: 10,
              children: [
                SvgPicture.asset(AssetRes.icSearch, height: 18, width: 18, colorFilter: .mode(AppColors.searchHintColor, .srcIn),),
                Text(StringConst.searchHint, style: AppTextStyles.searchHintStyle,),
              ],
            ),
          ),
        ),
        Material(
          color: AppColors.cardDarkColor,
          borderRadius: .circular(10),
          child: InkWell(
            onTap: () {},
            borderRadius: .circular(10),
            child: SizedBox(
              width: 52,
              height: 52,
              child: Center(
                child: SvgPicture.asset(AssetRes.icFilter, height: 16, width: 21, colorFilter: .mode(AppColors.whiteColor, .srcIn),),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOfferCarousel() {
    return ListView.separated(
      padding: .fromLTRB(_horizontalPadding, 0, _horizontalPadding, 16),
      scrollDirection: .horizontal,
      itemCount: AppData.products.length,
      separatorBuilder: (context, index) => const SizedBox(width: _offerCardGap,),
      itemBuilder: (context, index) => _buildHomeOfferCard(context, product: AppData.products[index],),
    );
  }

  Widget _buildHomeOfferCard(BuildContext context, {required Product product}) {
    return GestureDetector(
      onTap: () => context.push('/product/${product.id}'),
      child: SizedBox(
      width: _offerCardWidth,
      height: _offerCardHeight,
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
                color: AppColors.whiteColor,
                borderRadius: .circular(18),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.blackColor.withValues(alpha: 0.1),
                    blurRadius: 40,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 28,
            child: SizedBox(
              width: 190,
              height: 243,
              child: Image.asset(product.image, fit: .contain, alignment: .bottomCenter,),
            ),
          ),
          Positioned(
            top: 254,
            left: 8,
            child: _buildOfferCardFooter(product: product,),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildOfferCardFooter({required Product product}) {
    return SizedBox(
      width: 241,
      height: 101,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.cardDarkColor,
              borderRadius: .circular(11),
            ),
          ),
          Positioned(
            left: 20,
            top: 15,
            child: Column(
              crossAxisAlignment: .start,
              spacing: 4,
              children: [
                if (product.isNew) const NewBadge(),
                Text(product.name, style: AppTextStyles.offerCardNameStyle,),
                Text('\$${product.price.toStringAsFixed(1)}', style: AppTextStyles.offerCardPriceStyle,),
              ],
            ),
          ),
          Positioned(
            right: 8,
            top: 27,
            child: _buildOfferCartButton(onTap: () {},),
          ),
        ],
      ),
    );
  }

  Widget _buildOfferCartButton({required VoidCallback onTap}) {
    return Material(
      color: AppColors.offerCartButtonColor,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 53,
          height: 53,
          child: Center(
            child: SvgPicture.asset(AssetRes.icCartMenu, height: 23, width: 23, colorFilter: .mode(AppColors.whiteColor, .srcIn),),
          ),
        ),
      ),
    );
  }
}
