import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:roguestore_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:roguestore_admin_panel/common/widgets/images/rs_rounded_image.dart';
import 'package:roguestore_admin_panel/data/repositories/order/order_repository.dart';
import 'package:roguestore_admin_panel/features/shop/models/order_model.dart';
import 'package:roguestore_admin_panel/features/shop/models/return_model.dart';
import 'package:roguestore_admin_panel/utils/constants/enums.dart';
import 'package:uuid/uuid.dart';

import '../../../../../../common/widgets/shimmers/shimmer_effect.dart';
import '../../../../../../data/repositories/authentication/authentication_repository.dart';
import '../../../../../../data/repositories/user/user_repository.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/device/device_utility.dart';
import '../../../../../../utils/popups/confirmation_dialog.dart';
import '../../../../../../utils/popups/full_screen_loader.dart';
import '../../../../../../utils/popups/loaders.dart';
import '../../../../../personalization/models/user_model.dart';
import '../../../../controllers/returns/returns_controller.dart';

class ReturnOrderTransactions extends StatelessWidget {
  const ReturnOrderTransactions({super.key, required this.returnOrder});

  final ReturnModel returnOrder;

  @override
  Widget build(BuildContext context) {
    return _buildTransactionUI(context, returnOrder);
  }
}

Widget _buildTransactionUI(BuildContext context, ReturnModel returnOrder) {
  final refundAmount = returnOrder.refundAmount ??
      (returnOrder.productPrice * returnOrder.quantity);

  final isCOD = returnOrder.paymentMethod?.toLowerCase() == 'cod';

  String paymentIcon(String? method) {
    if (method == null) return RSImages.cod;

    switch (method.toLowerCase()) {
      case 'cod':
      case 'cash on delivery':
        return RSImages.cod;
      case 'gpay':
      case 'google pay':
        return RSImages.googlePay;
      case 'phonepe':
        return RSImages.phonePe;
      case 'paytm':
        return RSImages.paytm;
      case 'upi':
        return RSImages.upi;
      case 'wallet':
        return RSImages.wallet;
      default:
        return RSImages.creditCard;
    }
  }

  return RSRoundedContainer(
    padding: EdgeInsets.all(RSSizes.defaultSpace),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Refund Transaction',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        SizedBox(height: RSSizes.spaceBtwSections),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// PAYMENT METHOD
            Expanded(
              flex: RSDeviceUtils.isMobileScreen(context) ? 2 : 3,
              child: Row(
                children: [
                  RSRoundedImage(
                    imageType: ImageType.asset,
                    image: paymentIcon(returnOrder.paymentMethod),
                  ),
                  SizedBox(width: RSSizes.spaceBtwItems),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Payment Method',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      Text(
                        returnOrder.paymentMethod?.capitalize ?? 'Unknown',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            /// DATE
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Date', style: Theme.of(context).textTheme.labelMedium),
                  Text(
                    returnOrder.refundProcessedAt != null
                        ? DateFormat('dd MMM yyyy')
                            .format(returnOrder.refundProcessedAt!)
                        : DateFormat('dd MMM yyyy')
                            .format(returnOrder.requestDate),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),

            /// AMOUNT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Refund Amount',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  Text(
                    "₹$refundAmount",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),

            /// ACTION
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: returnOrder.refundStatus == "completed"
                      ? null
                      : () => _showRefundConfirmationDialog(
                            context,
                            returnOrder,
                          ),
                  icon: const Icon(Icons.currency_rupee, size: 16),
                  label: Text(
                    returnOrder.refundStatus == "completed"
                        ? "Refunded"
                        : isCOD
                            ? "Refund to Wallet"
                            : "Refund to Source",
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: returnOrder.refundStatus == "completed"
                        ? Colors.grey
                        : RSColors.primary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: RSSizes.md,
                      vertical: RSSizes.sm,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

void _showRefundConfirmationDialog(
    BuildContext context, ReturnModel returnOrder) {
  showConfirmationDialog(
    context: context,
    title: 'Refund Order',
    message: 'Are you sure you want to refund this order?',
    positiveButtonText: 'Yes, Refund Order',
    negativeButtonText: "No, don't Refund",
    onPositivePressed: () {
      Navigator.of(context).pop();
      _showRefundAuthenticationDialog(context, returnOrder);
    },
    onNegativePressed: () => Navigator.of(context).pop(),
  );
}

Future<void> _refundToWallet(ReturnModel returnOrder, double amount) async {
  final controller = ReturnController.instance;

  // TODO: call your wallet transaction create API
  // e.g. WalletRepository.createTransaction(...)

  await controller.updateRefundStatus(
    item: returnOrder,
    refundStatus: "completed",
    refundAmount: amount,
  );
}

void _showRefundAuthenticationDialog(
    BuildContext context, ReturnModel returnOrder) async {
  final controller = ReturnController.instance;
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final requestId = const Uuid().v4();

  final refundAmount = returnOrder.productPrice * returnOrder.quantity;
  final isCOD = returnOrder.paymentMethod?.toLowerCase() == "cod";
  showConfirmationDialog(
    context: context,
    title: 'Authentication',
    customContent: Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Enter password to continue.'),
          SizedBox(height: 16),
          TextFormField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: "Password",
              border: OutlineInputBorder(),
            ),
            validator: (value) =>
                value == null || value.isEmpty ? "Required" : null,
          ),
        ],
      ),
    ),
    positiveButtonText: 'Submit',
    negativeButtonText: 'Cancel',
    onPositivePressed: () async {
      if (!formKey.currentState!.validate()) return;

      try {
        RSFullScreenLoader.openLoadingDialog(
          "Authenticating...",
          RSImages.docerAnimation,
        );

        await AuthenticationRepository.instance
            .reauthenticateUser(passwordController.text.trim());

        RSFullScreenLoader.stopLoading();
        Navigator.pop(context);

        RSFullScreenLoader.openLoadingDialog(
          "Processing refund...",
          RSImages.docerAnimation,
        );

        if (isCOD) {
          // COD → Wallet refund
          await _refundToWallet(returnOrder, refundAmount);
        } else {
          // Online payment → Juspay refund
          if (returnOrder.juspayOrderId == null ||
              returnOrder.juspayOrderId!.isEmpty) {
            RSFullScreenLoader.stopLoading();
            RSLoaders.warningSnackBar(
              title: "Error",
              message: "Missing Juspay order ID",
            );
            return;
          }
          await ReturnController.instance.callRefundLambda(
            returnOrder.id!,
          );
          await controller.updateRefundStatus(
            item: returnOrder,
            refundStatus: "completed",
            refundAmount: refundAmount,
          );
        }
        RSFullScreenLoader.stopLoading();
        RSLoaders.successSnackBar(
          title: "Refund Successful",
          message: "Customer refund has been processed",
        );
      } catch (e) {
        RSFullScreenLoader.stopLoading();
        RSLoaders.warningSnackBar(
          title: "Authentication Failed",
          message: e.toString(),
        );
      }
    },
    onNegativePressed: () => Navigator.pop(context),
    message: '',
  );
}
