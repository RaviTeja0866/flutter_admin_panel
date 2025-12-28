import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:roguestore_admin_panel/common/widgets/icons/circular_icon.dart';

import '../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../common/widgets/texts/section_heading.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';

class RSDashboardCard extends StatelessWidget {
  const RSDashboardCard({
    super.key,
    required this.title,
    required this.subTitle,
    required this.stats,
    this.icon = Iconsax.arrow_up_3,
    this.color = RSColors.success,
    this.onTap,
    required this.headingIcon,
    required this.headingIconColor,
    required this.headingIconBgColor,
  });

  final String title, subTitle;
  final IconData icon, headingIcon;
  final Color color, headingIconColor, headingIconBgColor;
  final int stats;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    // Get the current date
    DateTime now = DateTime.now();
    // Get the previous month
    DateTime previousMonth = DateTime(now.year, now.month - 1);
    // Format as "MMM yyyy" (e.g., "Feb 2025")
    String previousMonthFormatted = DateFormat("MMM yyyy").format(previousMonth);

    return RSRoundedContainer(
      onTap: onTap,
      padding: const EdgeInsets.all(RSSizes.lg),
      child: Column(
        children: [
          // Heading Row
          Row(
            children: [
              RSCircularIcon(
                icon: headingIcon,
                backgroundColor: headingIconBgColor,
                color: headingIconColor,
                size: RSSizes.md,
              ),
              const SizedBox(width: RSSizes.spaceBtwItems),
              RSSectionHeading(
                title: title,
                textColor: RSColors.textSecondary,
              ),
            ],
          ),
          const SizedBox(height: RSSizes.spaceBtwSections),

          // Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Subtitle
              Expanded(
                child: Text(
                  subTitle,
                  style: Theme.of(context).textTheme.headlineMedium,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),

              // Right Side Stats
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Icon(icon, color: color, size: RSSizes.iconSm),
                      const SizedBox(width: 4),
                      Text(
                        '$stats%',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: 135,
                    child: Text(
                      'Compared To $previousMonthFormatted',
                      style: Theme.of(context).textTheme.labelSmall,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
