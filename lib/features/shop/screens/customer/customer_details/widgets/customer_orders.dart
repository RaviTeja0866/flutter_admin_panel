import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:roguestore_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:roguestore_admin_panel/common/widgets/loaders/animation_loader.dart';
import 'package:roguestore_admin_panel/utils/popups/loader_animation.dart';

import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../controllers/customer/customer_detail_controller.dart';
import '../../../../controllers/wallet/wallet_controller.dart';
import '../table/data_table.dart';

class CustomerOrders extends StatelessWidget {
  const CustomerOrders({super.key});

  @override
  Widget build(BuildContext context) {
    final customerController = CustomerDetailController.instance;
    final walletController = Get.put(WalletController());

    // Fetch orders
    customerController.getCustomerOrders();

    // Fetch wallet when user exists
    if (customerController.customer.value.id != null &&
        customerController.customer.value.id!.isNotEmpty) {
      walletController.loadWallet(customerController.customer.value.id!);
    }

    return DefaultTabController(
      length: 2, // Orders + Wallet tabs
      child: RSRoundedContainer(
        padding: EdgeInsets.all(RSSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------------- HEADER ----------------
            Obx(() {
              if (customerController.ordersLoading.value) {
                return RSLoaderAnimation();
              }

              final totalSpent = customerController.allCustomerOrders.fold(
                0.0,
                    (prev, order) => prev + order.totalAmount,
              );

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Customer Details",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(text: "Total Spent "),
                        TextSpan(
                          text: "₹${totalSpent.toStringAsFixed(0)} ",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .apply(color: RSColors.primary),
                        ),
                        TextSpan(
                          text:
                          "on ${customerController.allCustomerOrders.length} orders",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),

            SizedBox(height: RSSizes.spaceBtwItems),

            // ---------------- TAB BAR ----------------
            Container(
              decoration: BoxDecoration(
                color: RSColors.primaryBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const TabBar(
                labelColor: RSColors.primary,
                unselectedLabelColor: Colors.grey,
                indicatorColor: RSColors.primary,
                tabs: [
                  Tab(text: "Orders"),
                  Tab(text: "Wallet"),
                ],
              ),
            ),

            SizedBox(height: RSSizes.spaceBtwSections),

            // ---------------- TAB CONTENT ----------------
            SizedBox(
              height: 600,
              child: TabBarView(
                children: [
                  // ---------- ORDERS TAB ----------
                  Obx(() {
                    if (customerController.ordersLoading.value) {
                      return RSLoaderAnimation();
                    }

                    if (customerController.allCustomerOrders.isEmpty) {
                      return RSAnimationLoaderWidget(
                        text: "No Orders Found",
                        animation: RSImages.pencilAnimation,
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: customerController.searchTextController,
                          onChanged: customerController.searchQuery,
                          decoration: InputDecoration(
                            hintText: 'Search Orders',
                            prefixIcon: Icon(Iconsax.search_normal),
                          ),
                        ),
                        SizedBox(height: RSSizes.spaceBtwSections),

                        Expanded(child: CustomerOrderTable()),
                      ],
                    );
                  }),

// ---------- WALLET TAB ----------
                  Obx(() {
                    if (walletController.loading.value) {
                      return RSLoaderAnimation();
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ---- WALLET BALANCE CARD ----
                        RSRoundedContainer(
                          padding: const EdgeInsets.all(16),
                          backgroundColor: RSColors.primaryBackground,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Wallet Balance",
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              Text(
                                "₹${walletController.walletBalance.value.toStringAsFixed(0)}",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .apply(color: RSColors.primary),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: RSSizes.spaceBtwSections),

                        // ---- TRANSACTIONS LIST ----
                        Expanded(
                          child: walletController.filteredTransactions.isEmpty
                              ? RSAnimationLoaderWidget(
                            text: "No Wallet Transactions Found",
                            animation: RSImages.pencilAnimation,
                          )
                              : ListView.separated(
                            itemCount: walletController.filteredTransactions.length,
                            separatorBuilder: (_, __) => const Divider(height: 1),
                            itemBuilder: (context, index) {
                              final txn =
                              walletController.filteredTransactions[index];

                              return ListTile(
                                leading: Icon(
                                  txn.isCredit
                                      ? Iconsax.arrow_up_3
                                      : Iconsax.arrow_down,
                                  color:
                                  txn.isCredit ? Colors.green : Colors.red,
                                ),
                                title: Text(txn.title),
                                subtitle: Text(
                                  "${txn.subtitle}\n${DateFormat("dd MMM yyyy").format(txn.date)}",
                                ),
                                trailing: Text(
                                  txn.getAmountWithSign(),
                                  style: TextStyle(
                                    color: txn.isCredit
                                        ? Colors.green
                                        : Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
