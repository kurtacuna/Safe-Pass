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
      child: SizedBox(
        width: 900,
        child: Container(
          margin: const EdgeInsets.all(24),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Visitation logs',
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
              const SizedBox(height: 20),
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
              const Divider(),
              ...paginatedLogs.map(
                (log) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
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
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${currentPage + 1}/$totalPages',
                    style: AppTextStyles.defaultStyle,
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: currentPage > 0
                            ? () => setState(() => currentPage--)
                            : null,
                        color: AppColors.kDarkBlue
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward),
                        onPressed: currentPage < totalPages - 1
                            ? () => setState(() => currentPage++)
                            : null,
                        color: AppColors.kDarkBlue
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
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
