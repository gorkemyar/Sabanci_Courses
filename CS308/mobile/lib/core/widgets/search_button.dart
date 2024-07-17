import 'package:flutter/material.dart';
import 'package:mobile/core/constants/navigation/navigation_constants.dart';
import 'package:mobile/core/init/navigation/navigation_service.dart';
import 'package:mobile/core/init/theme/color_theme.dart';

class SearchButtonWidget extends StatelessWidget {
  const SearchButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (() => NavigationService.instance
          .navigateToPage(path: NavigationConstants.SEARCH)),
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        width: MediaQuery.of(context).size.width,
        height: 48,
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
          boxShadow: [
            BoxShadow(
              color: Color(0x19575B7D),
              spreadRadius: 0,
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: _searchContent(),
      ),
    );
  }

  Row _searchContent() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Text(
          "Search...",
          style: TextStyle(
            color: AppColors.darkGray,
          ),
        ),
        Icon(
          Icons.search,
          color: AppColors.darkGray,
        )
      ],
    );
  }
}
