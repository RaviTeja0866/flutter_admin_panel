import 'package:get/get.dart';
import 'package:roguestore_admin_panel/data/repositories/product/product_repository.dart';
import 'package:roguestore_admin_panel/features/shop/models/product_model.dart';
import 'package:roguestore_admin_panel/utils/constants/enums.dart';

import '../../../../data/abstract/base_data_table_controlller.dart';

class ProductController extends RSBaseController<ProductModel> {
  static ProductController get instance => Get.find();

  final _productRepository = ProductRepository.instance;

  @override
  Future<List<ProductModel>> fetchItems() async {
    final products = await _productRepository.getAllProducts();
    return products;
  }

  @override
  bool containsSearchQuery(ProductModel item, String query) {
    final result = item.title.toLowerCase().contains(query.toLowerCase()) ||
        item.brand!.name.toLowerCase().contains(query.toLowerCase()) ||
        item.stock.toString().contains(query) ||
        item.price.toString().contains(query);
    return result;
  }

  @override
  Future<void> deleteItem(ProductModel item) async {
    // You might want to add a check if any orders of this product exist.
    await _productRepository.deleteProduct(item);
  }

  // Sorting Related Code
  void sortByName(int sortColumnIndex, bool ascending) {
    sortByProperty(sortColumnIndex, ascending,
            (ProductModel product) => product.title.toLowerCase());
  }

  void sortByPrice(int sortColumnIndex, bool ascending) {
    sortByProperty(
        sortColumnIndex, ascending, (ProductModel product) => product.price);
  }

  void sortByStock(int sortColumnIndex, bool ascending) {
    sortByProperty(
        sortColumnIndex, ascending, (ProductModel product) => product.stock);
  }

  void sortBySoldItems(int sortColumnIndex, bool ascending) {
    sortByProperty(sortColumnIndex, ascending,
            (ProductModel product) => product.soldQuantity);
  }

  String getProductPrice(ProductModel product) {
    if (product.productType == ProductType.single.toString() ||
        product.productVariations == null ||
        product.productVariations!.isEmpty) {
      final price = (product.salePrice > 0.0 ? product.salePrice : product.price).toString();
      return price;
    } else {
      double smallestPrice = double.infinity;
      double largestPrice = 0.0;

      for (var variation in product.productVariations!) {
        double priceToConsider =
        variation.salePrice > 0.0 ? variation.salePrice : variation.price;

        if (priceToConsider < smallestPrice) {
          smallestPrice = priceToConsider;
        }

        if (priceToConsider > largestPrice) {
          largestPrice = priceToConsider;
        }
      }

      if (smallestPrice == largestPrice) {
        return smallestPrice.toString();
      } else {
        return '₹\$smallestPrice - ₹\$largestPrice';
      }
    }
  }

  String? calculateSalePercentage(double originalPrice, double? salePrice) {
    if (salePrice == null || salePrice <= 0.0 || originalPrice <= 0) {
      return null;
    }

    double percentage = ((originalPrice - salePrice) / originalPrice) * 100;
    return '\${percentage.toStringAsFixed(0)}%';
  }

  String getProductStockTotal(ProductModel product) {
    final stock = product.productType == ProductType.single.toString()
        ? product.stock
        : product.productVariations!
        .fold<int>(0, (previousValue, element) => previousValue + element.stock);
    return stock.toString();
  }

  String getProductSoldQuantity(ProductModel product) {
    final soldQuantity = product.productType == ProductType.single.toString()
        ? product.soldQuantity
        : product.productVariations!.fold<int>(0,
            (previousValue, element) => previousValue + element.soldQuantity);
    return soldQuantity.toString();
  }

  String getProductStockStatus(ProductModel product) {
    final status = product.stock > 0 ? 'In Stock' : 'Out of Stock';
    return status;
  }
}
