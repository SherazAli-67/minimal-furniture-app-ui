import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:minimal_furniture_app/constants/string_const.dart';
import 'package:minimal_furniture_app/core/app_colors.dart';
import 'package:minimal_furniture_app/core/app_data.dart';
import 'package:minimal_furniture_app/core/app_textstyles.dart';
import 'package:minimal_furniture_app/core/asset_res.dart';
import 'package:minimal_furniture_app/core/models/cart_line.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  static const _horizontalPadding = 20.0;

  late List<CartLine> _lines;

  @override
  void initState() {
    super.initState();
    _lines = AppData.demoCartLines();
  }

  double get _subtotal => _lines.fold(0, (sum, line) => sum + line.lineTotal);

  double get _total => _subtotal + AppData.deliveryCharge;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: .fromLTRB(_horizontalPadding, 16, _horizontalPadding, 0),
              child: _buildHeader(context),
            ),
            const SizedBox(height: 37),
            Expanded(
              child: ListView.separated(
                padding: .symmetric(horizontal: _horizontalPadding),
                itemCount: _lines.length,
                separatorBuilder: (context, index) => const SizedBox(height: 14),
                itemBuilder: (context, index) => _buildCartItemCard(index),
              ),
            ),
            _buildSummaryPanel(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        _buildHeaderIconButton(iconPath: AssetRes.icArrowBack, onTap: () => context.go('/home'),),
        Text(StringConst.cartList, style: AppTextStyles.screenTitleStyle,),
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

  Widget _buildCartItemCard(int index) {
    final line = _lines[index];
    return Container(
      height: 113,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: .circular(16),
      ),
      clipBehavior: .antiAlias,
      child: Padding(
        padding: .fromLTRB(25, 1, 16, 1),
        child: Row(
          spacing: 24,
          children: [
            SizedBox(
              width: 88,
              height: 111,
              child: Image.asset(line.product.image, fit: .contain, alignment: .bottomCenter,),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                mainAxisAlignment: .center,
                spacing: 8,
                children: [
                  Text(AppData.cartDisplayName(line.product), style: AppTextStyles.cartItemNameStyle,),
                  Text('\$${line.product.price.toStringAsFixed(1)}', style: AppTextStyles.cartItemPriceStyle,),
                  _buildQuantityStepper(index, line.quantity),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityStepper(int index, int quantity) {
    return Row(
      spacing: 12,
      children: [
        _buildMinusButton(onTap: () => _updateQuantity(index, quantity - 1),),
        Text('$quantity', style: AppTextStyles.cartQuantityStyle,),
        _buildPlusButton(onTap: () => _updateQuantity(index, quantity + 1),),
      ],
    );
  }

  Widget _buildMinusButton({required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 17,
        height: 17,
        decoration: BoxDecoration(
          shape: .circle,
          border: .all(color: AppColors.cartMutedTextColor, width: 1),
        ),
        child: Center(
          child: Container(
            width: 7,
            height: 1,
            color: AppColors.cartMutedTextColor,
          ),
        ),
      ),
    );
  }

  Widget _buildPlusButton({required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 17,
        height: 17,
        decoration: BoxDecoration(
          color: AppColors.cardDarkColor,
          borderRadius: .circular(5),
        ),
        child: const Icon(Icons.add, size: 10, color: AppColors.whiteColor,),
      ),
    );
  }

  void _updateQuantity(int index, int quantity) {
    if (quantity < 1) return;
    setState(() => _lines[index] = _lines[index].copyWith(quantity: quantity));
  }

  Widget _buildSummaryPanel() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: .vertical(top: Radius.circular(32)),
      ),
      padding: .fromLTRB(20, 28, 20, 16),
      child: Column(
        spacing: 20,
        children: [
          Column(
            spacing: 12,
            children: [
              _buildSummaryRow(label: StringConst.subtotal, value: _formatMoney(_subtotal),),
              _buildSummaryRow(label: StringConst.deliveryCharge, value: _formatMoney(AppData.deliveryCharge),),
            ],
          ),
          Divider(color: AppColors.dividerColor, height: 1, thickness: 1,),
          _buildSummaryRow(label: StringConst.total, value: _formatMoney(_total, singleDecimal: true),),
          Material(
            color: AppColors.cardDarkColor,
            borderRadius: .circular(63),
            child: InkWell(
              onTap: () {},
              borderRadius: .circular(63),
              child: Container(
                width: double.infinity,
                alignment: .center,
                padding: .symmetric(vertical: 20),
                child: Text(StringConst.continueLabel, style: AppTextStyles.cartContinueStyle,),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow({required String label, required String value}) {
    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        Text(label, style: AppTextStyles.cartSummaryLabelStyle,),
        Text(value, style: AppTextStyles.cartSummaryValueStyle,),
      ],
    );
  }

  String _formatMoney(double amount, {bool singleDecimal = false}) {
    if (singleDecimal) return '\$${amount.toStringAsFixed(1)}';
    return '\$${amount.toStringAsFixed(2)}';
  }
}
