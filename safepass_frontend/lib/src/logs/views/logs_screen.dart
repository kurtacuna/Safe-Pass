import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/visitorlogs_controller.dart';
import '../models/visitor_logs_model.dart';
import 'package:safepass_frontend/common/const/app_theme/app_text_styles.dart';
import 'package:safepass_frontend/common/const/kcolors.dart';
import 'package:safepass_frontend/common/const/kconstants.dart';
import 'package:safepass_frontend/src/logs/widgets/filter_popup_widget.dart';
import 'package:safepass_frontend/src/logs/widgets/search_bar_widget.dart';

class LogsScreen extends StatefulWidget {
  const LogsScreen({super.key});

  @override
  State<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen> {
  static const int logsPerPage = 10;
  int currentPage = 0;

  String searchQuery = '';
  String? selectedStatus;
  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    // Fetch visitor logs when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VisitorLogsController>().getVisitorLogs(context);
    });
  }

  List<VisitorLog> _getFilteredLogs(List<VisitorLog> logs) {
    return logs.where((log) {
      final matchesSearch = log.visitorName.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesStatus = selectedStatus == null || log.status == selectedStatus;
      return matchesSearch && matchesStatus;
    }).toList();
  }

  List<VisitorLog> _getPaginatedLogs(List<VisitorLog> filteredLogs) {
    final start = currentPage * logsPerPage;
    final end = (start + logsPerPage).clamp(0, filteredLogs.length);
    return filteredLogs.sublist(start, end);
  }

  int _getTotalPages(List<VisitorLog> filteredLogs) {
    return (filteredLogs.length / logsPerPage).ceil();
  }

  void _resetFilters() {
    setState(() {
      selectedStatus = null;
      startDate = null;
      endDate = null;
      searchQuery = '';
      currentPage = 0;
    });
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: FilterPopupWidget(
            startDate: startDate,
            endDate: endDate,
            onStartDatePicked: (picked) => setState(() => startDate = picked),
            onEndDatePicked: (picked) => setState(() => endDate = picked),
            onConfirm: () => Navigator.of(context).pop(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kWhite,
      body: SafeArea(
        child: Consumer<VisitorLogsController>(
          builder: (context, controller, _) {
            if (controller.isLoading) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Loading visitor logs...'),
                  ],
                ),
              );
            }

            if (controller.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(controller.error!),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => controller.getVisitorLogs(context),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (controller.visitorLogs.isEmpty) {
              return const Center(
                child: Text('No visitor logs found'),
              );
            }

            final filteredLogs = _getFilteredLogs(controller.visitorLogs);
            final paginatedLogs = _getPaginatedLogs(filteredLogs);
            final totalPages = _getTotalPages(filteredLogs);

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildHeader(),
                        const SizedBox(height: 32),
                        SearchBarWidget(
                          searchQuery: searchQuery,
                          onSearchChanged: (value) => setState(() {
                            searchQuery = value;
                            currentPage = 0;
                          }),
                          onSearchPressed: () => setState(() => currentPage = 0),
                          onToggleFilter: _showFilterDialog,
                          isFilterVisible: false,
                          filterPopup: null,
                        ),
                        const SizedBox(height: 24),
                        _buildTable(paginatedLogs),
                        const SizedBox(height: 24),
                        _buildPagination(totalPages),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              'Visitation Logs',
              style: AppTextStyles.bigStyle.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 8),
            Image.asset(
              'assets/images/visitor_logs_icon.png',
              height: 20,
              width: 20,
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () {
            // export logic
          },
          icon: const Icon(Icons.download),
          label: const Text("Export CSV"),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.kDarkBlue,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildTable(List<VisitorLog> logs) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: AppConstants.kAppBorderRadius,
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(255, 238, 232, 232),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildTableHeader(),
          const Divider(),
          ...logs.map((log) => _buildLogRow(log)).toList(),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Row(
      children: const [
        _HeaderText('Name'),
        _HeaderText('Check-in Time'),
        _HeaderText('Check-out Time'),
        _HeaderText('Visit Purpose'),
        _HeaderText('Status'),
      ],
    );
  }

  Widget _buildLogRow(VisitorLog log) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(child: Text(log.visitorName)),
          Expanded(child: Text(log.checkInTime)),
          Expanded(child: Text(log.checkOutTime ?? '-')),
          Expanded(child: Text(log.purpose)),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: log.status.toLowerCase() == 'active' 
                    ? Colors.green.withOpacity(0.2)
                    : Colors.red.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                log.status,
                style: TextStyle(
                  color: log.status.toLowerCase() == 'active' 
                      ? Colors.green.shade800
                      : Colors.red.shade800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPagination(int totalPages) {
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
}

class _HeaderText extends StatelessWidget {
  final String text;
  const _HeaderText(this.text);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        text,
        style: AppTextStyles.defaultStyle.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}
