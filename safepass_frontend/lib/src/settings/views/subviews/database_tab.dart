import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:intl/intl.dart";
import "package:safepass_frontend/common/const/app_theme/app_text_styles.dart";
import "package:safepass_frontend/common/const/kcolors.dart";
import "package:safepass_frontend/common/const/kconstants.dart";
import "package:safepass_frontend/common/widgets/app_button_widget.dart";
import "package:safepass_frontend/src/logs/widgets/filter_popup_widget.dart";
import "package:safepass_frontend/src/logs/widgets/search_bar_widget.dart";
import "package:safepass_frontend/src/settings/models/visitor_details_model.dart";

class DatabaseTab extends StatefulWidget {
  const DatabaseTab({super.key});

  @override
  State<DatabaseTab> createState() => _DatabaseTabState();
}

class _DatabaseTabState extends State<DatabaseTab> {
  String searchQuery = '';
  DateTime? startDate;
  DateTime? endDate;
  String? selectedStatus;

  static const rowsPerPage = 10;
  int currentPage = 0;

  // TODO: change values once backend is done
  List<VisitorDetails> visitorDetails = [
    VisitorDetails(
      photo: "https://example.com/visitor_photos/P1234567A_Maria_Gonzales.jpg",
      firstName: "Maria",
      middleName: "",
      lastName: "Gonzales",
      fullName: "Maria Gonzales",
      contactNumber: "09171234567",
      idType: "Philippine Passport",
      idNumber: "P1234567A",
      status: "Approved",
      registrationDate: DateTime(2025, 5, 21, 15, 45, 0)
    ),
    VisitorDetails(
      photo: "https://example.com/visitor_photos/N01-23-456789_Juan_Reyes_Dela_Cruz.jpg",
      firstName: "Juan",
      middleName: "Reyes",
      lastName: "Dela Cruz",
      fullName: "Juan Reyes Dela Cruz",
      contactNumber: "09209876543",
      idType: "Driver's License",
      idNumber: "N01-23-456789",
      status: "Pending",
      registrationDate: DateTime(2025, 5, 20, 10, 0, 0)
    ),
    VisitorDetails(
      photo: "https://example.com/visitor_photos/CRN-0001-2345678-9_Ana_Lim_Santos.jpg",
      firstName: "Ana",
      middleName: "Lim",
      lastName: "Santos",
      fullName: "Ana Lim Santos",
      contactNumber: "09981122334",
      idType: "UMID Card",
      idNumber: "CRN-0001-2345678-9",
      status: "Denied",
      registrationDate: DateTime(2025, 5, 19, 11, 30, 0)
    ),
    VisitorDetails(
      photo: "https://example.com/visitor_photos/PHL-0000-0000-1234_Jose_Reyes.jpg",
      firstName: "Jose",
      middleName: "",
      lastName: "Reyes",
      fullName: "Jose Reyes",
      contactNumber: "09175551234",
      idType: "National ID",
      idNumber: "PHL-0000-0000-1234",
      status: "Approved",
      registrationDate: DateTime(2025, 5, 18, 9, 15, 0)
    ),
    VisitorDetails(
      photo: "https://example.com/visitor_photos/V-98765432_Sofia_Garcia.jpg",
      firstName: "Sofia",
      middleName: "Cruz",
      lastName: "Garcia",
      fullName: "Sofia Cruz Garcia",
      contactNumber: "09087654321",
      idType: "Postal ID",
      idNumber: "V-98765432",
      status: "Pending",
      registrationDate: DateTime(2025, 5, 17, 14, 0, 0)
    ),
    VisitorDetails(
      photo: "https://example.com/visitor_photos/B-11223344_Michael_Tan.jpg",
      firstName: "Michael",
      middleName: "",
      lastName: "Tan",
      fullName: "Michael Tan",
      contactNumber: "09998765432",
      idType: "PRC ID",
      idNumber: "B-11223344",
      status: "Approved",
      registrationDate: DateTime(2025, 5, 16, 16, 30, 0)
    ),
    VisitorDetails(
      photo: "https://example.com/visitor_photos/C-55667788_Catherine_Lee.jpg",
      firstName: "Catherine",
      middleName: "Sy",
      lastName: "Lee",
      fullName: "Catherine Sy Lee",
      contactNumber: "09182345678",
      idType: "Philippine Passport",
      idNumber: "C-55667788",
      status: "Approved",
      registrationDate: DateTime(2025, 5, 15, 8, 45, 0)
    ),
    VisitorDetails(
      photo: "https://example.com/visitor_photos/D-99001122_Robert_Lim.jpg",
      firstName: "Robert",
      middleName: "",
      lastName: "Lim",
      fullName: "Robert Lim",
      contactNumber: "09273456789",
      idType: "Driver's License",
      idNumber: "D-99001122",
      status: "Pending",
      registrationDate: DateTime(2025, 5, 14, 13, 0, 0)
    ),
    VisitorDetails(
      photo: "https://example.com/visitor_photos/E-33445566_Patricia_Corpuz.jpg",
      firstName: "Patricia",
      middleName: "Diaz",
      lastName: "Corpuz",
      fullName: "Patricia Diaz Corpuz",
      contactNumber: "09778901234",
      idType: "UMID Card",
      idNumber: "E-33445566",
      status: "Denied",
      registrationDate: DateTime(2025, 5, 13, 10, 10, 0)
    ),
    VisitorDetails(
      photo: "https://example.com/visitor_photos/F-77889900_Daniel_Santiago.jpg",
      firstName: "Daniel",
      middleName: "",
      lastName: "Santiago",
      fullName: "Daniel Santiago",
      contactNumber: "09156789012",
      idType: "National ID",
      idNumber: "F-77889900",
      status: "Approved",
      registrationDate: DateTime(2025, 5, 12, 17, 0, 0)
    ),
    VisitorDetails(
      photo: "https://example.com/visitor_photos/G-11223344_Michelle_Chua.jpg",
      firstName: "Michelle",
      middleName: "Go",
      lastName: "Chua",
      fullName: "Michelle Go Chua",
      contactNumber: "09091234567",
      idType: "Postal ID",
      idNumber: "G-11223344",
      status: "Pending",
      registrationDate: DateTime(2025, 5, 11, 9, 30, 0)
    ),
    VisitorDetails(
      photo: "https://example.com/visitor_photos/H-55667788_Kevin_Yu.jpg",
      firstName: "Kevin",
      middleName: "",
      lastName: "Yu",
      fullName: "Kevin Yu",
      contactNumber: "09170001122",
      idType: "PRC ID",
      idNumber: "H-55667788",
      status: "Approved",
      registrationDate: DateTime(2025, 5, 10, 14, 15, 0)
    )
  ];
  // TODO: change values once backend is done

  List<VisitorDetails> get filteredRows {
    return visitorDetails.where((row) {
      final matchesSearch = row.fullName.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesStatus = selectedStatus == null || row.status == selectedStatus;
      return matchesSearch && matchesStatus;
    }).toList();
  }
  
  List<VisitorDetails> get paginatedRows {
    final start = currentPage * rowsPerPage;
    final end = (start + rowsPerPage).clamp(0, visitorDetails.length);
    return filteredRows.sublist(start, end);
  }

  int get totalPages => (filteredRows.length / rowsPerPage).ceil();
  Widget _buildPagination() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: currentPage > 0 ? () => setState(() => currentPage--) : null,
          color: AppColors.kDarkBlue,
        ),
        Text(
          '${currentPage + 1}/$totalPages',
          style: AppTextStyles.defaultStyle,
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: currentPage < totalPages - 1 ? () => setState(() => currentPage++) : null,
          color: AppColors.kDarkBlue,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppConstants.kAppPadding,
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SearchBarWidget(
              searchQuery: searchQuery, 
              onSearchChanged: (searchbarValue) {
                setState(() {
                  searchQuery = searchbarValue;
                });
              }, 
              onSearchPressed: () {
                // TODO: handle search
              }, 
              onToggleFilter: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      child: StatefulBuilder(
                        builder: (context, setDialogState) {
                          return FilterPopupWidget(
                            startDate: startDate, 
                            endDate: endDate, 
                            onStartDatePicked: (pickedDate) {
                              setState(() {
                                setDialogState(() {
                                  startDate = pickedDate;
                                });
                              });
                            }, 
                            onEndDatePicked: (pickedDate) {
                              setState(() {
                                setDialogState(() {
                                  endDate = pickedDate;
                                });
                              });
                            }, 
                            onConfirm: () {
                              context.pop();
                            }
                          );
                        }
                      )
                    );
                  }
                );
              }, 
              isFilterVisible: false, // TODO: clarify
            ),
          ),
          SizedBox(height: 20),
          Flexible(
            child: SingleChildScrollView(
              child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  // Table Headers
                  TableRow(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: AppColors.kGray
                        )
                      )
                    ),
                    children: [
                      TableHeader(
                        text: "Photo"
                      ),
                      TableHeader(
                        text: "Name"
                      ),
                      TableHeader(
                        text: "Contact Number"
                      ),
                      TableHeader(
                        text: "ID Type"
                      ),
                      TableHeader(
                        text: "ID Number"
                      ),
                      TableHeader(
                        text: "Status"
                      ),
                      TableHeader(
                        text: "Registration Date"
                      ),
                      TableHeader(
                        text: "Actions"
                      ),
                    ]
                  ),
                  // Table Values
                  ...paginatedRows.map((row) {
                    return TableRow(
                      children: [
                        TableCellWidget(
                          child: Image.asset(
                            'assets/images/admin_photo.png',
                            width: 70,
                            height: 70,
                          ) // TODO: change to Image.network
                        ), 
                        TableCellWidget(
                          text: row.fullName
                        ),
                        TableCellWidget(
                          text: row.contactNumber
                        ),
                        TableCellWidget(
                          text: row.idType
                        ),
                        TableCellWidget(
                          text: row.idNumber
                        ),
                        TableCellWidget(
                          text: row.status
                        ),
                        TableCellWidget(
                          text: DateFormat('MMM d, y H:m').format(row.registrationDate)
                        ),
                        TableCellWidget(
                          child: Row(
                            children: [
                              AppButtonWidget(
                                onTap: () {},
                                width: 40,
                                height: 40,
                                color: Colors.transparent,
                                child: Padding(
                                  padding: EdgeInsets.all(0),
                                  child: Image.asset(
                                    "assets/images/edit_icon.png",
                                    width: 20,
                                    height: 20,
                                  )
                                )
                              ) // TODO: finalize
                            ]
                          )
                        )
                      ]
                    );
                  })
                ]
              ),
            ),
          ),
          _buildPagination()
        ]
      ),
    );
  }
}

class TableHeader extends StatelessWidget {
  const TableHeader({
    this.text,
    this.child,
    super.key
  });

  final String? text;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    if (text != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8
        ),
        child: Text(
          text!,
          style: AppTextStyles.defaultStyle.copyWith(
            fontWeight: FontWeight.w900
          )
        ),
      );
    } else {
      return child!;
    }
  }
}

class TableCellWidget extends StatelessWidget {
  const TableCellWidget({
    this.text,
    this.child,
    super.key
  });

  final String? text;
  final Widget? child;

  static const double topPadding = 16;

  @override
  Widget build(BuildContext context) {
    if (text != null) {
      return Padding(
        padding: const EdgeInsets.only(
          top: topPadding,
        ),
        child: Text(
          text!,
          style: AppTextStyles.defaultStyle.copyWith(
            color: AppColors.kDarkGray
          )
        )
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(
          top: topPadding
        ),
        child: child!
      );
    }
  }
}