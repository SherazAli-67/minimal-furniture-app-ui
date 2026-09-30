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
import 'package:minimal_furniture_app/routing/router.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.productId});

  final String productId;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _selectedColorIndex = 2;
  bool _isFavorite = false;

  Product? get _product => AppData.productById(widget.productId);

  @override
  Widget build(BuildContext context) {
    final product = _product;
    if (product == null) {
      return Scaffold(
        backgroundColor: AppColors.cardDarkColor,
        body: Center(child: Text('Product not found', style: AppTextStyles.screenTitleLightStyle,),),
      );
    }
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
                          _buildHeader(context),
                          Column(
                            crossAxisAlignment: .start,
                            spacing: NumberConstant.detailBadgeToTitleSpacing,
                            children: [
                              if (product.isNew) _buildDetailNewBadge(),
                              _buildTitlePriceRow(product),
                            ],
                          ),
                        ],
                      ),
                      _buildHeroSection(product),
                      Column(
                        spacing: NumberConstant.detailSwatchToRelatedSpacing,
                        children: [
                          _buildColorSwatches(product),
                          _buildRelatedProductsRow(context, relatedProducts),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              _buildBottomActions(),
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
            child: Image.asset(product.image, width: NumberConstant.detailHeroImageSize, height: NumberConstant.detailHeroImageSize, fit: .contain,),
          ),
          Positioned(
            bottom: 0,
            left: 13,
            right: 13,
            child: SvgPicture.asset(AssetRes.icBottomLine),
          ),
        ],
      ),
    );
  }


  Widget _buildColorSwatches(Product product) {
    final colors = product.colors.isNotEmpty ? product.colors : AppData.defaultColorOptions;
    return Center(
      child: Row(
        mainAxisSize: .min,
        spacing: NumberConstant.detailColorSwatchSpacing,
        children: List.generate(colors.length, (index) {
          final color = colors[index];
          final isSelected = index == _selectedColorIndex;
          return GestureDetector(
            onTap: () => setState(() => _selectedColorIndex = index),
            child: Container(
              padding: .all(10),
              decoration: BoxDecoration(
                shape: .circle,
                color: color,
                border: isSelected ? .all(color: AppColors.secondaryTextColor, width: 4) : null,
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

  Widget _buildRelatedProductsRow(BuildContext context, List<Product> relatedProducts) {
    if (relatedProducts.isEmpty) return const SizedBox.shrink();
    final items = relatedProducts.length > 2 ? relatedProducts.sublist(0, 2) : relatedProducts;
    return Row(
      spacing: NumberConstant.detailRelatedGap,
      children: items.map((product) => Expanded(child: _buildRelatedProductCard(context, product),)).toList(),
    );
  }

  Widget _buildRelatedProductCard(BuildContext context, Product product) {
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

  Widget _buildBottomActions() {
    return Row(
      spacing: NumberConstant.detailBottomActionSpacing,
      children: [
        Expanded(
          child: Material(
            color: AppColors.whiteColor,
            borderRadius: .circular(63),
            child: InkWell(
              onTap: () {},
              borderRadius: .circular(63),
              child: Padding(
                padding: .symmetric(vertical: 22),
                child: Text(StringConst.addToCart, style: AppTextStyles.detailAddToCartStyle, textAlign: .center,),
              ),
            ),
          ),
        ),
        Material(
          color: AppColors.offerCartButtonColor,
          shape: const CircleBorder(),
          child: InkWell(
            onTap: () => setState(() => _isFavorite = !_isFavorite),
            customBorder: const CircleBorder(),
            child: Padding(
              padding: .all(21.5),
              child: SvgPicture.asset(AssetRes.icFavoriteMenu, colorFilter: .mode(AppColors.whiteColor, .srcIn),),
            ),
          ),
        ),
      ],
    );
  }
}