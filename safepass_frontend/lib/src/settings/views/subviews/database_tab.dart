import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:provider/provider.dart";
import "package:safepass_frontend/common/const/app_theme/app_text_styles.dart";
import "package:safepass_frontend/common/const/kcolors.dart";
import "package:safepass_frontend/common/const/kconstants.dart";
import "package:safepass_frontend/common/const/kurls.dart";
import "package:safepass_frontend/common/widgets/app_button_widget.dart";
import "package:safepass_frontend/common/widgets/app_circular_progress_indicator_widget.dart";
import "package:safepass_frontend/src/entrypoint/controllers/sidebar_notifier.dart";
import "package:safepass_frontend/src/logs/widgets/filter_popup_widget.dart";
import "package:safepass_frontend/src/logs/widgets/search_bar_widget.dart";
import "package:safepass_frontend/src/registration/controller/id_types_controller.dart";
import "package:safepass_frontend/src/settings/controllers/settings_tab_notifier.dart";
import "package:safepass_frontend/src/settings/models/visitor_details_model.dart";

class DatabaseTab extends StatefulWidget {
  const DatabaseTab({super.key});

  @override
  State<DatabaseTab> createState() => _DatabaseTabState();
}

class _DatabaseTabState extends State<DatabaseTab> {
  String searchQuery = '';
  String tempSearchQuery = '';
  DateTime? startDate;
  DateTime? endDate;
  String? selectedStatus;
  String? selectedIdType;

  static const rowsPerPage = 10;
  int currentPage = 0;

  ScrollController scrollController = ScrollController();
  List<Visitor> visitorDetails = [];

  List<String> statusItems = [
    "Approved",
    "Archived",
    "Denied"
  ];
  List<String> idTypeItems = [];


  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SettingsTabNotifier>().fetchVisitors(context);
      context.read<IdTypesController>().fetchIdTypes(context);
    });

    super.initState();
  }

  List<Visitor> get filteredRows {
  return visitorDetails.where((row) {
    final matchesSearch = row.fullName.toLowerCase().contains(searchQuery.toLowerCase()) || row.idNumber.toLowerCase().contains(searchQuery.toLowerCase());
    final matchesStatus = selectedStatus == null || row.status == selectedStatus;
    final matchesIdType = selectedIdType == null || row.idType.type == selectedIdType;

    // Normalize row.registrationDate to the start of the day
    final normalizedRegistrationDate = DateTime(row.registrationDate.year, row.registrationDate.month, row.registrationDate.day);

    // Normalize startDate to the start of its day
    final normalizedStartDate = startDate == null
        ? null
        : DateTime(startDate!.year, startDate!.month, startDate!.day);

    // Normalize endDate to the end of its day (23:59:59.999) for inclusive range
    final normalizedEndDate = endDate == null
        ? null
        : DateTime(endDate!.year, endDate!.month, endDate!.day, 23, 59, 59, 999);


    final matchesStart = normalizedStartDate == null ||
        normalizedRegistrationDate.isAtSameMomentAs(normalizedStartDate) || // Check if same day
        normalizedRegistrationDate.isAfter(normalizedStartDate);

    final matchesEnd = normalizedEndDate == null ||
        normalizedRegistrationDate.isAtSameMomentAs(normalizedEndDate) || // Check if same day
        normalizedRegistrationDate.isBefore(normalizedEndDate);

    return matchesSearch && matchesStatus && matchesIdType && matchesStart && matchesEnd;
  }).toList();
}
  
  List<Visitor> get paginatedRows {
    final start = currentPage * rowsPerPage;
    final end = (start + rowsPerPage).clamp(0, filteredRows.length);
    return filteredRows.sublist(start, end);
  }

  int get totalPages => (filteredRows.length / rowsPerPage).ceil();
  Widget _buildPagination() {
    return MediaQuery.sizeOf(context).height < 360
      ? Container()
      : Row(
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

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setModalState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: FilterPopupWidget(
                startDate: startDate,
                onStartDatePicked: (picked) {
                  setState(() {
                    startDate = picked;
                    currentPage = 0;
                  });
                  setModalState(() {});
                },
                endDate: endDate,
                onEndDatePicked: (picked) {
                  setState(() {
                    endDate = picked;
                    currentPage = 0;
                  });
                  setModalState(() {});
                },
                statusItems: statusItems,
                selectedStatus: selectedStatus,
                onStatusChanged: (status) {
                  setState(() {
                    selectedStatus = status;
                    currentPage = 0;
                  });
                  setModalState(() {});
                },
                idTypeItems: idTypeItems,
                selectedIdType: selectedIdType,
                onIdTypeChanged: (value) {
                  setState(() {
                    selectedIdType = value;
                    currentPage = 0;
                  });
                  setModalState(() {});
                },
                onConfirm: () {
                  Navigator.of(context).pop();
                },
              ),
            );
          },
        );
      },
    );
  }

  void _resetFilters() {
    setState(() {
      selectedStatus = null;
      selectedIdType = null;
      startDate = null;
      endDate = null;
      searchQuery = '';
      currentPage = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (context.watch<SettingsTabNotifier>().getIsLoading || visitorDetails == []) {
      return Center(child: AppCircularProgressIndicatorWidget());
    }

    if (context.watch<IdTypesController>().getIsLoading) {
      return Center(child: AppCircularProgressIndicatorWidget());
    }

    visitorDetails = context.read<SettingsTabNotifier>().getVisitorDetails;
    idTypeItems = context.read<IdTypesController>().getIdTypes.map((e) => e.type).toList();

    return Padding(
      padding: AppConstants.kAppPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MediaQuery.sizeOf(context).height < 320
            ? Container()
            : Column(
                children: [
                  Scrollbar(
                    controller: scrollController,
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      controller: scrollController,
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        spacing: 10,
                        children: [
                          SearchBarWidget(
                            searchQuery: tempSearchQuery, 
                            onSearchChanged: (value) {
                              setState(() {
                                tempSearchQuery = value;
                              });
                            },
                            onSearchPressed: () {
                              // TODO: handle search
                              setState(() {
                                searchQuery = tempSearchQuery;
                                currentPage = 0;
                              });
                            }, 
                            onToggleFilter: _showFilterDialog,
                            isFilterVisible: false, // TODO: clarify
                          ),
                          TextButton.icon(
                            onPressed: _resetFilters,
                            icon: const Icon(Icons.refresh),
                            label: const Text("Reset Filters"),
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.kDarkBlue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ]
              ),
          Flexible(
            child: SingleChildScrollView(
              child: Table(
                columnWidths: {
                  7: FractionColumnWidth(0.1)
                },
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
                  ...paginatedRows.asMap().entries.map((entry) {
                    int index = entry.key;
                    var row = entry.value;
                    return TableRow(
                      children: [
                        TableCellWidget(
                          child: Image.network(
                            ApiUrls.getImageUrl(row.photo),
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
                          text: row.idType.type
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
                          child: Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              AppButtonWidget(
                                onTap: () {
                                  context.read<SettingsTabNotifier>().setVisitor = index;
                                  context.read<SidebarNotifier>().setIndex = 3;
                                },
                                width: 20,
                                height: 20,
                                color: Colors.transparent,
                                child: Padding(
                                  padding: EdgeInsets.all(0),
                                  child: Image.asset(
                                    "assets/images/edit_icon.png",
                                    width: 20,
                                    height: 20,
                                  )
                                )
                              ),
                              AppButtonWidget(
                                onTap: () {},
                                width: 20,
                                height: 20,
                                color: Colors.transparent,
                                child: Padding(
                                  padding: EdgeInsets.all(0),
                                  child: Image.asset(
                                    "assets/images/archive_icon.png",
                                    width: 20,
                                    height: 20,
                                  )
                                )
                              ),
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
          vertical: 8,
          horizontal: 8,
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
          left: 8,
          right: 8,
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