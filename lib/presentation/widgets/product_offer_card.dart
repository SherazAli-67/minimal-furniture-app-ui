import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:minimal_furniture_app/core/app_colors.dart';
import 'package:minimal_furniture_app/core/app_textstyles.dart';
import 'package:minimal_furniture_app/core/asset_res.dart';
import 'package:minimal_furniture_app/core/models/product.dart';
import 'package:minimal_furniture_app/presentation/widgets/new_badge.dart';

class ProductOfferCard extends StatelessWidget {
  const ProductOfferCard({
    super.key,
    required this.product,
    this.onTap,
    this.onAddToCart,
  });

  final Product product;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.whiteColor,
      borderRadius: .circular(24),
      clipBehavior: .antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            _buildImageSection(),
            _buildInfoSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Container(
      color: AppColors.whiteColor,
      height: 180,
      padding: .all(16),
      child: Image.asset(product.image, fit: .contain,),
    );
  }

  Widget _buildInfoSection() {
    return Container(
      color: AppColors.cardDarkColor,
      padding: .fromLTRB(16, 16, 12, 16),
      child: Row(
        crossAxisAlignment: .start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              spacing: 8,
              children: [
                if (product.isNew) const NewBadge(),
                Text(product.name, style: AppTextStyles.productNameStyle,),
                Text('\$${product.price.toStringAsFixed(1)}', style: AppTextStyles.priceStyle,),
              ],
            ),
          ),
          _buildCartButton(),
        ],
      ),
    );
  }

  Widget _buildCartButton() {
    return Material(
      color: AppColors.whiteColor,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onAddToCart,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 44,
          height: 44,
          child: Center(
            child: SvgPicture.asset(AssetRes.icCartMenu, height: 20, colorFilter: .mode(AppColors.blackColor, .srcIn),),
          ),
        ),
      ),
    );
  }
}
