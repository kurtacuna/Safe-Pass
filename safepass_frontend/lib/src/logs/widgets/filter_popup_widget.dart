import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:safepass_frontend/common/const/kcolors.dart';

class FilterPopupWidget extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final ValueChanged<DateTime?> onStartDatePicked;
  final ValueChanged<DateTime?> onEndDatePicked;
  final VoidCallback onConfirm;

  const FilterPopupWidget({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.onStartDatePicked,
    required this.onEndDatePicked,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.kDarkBlue,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Filter by Date",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildDateField(context, "Start Date", startDate, onStartDatePicked),
          const SizedBox(height: 12),
          _buildDateField(context, "End Date", endDate, onEndDatePicked),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: onConfirm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: const Text(
                "Apply",
                style: TextStyle(color: AppColors.kDarkBlue, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField(
      BuildContext context,
      String label,
      DateTime? date,
      ValueChanged<DateTime?> onPicked,
      ) {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (picked != null) {
          onPicked(picked);
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          date != null ? DateFormat('MM/dd/yyyy').format(date) : label,
          style: const TextStyle(color: AppColors.kDark),
        ),
      ),
    );
  }
}
