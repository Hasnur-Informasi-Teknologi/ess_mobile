import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_ess/themes/constant.dart';
import 'package:mobile_ess/widgets/title_widget.dart';

class TaskMenuDashboardController extends GetxController {
  var status = "Kehadiran".obs;
}

class TaskMenuDashboardScreen extends StatefulWidget {
  const TaskMenuDashboardScreen({super.key});

  @override
  State<TaskMenuDashboardScreen> createState() =>
      TaskMenuDashboardScreenState();
}

class TaskMenuDashboardScreenState extends State<TaskMenuDashboardScreen> {
  // ========================================================
  TaskMenuDashboardController x = Get.put(TaskMenuDashboardController());
  Map<String, String> entitasValues = {
    '1': 'Entitas',
  };
  String? entitasValue = '1'; // Default value
  // ========================================================
  Map<String, String> lokasiValues = {
    '1': 'Lokasi Kerja',
  };
  String? lokasiValue = '1'; // Default value
  // ========================================================
  Map<String, String> periodeValues = {
    '1': 'Periode',
  };
  String? periodeValue = '1'; // Default value
  String lokasiKerja = 'Lokasi Kerja';
  String periode = 'Periode';
  String pangkat = '';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textSmall = size.width * 0.027;
    double paddingHorizontalWide = size.width * 0.0585;
    double padding10 = size.width * 0.023;
    double sizedBoxHeightTall = size.height * 0.0163;
    double padding5 = size.width * 0.0115;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: paddingHorizontalWide),
              child: const TitleWidget(title: 'Employee Monitoring'),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: paddingHorizontalWide, vertical: padding10),
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: paddingHorizontalWide, vertical: padding10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 40,
                        padding: EdgeInsets.all(4),
                        margin: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color.fromARGB(
                                102, 158, 158, 158), // Set border color
                            width: 1, // Set border width
                          ),
                          borderRadius: BorderRadius.circular(
                              6), // BorderRadius -> .circular(12),all(10),only(topRight:Radius.circular(10)), vertical,horizontal
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: DropdownButton<String>(
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors
                                  .black, // Set the font size for the dropdown items
                            ),
                            value: entitasValue,
                            iconSize: 24,
                            elevation: 16,
                            onChanged: (String? newValue) {
                              setState(() {
                                entitasValue = newValue;
                              });
                            },
                            items: entitasValues.keys
                                .map<DropdownMenuItem<String>>((String id) {
                              return DropdownMenuItem<String>(
                                value: id,
                                child: Text(entitasValues[id]!),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      Container(
                        height: 40,
                        padding: EdgeInsets.all(4),
                        margin: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color.fromARGB(
                                102, 158, 158, 158), // Set border color
                            width: 1, // Set border width
                          ),
                          borderRadius: BorderRadius.circular(
                              6), // BorderRadius -> .circular(12),all(10),only(topRight:Radius.circular(10)), vertical,horizontal
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: DropdownButton<String>(
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors
                                  .black, // Set the font size for the dropdown items
                            ),
                            value: lokasiValue,
                            iconSize: 24,
                            elevation: 16,
                            onChanged: (String? newValue) {
                              setState(() {
                                lokasiValue = newValue;
                              });
                            },
                            items: lokasiValues.keys
                                .map<DropdownMenuItem<String>>((String id) {
                              return DropdownMenuItem<String>(
                                value: id,
                                child: Text(lokasiValues[id]!),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      Container(
                        height: 40,
                        padding: EdgeInsets.all(4),
                        margin: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color.fromARGB(
                                102, 158, 158, 158), // Set border color
                            width: 1, // Set border width
                          ),
                          borderRadius: BorderRadius.circular(
                              6), // BorderRadius -> .circular(12),all(10),only(topRight:Radius.circular(10)), vertical,horizontal
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: DropdownButton<String>(
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors
                                  .black, // Set the font size for the dropdown items
                            ),
                            value: periodeValue,
                            iconSize: 24,
                            elevation: 16,
                            onChanged: (String? newValue) {
                              setState(() {
                                periodeValue = newValue;
                              });
                            },
                            items: periodeValues.keys
                                .map<DropdownMenuItem<String>>((String id) {
                              return DropdownMenuItem<String>(
                                value: id,
                                child: Text(periodeValues[id]!),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      Container(
                        height: 40,
                        width: 100,
                        padding: EdgeInsets.all(4),
                        margin: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color.fromARGB(
                                102, 158, 158, 158), // Set border color
                            width: 1, // Set border width
                          ),
                          borderRadius: BorderRadius.circular(
                              6), // BorderRadius -> .circular(12),all(10),only(topRight:Radius.circular(10)), vertical,horizontal
                        ),
                        child: TextFormField(
                          style: TextStyle(fontSize: 12),
                          decoration: const InputDecoration(
                            hintText: 'Pangkat', // placeholder
                          ),
                          // onChanged: (val)=>vdata['Username']=val, // pilih salah satu
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: MediaQuery.of(context)
                    .size
                    .height, // tinggi nya sebanyak yang tersedia
                child: GridView.count(
                  primary: false,
                  childAspectRatio: 2 / 2, //lebar dan tinggi children
                  crossAxisCount: 3, // jumlah item per row
                  padding: const EdgeInsets.all(5),
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  children: [
                    MenuItem(
                      icon: Icon(Icons.person_search_outlined),
                      text:"Aplikasi Training"
                    ),
                    MenuItem(
                      icon: Icon(Icons.screen_search_desktop_outlined),
                      text:"Aplikasi Recruitment"
                    ),
                    MenuItem(
                      icon: Icon(Icons.edit_document),
                      text:"Hasil Interview"
                    ),
                    MenuItem(
                      icon: Icon(Icons.calendar_month_outlined),
                      text:"Pengajuan Cuti"
                    ),
                    MenuItem(
                      icon: Icon(Icons.calendar_month),
                      text:"Perpanjangan Cuti"
                    ),
                    MenuItem(
                      icon: Icon(Icons.av_timer_sharp),
                      text:"Pengajuan Lembur"
                    ),
                     MenuItem(
                      icon: Icon(Icons.car_crash_sharp),
                      text:"Pengajuan Perjalanan Dinas"
                    ),
                     MenuItem(
                      icon: Icon(Icons.person_pin_circle_rounded),
                      text:"Laporan Perjalanan Dinas"
                    ),
                     MenuItem(
                      icon: Icon(Icons.run_circle),
                      text:"Izin Keluar"
                    ),
                     MenuItem(
                      icon: Icon(Icons.hotel_sharp),
                      text:"Rawat Inap"
                    ),
                     MenuItem(
                      icon: Icon(Icons.health_and_safety),
                      text:"Rawat Jalan"
                    ),
                    
                     MenuItem(
                      icon: Icon(Icons.document_scanner),
                      text:"Surat Keterangan"
                    ),
                    
                     MenuItem(
                      icon: Icon(Icons.comment_bank_rounded),
                      text:"Bantuan Komunikasi"
                    ),
                    
                     MenuItem(
                      icon: Icon(Icons.event_repeat_rounded),
                      text:"Permintaan Hardware & Software"
                    ),
                    
                     MenuItem(
                      icon: Icon(Icons.present_to_all_outlined),
                      text:"Penilaian Kinerja Karyawan"
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


class MenuItem extends StatelessWidget {
  final icon;
  final text;
  const MenuItem({super.key,this.icon,this.text});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
                      Positioned(
                        top: 0,
                        right: 0,
                        child: CircleAvatar(
                          backgroundColor: Color(0xFFD60606),
                          maxRadius: 13,
                          child: CircleAvatar(
                            backgroundColor: Colors.red,
                            maxRadius: 10,
                            child: Text(
                              "1",
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(167, 246, 249, 252),
                          border: Border.all(
                              color: Color.fromARGB(150, 182, 183, 184),
                              width:
                                  2), // .symmetric(horizontal: BorderSide(color: Colors.blue,width:2),vertical: BorderSide(color: Colors.blue,width:2))
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Center(
                                child: CircleAvatar(
                                  backgroundColor:
                                      Color.fromARGB(255, 255, 209, 41),
                                  maxRadius: 23,
                                  child: CircleAvatar(
                                    maxRadius: 20,
                                    child: this.icon,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: 
                            Center(
                              child: Text(
                                this.text,
                                style: TextStyle(fontSize: 10),
                              ),
                            )
                            ),
                          ],
                        )),
                      ),
                    ]);
  }
}