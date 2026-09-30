import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:minimal_furniture_app/core/models/product.dart';
import '../../core/app_colors.dart';
import '../../core/app_textstyles.dart';
import '../../routing/router.dart';

class RelatedProductCardItem extends StatelessWidget {
  const RelatedProductCardItem({
    super.key,
    required this.product
  });

  final Product product;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.scaffoldBgColor,
      borderRadius: .circular(14),
      clipBehavior: .antiAlias,
      child: InkWell(
        onTap: () => context.pushReplacement('${NamedRoutes.productDetail.routeName}/${product.id}'),
        child: Padding(
          padding: .symmetric(vertical: 3),
          child: Row(
            spacing: 6,
            children: [
              Image.asset(product.image, width: 61, height: 66, fit: .contain, alignment: .bottomCenter,),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  mainAxisAlignment: .center,
                  spacing: 6,
                  children: [
                    Text(product.name, style: AppTextStyles.detailRelatedNameStyle, maxLines: 1, overflow: .ellipsis,),
                    Text('\$${product.price.toStringAsFixed(1)}', style: AppTextStyles.detailRelatedPriceStyle,),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}