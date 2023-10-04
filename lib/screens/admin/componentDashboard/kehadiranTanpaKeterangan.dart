import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_ess/themes/constant.dart';
import 'package:mobile_ess/widgets/cupertino_datepicker_widget.dart';
import 'package:mobile_ess/widgets/request_attendance_table_widget.dart';
import 'package:mobile_ess/widgets/title_widget.dart';

class KehadiranTanpaKeterangan extends StatefulWidget {
  const KehadiranTanpaKeterangan({super.key});

  @override
  State<KehadiranTanpaKeterangan> createState() => KehadiranTanpaKeteranganState();
}

class KehadiranTanpaKeteranganState extends State<KehadiranTanpaKeterangan> {
  // ========================================================
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
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: paddingHorizontalWide, vertical: padding10),
          child: Column(
            children: [
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: paddingHorizontalWide),
                child: const TitleWidget(title: 'Demografi & Attendance'),
              ),
              Padding(
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
                          value: periodeValue,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors
                                .black, // Set the font size for the dropdown items
                          ),
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
                  ],
                ),
              ),
              // =======================
              Text(
                'Kehadiran Tanpa Keterangan',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                children: List.generate(40, (index) {
                  return Column(
                    children: [
                      Padding(
                          padding: EdgeInsets.only(left: 1, right: 1),
                          child: Container(
                              padding: EdgeInsets.all(
                                  12.0), // Adjust the padding as needed
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey
                                        .withOpacity(0.5), // Shadow color
                                    spreadRadius: 5, // Spread radius
                                    blurRadius: 10, // Blur radius
                                    offset: Offset(
                                        0, 3), // Offset in the y direction
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: sizedBoxHeightTall,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Budi Setiawan',
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: textSmall,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'PT Hasnur Informasi Teknologi',
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: textSmall,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5,),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Alasan',
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: textSmall,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      Text(
                                        'Lupa Absen',
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: textSmall,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5,),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Aksi',
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: textSmall,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          onPrimary: Color.fromARGB(221, 0, 8, 3),
                                          elevation: 5,
                                          primary: Color.fromARGB(255, 2, 166, 13),
                                          padding: EdgeInsets.symmetric(horizontal: 4),
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(2)),
                                          ),
                                        ),
                                        onPressed: () {},
                                        child: Text('Approve'),
                                      ),
                                    ],
                                  ),
                                ],
                              ))),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  );
                }),
              )
            ],
          ),
        ),
      ],
    );
  }
}
