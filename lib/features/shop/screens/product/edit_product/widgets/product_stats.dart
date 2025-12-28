import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/product/edit_product_controller.dart';
import 'package:roguestore_admin_panel/features/shop/models/product_model.dart';

import '../../../../../../utils/constants/sizes.dart';
import '../../../dashboard/widgets/dashboard_card.dart';

class RSProductStats extends StatelessWidget {
  const RSProductStats({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final controller = EditProductController.instance;
    // Fetch total views when the widget builds
    controller.productViews(product);
    controller.wishlistViews(product);

    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;
        int crossAxisCount =
            (screenWidth ~/ 160).clamp(2, 5); // Adjust based on available width

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Obx(() => _buildDashboardCard(
                    context,
                    'Views',
                    controller.totalViews.value.toString(),
                    15,
                    Iconsax.eye,
                    Colors.orangeAccent,
                    crossAxisCount,
                  )),
              Obx(() => _buildDashboardCard(
                context,
                'Wishlist',
                controller.wishlist.value.toString(),
                15,
                Iconsax.heart,
                Colors.blueAccent,
                crossAxisCount,
              )),
              _buildDashboardCard(context, 'Cart', '₹50,000', 30,
                  Iconsax.shopping_cart, Colors.greenAccent, crossAxisCount),
              _buildDashboardCard(context, 'Sold', '1000', 25, Iconsax.user,
                  Colors.purpleAccent, crossAxisCount),
              _buildDashboardCard(context, 'Returns', '5', -5, Iconsax.receipt,
                  Colors.redAccent, crossAxisCount),
              _buildDashboardCard(context, 'Shares', '5', -5, Iconsax.share,
                  Colors.orangeAccent, crossAxisCount),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDashboardCard(
      BuildContext context,
      String title,
      String subTitle,
      int stats,
      IconData icon,
      Color color,
      int crossAxisCount) {
    double cardWidth = (MediaQuery.of(context).size.width / crossAxisCount) -
        RSSizes.spaceBtwItems;

    return Padding(
      padding: EdgeInsets.only(right: RSSizes.spaceBtwItems),
      child: SizedBox(
        width: cardWidth,
        child: RSDashboardCard(
          title: title,
          subTitle: subTitle,
          stats: stats,
          headingIcon: icon,
          headingIconColor: color,
          headingIconBgColor: color.withOpacity(0.1),
        ),
      ),
    );
  }
}
