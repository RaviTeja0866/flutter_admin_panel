import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/product/edit_product_controller.dart';
import 'package:roguestore_admin_panel/utils/constants/enums.dart';

import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/validators/validation.dart';

class ProductStockAndPricing extends StatelessWidget {
  const ProductStockAndPricing({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = EditProductController.instance;
    
    return Obx(
      () => controller.productType.value == ProductType.single
          ? Form(
        key: controller.stockPriceFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stock
              FractionallySizedBox(
                widthFactor: 0.45,
                child: TextFormField(
                  controller: controller.stock,
                  decoration: InputDecoration(labelText: 'Stock', hintText: 'Add Stock, only Numbers are allowed'),
                  validator: (value) => RSValidator.validateEmptyText('Stock', value),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                ),
              ),SizedBox(height: RSSizes.spaceBtwInputFields),
      
              // Pricing
              Row(
                children: [
                  // Price
                  Expanded(child:
                  TextFormField(
                    controller: controller.price,
                    decoration: InputDecoration(labelText: 'Price', hintText: 'Price with up to 2 decimals'),
                    validator: (value) => RSValidator.validateEmptyText('Price', value),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'^\d\.?\d{0,4}$'))],
                  ),
                  ),
                  SizedBox(width: RSSizes.spaceBtwItems),
      
                  // sale Price
                  Expanded(child:
                  TextFormField(
                    controller: controller.salePrice,
                    decoration: InputDecoration(labelText: 'Discounted Price', hintText: 'Price with up to 2 decimals'),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'^\d\.?\d{0,4}$'))],
                  ),)
                ],
              )
            ],
          ))
          :SizedBox.shrink(),
    );
  }
}
