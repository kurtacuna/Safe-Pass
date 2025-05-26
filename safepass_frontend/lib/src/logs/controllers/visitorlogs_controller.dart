import "package:flutter/material.dart";
// import 'package:http/http.dart' as http;
// import '../models/visitor_logs_model.dart';
// import '../constants/api_urls.dart';
// import '../../common/widgets/snackbar_widget.dart';
// import '../../utils/storage.dart';
// import '../../utils/storage_keys.dart';
// import '../../utils/refetch.dart';
// import 'dart:convert';

class VisitorlogsController with ChangeNotifier {
//   bool _isLoading = false;
//   int _statusCode = -1;
//   List<VisitorLogsModel> _visitorLogs = [];

//   bool get getIsLoading => _isLoading;
//   int get getStatusCode => _statusCode;
//   List<VisitorLogsModel> get getVisitorLogs => _visitorLogs;

//   Future<void> fetchVisitorLogs(BuildContext context) async {
//     _statusCode = -1;
//     _isLoading = true;
//     notifyListeners();

//     try {
//       String? accessToken = Storage().getString(StorageKeys.accessTokenKey);
//       var url = Uri.parse(VisitorLogsApiUrls.getVisitorLogsUrl);
//       var response = await http.get(
//         url,
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $accessToken"
//         },
//       );

//       if (response.statusCode == 200) {
//         _statusCode = response.statusCode;
//         // Parse the response and update the visitor logs list
//         List<dynamic> logsJson = json.decode(response.body);
//         _visitorLogs = logsJson.map((log) => VisitorLogsModel.fromJson(log)).toList();
//       } else if (response.statusCode == 401) {
//         if (context.mounted) {
//           await refetch(
//             fetch: () => fetchVisitorLogs(context)
//           );
//         }
//       } else {
//         if (context.mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             appErrorSnackBarWidget(context: context, text: "Failed to fetch visitor logs")
//           );
//         }
//       }
//     } catch (e) {
//       print("VisitorlogsController fetchVisitorLogs:");
//       print(e);
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   Future<void> createVisitorLog(
//     BuildContext context,
//     VisitorLogsModel visitorLog,
//   ) async {
//     _statusCode = -1;
//     _isLoading = true;
//     notifyListeners();

//     try {
//       String? accessToken = Storage().getString(StorageKeys.accessTokenKey);
//       var url = Uri.parse(VisitorLogsApiUrls.createVisitorLogUrl);
//       var response = await http.post(
//         url,
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $accessToken"
//         },
//         body: visitorLogsModelToJson(visitorLog)
//       );

//       if (response.statusCode == 201) {
//         _statusCode = response.statusCode;
//         if (context.mounted) {
//           await fetchVisitorLogs(context); // Refresh the list
//         }
//       } else if (response.statusCode == 401) {
//         if (context.mounted) {
//           await refetch(
//             fetch: () => createVisitorLog(context, visitorLog)
//           );
//         }
//       } else {
//         if (context.mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             appErrorSnackBarWidget(context: context, text: "Failed to create visitor log")
//           );
//         }
//       }
//     } catch (e) {
//       print("VisitorlogsController createVisitorLog:");
//       print(e);
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   Future<void> updateVisitorLog(
//     BuildContext context,
//     VisitorLogsModel visitorLog,
//   ) async {
//     _statusCode = -1;
//     _isLoading = true;
//     notifyListeners();

//     try {
//       String? accessToken = Storage().getString(StorageKeys.accessTokenKey);
//       var url = Uri.parse(VisitorLogsApiUrls.updateVisitorLogUrl);
//       var response = await http.put(
//         url,
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $accessToken"
//         },
//         body: visitorLogsModelToJson(visitorLog)
//       );

//       if (response.statusCode == 200) {
//         _statusCode = response.statusCode;
//         if (context.mounted) {
//           await fetchVisitorLogs(context); // Refresh the list
//         }
//       } else if (response.statusCode == 401) {
//         if (context.mounted) {
//           await refetch(
//             fetch: () => updateVisitorLog(context, visitorLog)
//           );
//         }
//       } else {
//         if (context.mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             appErrorSnackBarWidget(context: context, text: "Failed to update visitor log")
//           );
//         }
//       }
//     } catch (e) {
//       print("VisitorlogsController updateVisitorLog:");
//       print(e);
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
}