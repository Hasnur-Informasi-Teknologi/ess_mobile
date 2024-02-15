import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
import 'package:mobile_ess/controllers/user_management_controller.dart';
import 'package:mobile_ess/models/user_management_model.dart';
import 'package:mobile_ess/themes/constant.dart';
import 'package:mobile_ess/widgets/title_widget.dart';

class UserManagement extends StatefulWidget {
  const UserManagement({super.key});

  @override
  State<UserManagement> createState() => _UserManagementState();
}

class _UserManagementState extends State<UserManagement> {
  final UserManagementController userManagementController =
      Get.put(UserManagementController());
  bool sort = true;
  List<UserManagementModel>? filterData;
  // int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  // int _rowsPerPage1 = PaginatedDataTable.defaultRowsPerPage;

  // onsortColum(int columnIndex, bool ascending) {
  //   if (columnIndex == 0) {
  //     if (ascending) {
  //       filterData!.sort((a, b) => a.name!.compareTo(b.name!));
  //     } else {
  //       filterData!.sort((a, b) => b.name!.compareTo(a.name!));
  //     }
  //   }
  // }

  @override
  void initState() {
    filterData = userManagementController.items;
    super.initState();
  }

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // var dataku = RowSource(
    //   userManagementController.items,
    //   count: 10,
    // );
    // var tableItemsCount = dataku.rowCount;
    // var defaultRowsPerPage = PaginatedDataTable.defaultRowsPerPage;
    // var isRowCountLessDefaultRowsPerPage = tableItemsCount < defaultRowsPerPage;

    Size size = MediaQuery.of(context).size;
    // double textSmall = size.width * 0.027;
    double paddingHorizontalNarrow = size.width * 0.035;
    // double padding8 = size.width * 0.0188;
    // double padding10 = size.width * 0.023;

    Widget header() {
      return AppBar(
        title: const Text("User Management"),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
            // Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
      );
    }

    handleButtonAdd() {
      return showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          builder: (context) {
            return Container(
              margin: EdgeInsets.symmetric(
                horizontal: paddingHorizontalNarrow,
                vertical: paddingHorizontalNarrow,
              ),
              height: size.height,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TitleWidget(title: "NRP"),
                  TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    )),
                  ),
                ],
              ),
            );
          });
    }

    Widget content() {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(primaryYellow),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextButton(
                    onPressed: handleButtonAdd,
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.add,
                          color: Colors.black,
                        ),
                        SizedBox(),
                        Text(
                          'Add user',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xff002B5B),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextButton(
                    onPressed: () {},
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.description,
                          color: Colors.white,
                        ),
                        SizedBox(),
                        Text(
                          'Export',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      );
    }

    Widget data() {
      // _rowsPerPage = isRowCountLessDefaultRowsPerPage
      //     ? tableItemsCount
      //     : defaultRowsPerPage;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
            child: Container(
              height: 40,
              width: 200,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(10)),
              child: TextFormField(
                controller: controller,
                decoration: const InputDecoration(hintText: "Search"),
                onChanged: (value) {
                  setState(() {
                    userManagementController.items.value = filterData!
                        .where((element) => element.name.contains(value))
                        .toList();
                  });
                },
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Obx(
            () => userManagementController.items.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).canvasColor,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Theme(
                            data: ThemeData.light().copyWith(
                                cardColor: Theme.of(context).canvasColor),
                            child: PaginatedDataTable(
                              sortColumnIndex: 1,
                              sortAscending: sort,
                              // header:
                              source: RowSource(userManagementController.items
                                  // count: userManagementController.items.length,
                                  ),
                              rowsPerPage: userManagementController.perPage,
                              // isRowCountLessDefaultRowsPerPage
                              //     ? _rowsPerPage
                              //     : _rowsPerPage1,
                              onRowsPerPageChanged: (int? rowIndex) {
                                if ((rowIndex! + 1) %
                                        userManagementController.perPage ==
                                    1) {
                                  userManagementController.nextPage(1);
                                }
                              },
                              // isRowCountLessDefaultRowsPerPage
                              //     ? null
                              //     : (rowCount) {
                              //         setState(() {
                              //           _rowsPerPage1 = 5;
                              //         });
                              //       },
                              columnSpacing: 10,
                              columns: const [
                                DataColumn(
                                  label: Text(
                                    "No",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14),
                                  ),
                                  // onSort: (columnIndex, ascending) {
                                  //   setState(() {
                                  //     sort = !sort;
                                  //   });

                                  //   onsortColum(columnIndex, ascending);
                                  // },
                                ),
                                DataColumn(
                                  label: Text(
                                    "NRP",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Nama",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Email",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Role",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Entitas",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Pangkat",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Status",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Aksi",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        // ignore: sized_box_for_whitespace
        child: Container(
          height: size.height,
          // width: size.width,
          child: Column(
            children: [
              header(),
              content(),
              data(),
            ],
          ),
        ),
      ),
    );
  }
}

class RowSource extends DataTableSource {
  final List<UserManagementModel>? itemss;
  // ignore: prefer_typing_uninitialized_variables
  // var myData;
  // ignore: prefer_typing_uninitialized_variables
  // final count;
  // final UserManagementController userManagementController =
  //     Get.put(UserManagementController());
  // final List<String> data = List.generate(100, (index) => 'Data ${index + 1}');
  RowSource(
    RxList<UserManagementModel> items,
    // RxList<UserManagementModel> myData,
    {
    this.itemss,
    // required this.myData,
    // required this.count,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= itemss!.length) return null;
    final items = itemss![index];
    return DataRow(cells: [
      const DataCell(Text('')),
      DataCell(Text(items.nrp.toString())),
      DataCell(Text(items.name)),
      DataCell(Text(items.email)),
      DataCell(Text(items.role.toString())),
      DataCell(Text(items.entitas.toString())),
      DataCell(Text(items.pangkat.toString())),
      DataCell(Text(items.status.toString())),
      const DataCell(
        Row(
          children: [
            Icon(Icons.edit, color: Colors.green),
            Icon(Icons.delete, color: Colors.red),
          ],
        ),
      ),
    ]);
    // if (index < rowCount) {
    //   return null;
    // } else
    //   // ignore: curly_braces_in_flow_control_structures
    //   return recentFileDataRow(userManagementController.myData[index]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => itemss!.length;

  @override
  int get selectedRowCount => 0;
}

// DataRow recentFileDataRow(var data) {
//   return DataRow(
//     cells: [
//       const DataCell(Text('')),
//       DataCell(Text(data.nrp ?? "NRP")),
//       DataCell(Text(data.name ?? "Nama")),
//       DataCell(Text(data.email ?? "Email")),
//       DataCell(Text(data.role ?? "Role")),
//       DataCell(Text(data.entitas ?? "Entitas")),
//       DataCell(Text(data.pangkat ?? "Pangkat")),
//       DataCell(Text(data.status ?? "Status")),
//       const DataCell(
//         Row(
//           children: [
//             Icon(Icons.edit, color: Colors.green),
//             Icon(Icons.delete, color: Colors.red),
//           ],
//         ),
//       ),
//     ],
//   );
// }
