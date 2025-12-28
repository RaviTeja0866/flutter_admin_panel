import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:roguestore_admin_panel/common/widgets/loaders/animation_loader.dart';
import 'package:roguestore_admin_panel/utils/constants/image_strings.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';

// Custom PaginationTable Widget with additional features
class RSPaginatedDataTable extends StatelessWidget {
  const RSPaginatedDataTable({
    super.key,
    required this.columns,
    required this.source,
    this.rowsPerPage = 10,
    this.tableHeight = 760,
    this.onPageChanged,
    this.sortColumnIndex,
    this.dataRowHeight = RSSizes.xl * 2,
    this.sortAscending = true,
    this.minWidth = 1000,
  });

  final bool sortAscending;
  final int? sortColumnIndex;
  final int rowsPerPage;
  final DataTableSource source;
  final List<DataColumn> columns;
  final Function(int)? onPageChanged;
  final double dataRowHeight;
  final double tableHeight;
  final double? minWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // Set the dynamic height of the PaginatedTable
      height: tableHeight,
      child: Theme(
        // use to set the Backend Color,
      data: Theme.of(context).copyWith(cardTheme: const CardThemeData(color: Colors.white, elevation: 0)),
        child: PaginatedDataTable2(
          source: source,

          //Columns & Rows
          columns: columns,
          columnSpacing: 12,
          minWidth: minWidth,
          dividerThickness: 0,
          rowsPerPage: rowsPerPage,
          dataRowHeight: dataRowHeight,

          //Checkbox column
          showCheckboxColumn: true,

          //Pagination
          showFirstLastButtons: true,
          onPageChanged: onPageChanged,
          renderEmptyRowsInTheEnd: false,
          onRowsPerPageChanged: (noOfRows) {},

          // Header Design
          headingTextStyle: Theme.of(context).textTheme.headlineMedium,
          headingRowColor: WidgetStateProperty.resolveWith((states) => RSColors.primaryBackground),
          headingRowDecoration: const BoxDecoration(borderRadius: BorderRadius.only(
            topLeft: Radius.circular(RSSizes.borderRadiusMd),
            topRight: Radius.circular(RSSizes.borderRadiusMd),
          )),
          empty: RSAnimationLoaderWidget(text: 'Nothing Found', animation: RSImages.packageAnimation, height: 200, width: 200),

          // Sorting
          sortAscending: sortAscending,
          sortColumnIndex: sortColumnIndex,
          sortArrowBuilder: (bool ascending, bool sorted) {
            if (sorted) {return Icon(ascending ? Iconsax.arrow_up_3 : Iconsax.arrow_down, size: RSSizes.iconSm);
            } else {
              return const Icon(Iconsax.arrow_3, size: RSSizes.iconSm,
              );
            }
          },
        ),
      ),
    );
  }
}
