import 'package:flutter/material.dart';
import 'package:safepass_frontend/src/dashboard/models/visitor_log_model.dart';
import 'package:safepass_frontend/common/utils/widgets/visitor_logs.dart';
import 'package:safepass_frontend/common/const/app_theme/app_text_styles.dart';
import 'package:safepass_frontend/common/const/kcolors.dart';
import 'package:safepass_frontend/common/const/kconstants.dart';

class VisitorLogsWidget extends StatefulWidget {
  const VisitorLogsWidget({super.key});

  @override
  State<VisitorLogsWidget> createState() => _VisitorLogsWidgetState();
}

class _VisitorLogsWidgetState extends State<VisitorLogsWidget> {
  static const int logsPerPage = 5;
  int currentPage = 0;

  List<VisitorLog> get paginatedLogs {
    final start = currentPage * logsPerPage;
    final end = (start + logsPerPage).clamp(0, visitorLogList.length);
    return visitorLogList.sublist(start, end);
  }

  int get totalPages => (visitorLogList.length / logsPerPage).ceil();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(32),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Visitation Logs',
                  style: AppTextStyles.bigStyle.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Image.asset(
                  'assets/images/visitor_logs_icon.png',
                  height: 24,
                  width: 24,
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _HeaderText('Name'),
                _HeaderText('Check-in Time'),
                _HeaderText('Check-out Time'),
                _HeaderText('Visit Purpose'),
                _HeaderText('Status'),
              ],
            ),
            const Divider(thickness: 1.5),
            ...paginatedLogs.map(
              (log) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _DataText(log.name),
                    _DataText(log.checkIn),
                    _DataText(log.checkOut == "-" ? "" : log.checkOut),
                    _DataText(log.purpose),
                    _DataText(log.status),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${currentPage + 1}/$totalPages',
                  style: AppTextStyles.defaultStyle.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: currentPage > 0
                          ? () => setState(() => currentPage--)
                          : null,
                      color: AppColors.kDarkBlue,
                      iconSize: 28,
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: currentPage < totalPages - 1
                          ? () => setState(() => currentPage++)
                          : null,
                      color: AppColors.kDarkBlue,
                      iconSize: 28,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
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

class _DataText extends StatelessWidget {
  final String text;
  const _DataText(this.text);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        text,
        style: AppTextStyles.defaultStyle.copyWith(color: Colors.black54),
      ),
    );
  }
}
