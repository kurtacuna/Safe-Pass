import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:safepass_frontend/common/const/kcolors.dart';

class FilterPopupWidget extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final ValueChanged<DateTime?> onStartDatePicked;
  final ValueChanged<DateTime?> onEndDatePicked;
  final VoidCallback onConfirm;
  final String? selectedStatus;
  final ValueChanged<String?>? onStatusChanged;
  final String? selectedPurpose;
  final ValueChanged<String?>? onPurposeChanged;
  final List<String>? statusItems;
  final List<String>? purposeItems;
  final String? selectedIdType;
  final ValueChanged<String?>? onIdTypeChanged;
  final List<String>? idTypeItems;


  const FilterPopupWidget({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.onStartDatePicked,
    required this.onEndDatePicked,
    required this.onConfirm,
    this.statusItems,
    this.selectedStatus,
    this.onStatusChanged,
    this.purposeItems,
    this.selectedPurpose,
    this.onPurposeChanged,
    this.idTypeItems,
    this.selectedIdType,
    this.onIdTypeChanged,
  });

  @override
Widget build(BuildContext context) {
  return SingleChildScrollView(
    child: Container(
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
          
          onStatusChanged != null && statusItems != null
            ? Column(
               children: [
                const SizedBox(height: 24),
                  const Text(
                    "Filter by Status",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  DropdownButton<String>(
                    value: selectedStatus,
                    dropdownColor: AppColors.kDarkBlue,
                    items: List.generate(statusItems!.length, (index) {
                      return DropdownMenuItem(
                        value: statusItems![index],
                        child: Text(statusItems![index], style: TextStyle(color: Colors.white)),
                      );
                    }),
                    onChanged: onStatusChanged,
                    hint: const Text("Select status", style: TextStyle(color: Colors.white)),
                    iconEnabledColor: Colors.white,
                    style: const TextStyle(color: Colors.white),
                  ),
               ], 
              )
            : Container(),
    
          onPurposeChanged != null && purposeItems != null
            ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                const SizedBox(height: 16),
                const Text(
                  "Filter by Purpose",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: 300,
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: selectedPurpose,
                    dropdownColor: AppColors.kDarkBlue,
                    items: List.generate(purposeItems!.length, (index) {
                      return DropdownMenuItem(
                        value: purposeItems![index],
                        child: Text(purposeItems![index], style: TextStyle(color: Colors.white)),
                      );
                    }),
                    onChanged: onPurposeChanged,
                    hint: const Text("Select purpose", style: TextStyle(color: Colors.white)),
                    iconEnabledColor: Colors.white,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
               ] 
              )
            : Container(),

          onIdTypeChanged != null && idTypeItems != null
            ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                const SizedBox(height: 16),
                const Text(
                  "Filter by ID Type",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: 300,
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: selectedIdType,
                    dropdownColor: AppColors.kDarkBlue,
                    items: List.generate(idTypeItems!.length, (index) {
                      return DropdownMenuItem(
                        value: idTypeItems![index],
                        child: Text(idTypeItems![index], style: TextStyle(color: Colors.white)),
                      );
                    }),
                    onChanged: onIdTypeChanged,
                    hint: const Text("Select ID type", style: TextStyle(color: Colors.white)),
                    iconEnabledColor: Colors.white,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
               ] 
              )
            : Container(),
    
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
                style: TextStyle(
                  color: AppColors.kDarkBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
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
