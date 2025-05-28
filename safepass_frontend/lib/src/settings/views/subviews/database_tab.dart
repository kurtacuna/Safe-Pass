import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:provider/provider.dart";
import "package:safepass_frontend/common/const/app_theme/app_text_styles.dart";
import "package:safepass_frontend/common/const/kcolors.dart";
import "package:safepass_frontend/common/const/kconstants.dart";
import "package:safepass_frontend/common/widgets/app_button_widget.dart";
import "package:safepass_frontend/common/widgets/app_circular_progress_indicator_widget.dart";
import "package:safepass_frontend/src/logs/widgets/filter_popup_widget.dart";
import "package:safepass_frontend/src/logs/widgets/search_bar_widget.dart";
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

  static const rowsPerPage = 10;
  int currentPage = 0;

  ScrollController scrollController = ScrollController();
  List<Visitor> visitorDetails = [];


  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SettingsTabNotifier>().fetchVisitors(context);
    });

    super.initState();
  }

  List<Visitor> get filteredRows {
    return visitorDetails.where((row) {
      final matchesSearch = row.fullName.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesStatus = selectedStatus == null || row.status == selectedStatus;
      return matchesSearch && matchesStatus;
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
                endDate: endDate,
                selectedStatus: selectedStatus,
                onStartDatePicked: (picked) {
                  setState(() {
                    startDate = picked;
                    currentPage = 0;
                  });
                  setModalState(() {});
                },
                onEndDatePicked: (picked) {
                  setState(() {
                    endDate = picked;
                    currentPage = 0;
                  });
                  setModalState(() {});
                },
                onStatusChanged: (status) {
                  setState(() {
                    selectedStatus = status;
                    currentPage = 0;
                  });
                  setModalState(() {});
                },
                // selectedPurpose: selectedPurpose,
                // onPurposeChanged: (purpose) {
                //   setState(() {
                //     selectedPurpose = purpose;
                //     currentPage = 0;
                //   });
                //   setModalState(() {});
                // },
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

  @override
  Widget build(BuildContext context) {
    if (context.watch<SettingsTabNotifier>().getIsLoading || visitorDetails == []) {
      return Center(child: AppCircularProgressIndicatorWidget());
    }

    visitorDetails = context.read<SettingsTabNotifier>().getVisitorDetails;

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
                      child: SearchBarWidget(
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
                                onTap: () {},
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