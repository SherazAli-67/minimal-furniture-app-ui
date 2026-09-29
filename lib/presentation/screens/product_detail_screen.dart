import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:minimal_furniture_app/constants/string_const.dart';
import 'package:minimal_furniture_app/core/app_colors.dart';
import 'package:minimal_furniture_app/core/app_data.dart';
import 'package:minimal_furniture_app/core/app_textstyles.dart';
import 'package:minimal_furniture_app/core/asset_res.dart';
import 'package:minimal_furniture_app/core/models/product.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.productId});

  final String productId;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  static const _horizontalPadding = 20.0;

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
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: .fromLTRB(_horizontalPadding, 16, _horizontalPadding, 16),
                child: Column(
                  crossAxisAlignment: .start,
                  spacing: 0,
                  children: [
                    _buildHeader(context),
                    const SizedBox(height: 33),
                    if (product.isNew) _buildDetailNewBadge(),
                    if (product.isNew) const SizedBox(height: 10),
                    _buildTitlePriceRow(product),
                    _buildHeroSection(product),
                    const SizedBox(height: 20),
                    _buildColorSwatches(product),
                    const SizedBox(height: 45),
                    _buildRelatedProductsRow(context, relatedProducts),
                  ],
                ),
              ),
            ),
            _buildBottomActions(context),
          ],
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
        child: SizedBox(
          width: 53,
          height: 53,
          child: Center(
            child: SvgPicture.asset(iconPath, height: 22, colorFilter: .mode(AppColors.blackColor, .srcIn),),
          ),
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
    return Padding(
      padding: .symmetric(vertical: 14),
      child: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          Flexible(child: Text(product.name, style: AppTextStyles.detailTitleRowStyle, overflow: .ellipsis,),),
          Text('\$${product.price.toStringAsFixed(1)}', style: AppTextStyles.detailTitleRowStyle,),
        ],
      ),
    );
  }

  Widget _buildHeroSection(Product product) {
    return SizedBox(
      height: 360,
      width: double.infinity,
      child: Stack(
        alignment: .center,
        clipBehavior: .none,
        children: [
          Positioned(
            top: 0,
            child: SizedBox(
              width: 320,
              height: 320,
              child: Image.asset(product.image, fit: .contain,),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 13,
            right: 13,
            child: _buildRotationIndicator(),
          ),
        ],
      ),
    );
  }

  Widget _buildRotationIndicator() {
    return SizedBox(
      height: 133,
      child: Stack(
        alignment: .bottomCenter,
        children: [
          CustomPaint(
            size: const Size(double.infinity, 118),
            painter: _ProductArcPainter(),
          ),
          Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              color: AppColors.whiteColor,
              shape: .circle,
            ),
            child: Row(
              mainAxisAlignment: .center,
              children: [
                Icon(Icons.chevron_left, size: 14, color: AppColors.blackColor,),
                Icon(Icons.chevron_right, size: 14, color: AppColors.blackColor,),
              ],
            ),
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
        spacing: 16,
        children: List.generate(colors.length, (index) {
          final color = colors[index];
          final isSelected = index == _selectedColorIndex;
          return GestureDetector(
            onTap: () => setState(() => _selectedColorIndex = index),
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: .circle,
                color: color,
                border: isSelected ? .all(color: AppColors.secondaryTextColor, width: 2) : null,
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
      spacing: 20,
      children: items.map((product) => Expanded(child: _buildRelatedProductCard(context, product),)).toList(),
    );
  }

  Widget _buildRelatedProductCard(BuildContext context, Product product) {
    return Material(
      color: AppColors.scaffoldBgColor,
      borderRadius: .circular(14),
      clipBehavior: .antiAlias,
      child: InkWell(
        onTap: () => context.pushReplacement('/product/${product.id}'),
        child: SizedBox(
          height: 72,
          child: Row(
            spacing: 6,
            children: [
              SizedBox(
                width: 61,
                height: 66,
                child: Image.asset(product.image, fit: .contain, alignment: .bottomCenter,),
              ),
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

  Widget _buildBottomActions(BuildContext context) {
    return Padding(
      padding: .fromLTRB(21, 0, 21, 16),
      child: Row(
        spacing: 12,
        children: [
          Expanded(
            child: Material(
              color: AppColors.whiteColor,
              borderRadius: .circular(63),
              child: InkWell(
                onTap: () {},
                borderRadius: .circular(63),
                child: Container(
                  alignment: .center,
                  padding: .symmetric(vertical: 22),
                  child: Text(StringConst.addToCart, style: AppTextStyles.detailAddToCartStyle,),
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
              child: SizedBox(
                width: 71,
                height: 71,
                child: Center(
                  child: SvgPicture.asset(AssetRes.icFavoriteMenu, height: 28, colorFilter: .mode(AppColors.whiteColor, .srcIn),),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.whiteColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final rect = Rect.fromLTWH(0, 0, size.width, size.height * 1.6);
    canvas.drawArc(rect, math.pi * 0.15, math.pi * 0.7, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
