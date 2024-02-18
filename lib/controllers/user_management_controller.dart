// import 'dart:developer';

// import 'package:get/get.dart';
// import 'package:mobile_ess/models/user_management_model.dart';
// import 'package:mobile_ess/services/user_managamenet.service.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class UserManagementController extends GetxController {
//   var items = <UserManagementModel>[].obs;
//   var isLoading = false.obs;
//   // List<UserManagementModel> get _items => items;
//   var currentPage = 1.obs;
//   var perPage = 10;

//   @override
//   void onInit() {
//     getData();
//     super.onInit();
//   }

//   Future<String?> getToken() async {
//     final SharedPreferences token = await SharedPreferences.getInstance();
//     return token.getString('token');
//   }

//   Future<void> getData() async {
//     final String? token = await getToken();
//     try {
//       isLoading(true);
//       final getDataItems = await UserManagementService.getData(
//           token.toString(), currentPage.value, perPage);
//       items.assignAll(getDataItems);
//       log('${getDataItems}');
//       // if (getDataItems != null) {
//       //   items.assignAll(getDataItems);
//       // }
//       // items.assignAll(
//       //     getDataItems.map((items) => UserManagementModel.fromJson(items)));
//     } catch (e) {
//       print('token: $token');
//       print('$e');
//       // print('$items');
//     } finally {
//       isLoading(false);
//     }
//   }

//   void addItem(UserManagementModel newItem) {
//     items.add(newItem);
//   }

//   void nextPage(int i) {
//     currentPage++;
//     getData();
//   }
// }
