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
import 'package:minimal_furniture_app/core/providers/app_provider.dart';
import 'package:minimal_furniture_app/presentation/widgets/fade_slide_in.dart';
import 'package:minimal_furniture_app/presentation/widgets/related_card_item_widget.dart';
import 'package:minimal_furniture_app/presentation/widgets/scale_on_press.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key, required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context) {
    final product = AppData.productById(productId);
    if (product == null) {
      return Scaffold(
        backgroundColor: AppColors.cardDarkColor,
        body: Center(child: Text('Product not found', style: AppTextStyles.screenTitleLightStyle,),),
      );
    }
    final appProvider = context.watch<AppProvider>();
    final relatedProducts = AppData.productsExcept(product.id);
    return Scaffold(
      backgroundColor: AppColors.cardDarkColor,
      body: SafeArea(
        child: Padding(
          padding: .fromLTRB(NumberConstant.horizontalPadding, 16, NumberConstant.horizontalPadding, 16),
          child: Column(
            spacing: 16,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: .start,
                    spacing: NumberConstant.detailHeroToSwatchSpacing,
                    children: [
                      Column(
                        crossAxisAlignment: .start,
                        spacing: NumberConstant.detailHeaderToContentSpacing,
                        children: [
                          FadeSlideIn(child: _buildHeader(context),),
                          FadeSlideIn(
                            delay: NumberConstant.animStagger,
                            child: Column(
                              crossAxisAlignment: .start,
                              spacing: NumberConstant.detailBadgeToTitleSpacing,
                              children: [
                                if (product.isNew) _buildDetailNewBadge(),
                                _buildTitlePriceRow(product),
                              ],
                            ),
                          ),
                        ],
                      ),
                      _buildHeroSection(product),
                      FadeSlideIn(
                        delay: NumberConstant.animStagger * 2,
                        child: Column(
                          spacing: NumberConstant.detailSwatchToRelatedSpacing,
                          children: [
                            _buildColorSwatches(context, product, appProvider),
                            _buildRelatedProductsRow(relatedProducts),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              FadeSlideIn(
                delay: NumberConstant.animStagger * 3,
                child: _buildBottomActions(context, product, appProvider),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        _buildHeaderIconButton(iconPath: AssetRes.icArrowBack, onTap: () => context.pop(),),
        Text(StringConst.productDetail, style: AppTextStyles.screenTitleLightStyle,),
        _buildHeaderIconButton(iconPath: AssetRes.icMore, onTap: () {},),
      ],
    );
  }

  Widget _buildHeaderIconButton({required String iconPath, required VoidCallback onTap}) {
    return Material(
      color: AppColors.whiteColor,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: .all(15.5),
          child: SvgPicture.asset(iconPath, colorFilter: .mode(AppColors.blackColor, .srcIn),),
        ),
      ),
    );
  }

  Widget _buildDetailNewBadge() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.newBadgeColor,
        borderRadius: .circular(45),
      ),
      padding: .symmetric(horizontal: 15, vertical: 6),
      child: Text('New', style: AppTextStyles.detailBadgeStyle,),
    );
  }

  Widget _buildTitlePriceRow(Product product) {
    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        Flexible(child: Text(product.name, style: AppTextStyles.detailTitleRowStyle, overflow: .ellipsis,),),
        Text('\$${product.price.toStringAsFixed(1)}', style: AppTextStyles.detailTitleRowStyle,),
      ],
    );
  }

  Widget _buildHeroSection(Product product) {
    return SizedBox(
      height: NumberConstant.detailHeroHeight,
      width: double.infinity,
      child: Stack(
        alignment: .center,
        clipBehavior: .none,
        children: [
          Positioned(
            top: 0,
            child: Hero(
              tag: 'product-image-${product.id}',
              child: Image.asset(product.image, width: NumberConstant.detailHeroImageSize, height: NumberConstant.detailHeroImageSize, fit: .contain,),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 13,
            right: 13,
            child: FadeSlideIn(
              delay: NumberConstant.animStagger,
              child: SvgPicture.asset(AssetRes.icBottomLine),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorSwatches(BuildContext context, Product product, AppProvider appProvider) {
    final colors = product.colors.isNotEmpty ? product.colors : AppData.defaultColorOptions;
    final selectedColorIndex = appProvider.selectedColorIndex(product.id);
    return Center(
      child: Row(
        mainAxisSize: .min,
        spacing: NumberConstant.detailColorSwatchSpacing,
        children: List.generate(colors.length, (index) {
          final color = colors[index];
          final isSelected = index == selectedColorIndex;
          return GestureDetector(
            onTap: () => context.read<AppProvider>().selectColor(product.id, index),
            child: AnimatedContainer(
              duration: NumberConstant.animFast,
              curve: Curves.easeOutCubic,
              padding: .all(10),
              decoration: BoxDecoration(
                shape: .circle,
                color: color,
                border: isSelected ? .all(color: AppColors.secondaryTextColor, width: 4) : .all(color: Colors.transparent, width: 4),
                boxShadow: color == AppColors.whiteColor && !isSelected
                    ? [BoxShadow(color: AppColors.blackColor.withValues(alpha: 0.15), blurRadius: 2)]
                    : null,
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildRelatedProductsRow(List<Product> relatedProducts) {
    if (relatedProducts.isEmpty) return const SizedBox.shrink();
    final items = relatedProducts.length > 2 ? relatedProducts.sublist(0, 2) : relatedProducts;
    return Row(
      spacing: NumberConstant.detailRelatedGap,
      children: items.map((product) => Expanded(child: RelatedProductCardItem(product: product),)).toList(),
    );
  }

  Widget _buildBottomActions(BuildContext context, Product product, AppProvider appProvider) {
    final isFavorite = appProvider.isFavorite(product.id);
    return Row(
      spacing: NumberConstant.detailBottomActionSpacing,
      children: [
        Expanded(
          child: ScaleOnPress(
            onTap: () => context.read<AppProvider>().addToCart(product),
            child: Material(
              color: AppColors.whiteColor,
              borderRadius: .circular(63),
              child: Padding(
                padding: .symmetric(vertical: 22),
                child: Text(StringConst.addToCart, style: AppTextStyles.detailAddToCartStyle, textAlign: .center,),
              ),
            ),
          ),
        ),
        ScaleOnPress(
          onTap: () => context.read<AppProvider>().toggleFavorite(product.id),
          child: AnimatedScale(
            scale: isFavorite ? 1.08 : 1,
            duration: NumberConstant.animFast,
            curve: Curves.easeOutCubic,
            child: AnimatedContainer(
              duration: NumberConstant.animFast,
              curve: Curves.easeOutCubic,
              decoration: BoxDecoration(
                color: isFavorite ? AppColors.newBadgeColor : AppColors.offerCartButtonColor,
                shape: .circle,
              ),
              padding: .all(21.5),
              child: SvgPicture.asset(AssetRes.icFavoriteMenu, colorFilter: .mode(AppColors.whiteColor, .srcIn),),
            ),
          ),
        ),
      ],
    );
  }
}
