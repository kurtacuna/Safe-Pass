import 'package:flutter/material.dart';
import 'package:safepass_frontend/common/const/app_theme/app_text_styles.dart';
import 'package:safepass_frontend/common/const/kcolors.dart';
import 'package:safepass_frontend/common/const/kconstants.dart';

class SearchBarWidget extends StatelessWidget {
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onSearchPressed;
  final VoidCallback onToggleFilter;
  final bool isFilterVisible;
  final Widget? filterPopup;

  const SearchBarWidget({
    super.key,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.onSearchPressed,
    required this.onToggleFilter,
    required this.isFilterVisible,
    this.filterPopup,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: TextField(
            decoration: InputDecoration(
              hintText: "Search",
              border: AppConstants.enabledBorder,
              focusedBorder: AppConstants.focusedBorder,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            onChanged: onSearchChanged,
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton.icon(
          onPressed: onSearchPressed,
          icon: const Icon(Icons.search),
          label: const Text("Search"),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.kDarkBlue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          ),
        ),
        const SizedBox(width: 16),
        Stack(
          children: [
            ElevatedButton.icon(
              onPressed: onToggleFilter,
              icon: const Icon(Icons.filter_list),
              label: const Text("Filter"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.kDarkBlue,
                foregroundColor: Colors.white,
              ),
            ),
            if (isFilterVisible && filterPopup != null)
              Positioned(top: 48, right: 0, child: filterPopup!),
          ],
        ),
      ],
    );
  }
}
