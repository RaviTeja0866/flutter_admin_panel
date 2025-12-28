import 'package:flutter/material.dart';
import 'package:roguestore_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:roguestore_admin_panel/common/widgets/images/rs_rounded_image.dart';

import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../personalization/models/user_model.dart';

class CustomerInfo extends StatelessWidget {
  const CustomerInfo({super.key, required this.customer});

  final UserModel customer;

  @override
  Widget build(BuildContext context) {
    return RSRoundedContainer(
      padding: EdgeInsets.all(RSSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Customer Information', style: Theme.of(context).textTheme.headlineMedium),
          SizedBox(height: RSSizes.spaceBtwSections),

          // Personal Info Card
          Row(
            children: [
              RSRoundedImage(
                padding: 0,
                backgroundColor: RSColors.primaryBackground,
                image: customer.profilePicture.isNotEmpty ? customer.profilePicture : RSImages.user,
                imageType: customer.profilePicture.isNotEmpty ? ImageType.network : ImageType.asset,
              ),
              SizedBox(width: RSSizes.spaceBtwItems),
              Expanded(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(customer.fullName,
                      style: Theme.of(context).textTheme.titleLarge,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2),
                  Text(customer.email, overflow: TextOverflow.ellipsis, maxLines: 2),
                ],
              ))
            ],
          ),
          SizedBox(height: RSSizes.spaceBtwSections),

          //Meta Data
          Row(
            children: [
              SizedBox(width: 120, child: Text('Username')),
              Text(':'),
              SizedBox(width: RSSizes.spaceBtwItems / 2),
              Expanded(
                child: Text(customer.fullName, style: Theme.of(context).textTheme.titleMedium),
              )
            ],
          ),
          SizedBox(height: RSSizes.spaceBtwItems),
          Row(
            children: [
              SizedBox(width: 120, child: Text('Country')),
              Text(':'),
              SizedBox(width: RSSizes.spaceBtwItems / 2),
              Expanded(
                child: Text('India', style: Theme.of(context).textTheme.titleMedium),
              )
            ],
          ),
          SizedBox(height: RSSizes.spaceBtwItems),
          Row(
            children: [
              SizedBox(width: 120, child: Text('Phone Number')),
              Text(':'),
              SizedBox(width: RSSizes.spaceBtwItems / 2),
              Expanded(
                child: Text(customer.phoneNumber, style: Theme.of(context).textTheme.titleMedium),
              )
            ],
          ),
          SizedBox(height: RSSizes.spaceBtwItems),

          // Divider
          Divider(),
          SizedBox(height: RSSizes.spaceBtwItems),

          // Additional Details
          Row(
            children: [
              Expanded(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Last order ', style: Theme.of(context).textTheme.titleLarge),
                      Text('7 Days ago #[355d4]'),
                    ]),
              ),
              Expanded(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Average order Value', style: Theme.of(context).textTheme.titleLarge),
                      Text('\$352'),
                    ]),
              ),
            ],
          ),
          SizedBox(height: RSSizes.spaceBtwItems),

          // Additional Details
          Row(
            children: [
              Expanded(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Registered ', style: Theme.of(context).textTheme.titleLarge),
                      Text(customer.formattedDate),
                    ]),
              ),
              Expanded(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Email Marketing', style: Theme.of(context).textTheme.titleLarge),
                      Text('Subscribed'),
                    ]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
