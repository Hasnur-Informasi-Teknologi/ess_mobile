import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_ess/themes/constant.dart';
import 'package:mobile_ess/widgets/title_widget.dart';

class ProbationKaryawanScreen extends StatefulWidget {
  const ProbationKaryawanScreen({super.key});

  @override
  State<ProbationKaryawanScreen> createState() => _ProbationKaryawanScreenState();
}

class _ProbationKaryawanScreenState extends State<ProbationKaryawanScreen> {
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
        TitleWidget(title: 'Probation Karyawan'),
        SizedBox(height: 10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Karyawan',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: textSmall,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Posisi Entitas',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: textSmall,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Tanggal Berakhir',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: textSmall,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Column(
          children: List.generate(40, (index) {
            return GestureDetector(
              onTap: () {
                Get.defaultDialog(
                    title: 'Probation Karyawan',
                    content: Column(
                      children: [
                        Center(
                          child: Container(
                            child: Center(
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                maxRadius: 23,
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  maxRadius: 20,
                                  backgroundImage: AssetImage(
                                      'assets/images/user-profile-default.png'),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "NRP",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "78220001",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Nama",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Budi Setiawan",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Posisi",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Programmer",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Entitas",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "PT Hasnur Informasi Teknologi",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Lokasi Kerja",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Banjarbaru",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Tanggal Berakhir",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "18 Juli 2023",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Tipe Kontrak",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Kontrak 1",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Status",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                onPrimary: Colors.black87,
                                elevation: 5,
                                primary: Color.fromARGB(255, 231, 35, 61),
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                              onPressed: () {},
                              child: Text(
                                'On Probation',
                                style: TextStyle(fontSize: 10),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              onPrimary: Colors.black87,
                              elevation: 5,
                              primary: Color(primaryYellow),
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(2)),
                              ),
                            ),
                            onPressed: () {},
                            child: Text('Update'),
                          ),
                        ),
                      ],
                    ));
              },
              child: Column(
                children: [
                  SizedBox(
                    height: sizedBoxHeightTall,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Container(
                            child: Center(
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                maxRadius: 23,
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  maxRadius: 20,
                                  backgroundImage: AssetImage(
                                      'assets/images/user-profile-default.png'),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            'Budi Setiawan',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: textSmall,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Text(
                            'NRP : 78220001',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: textSmall,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'UI/UX Designer',
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
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          onPrimary: Colors.black87,
                          elevation: 10,
                          primary: Color.fromARGB(255, 27, 213, 120),
                          padding: EdgeInsets.symmetric(horizontal: 7),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                        onPressed: () {},
                        child: Text(
                          '10/12/2023',
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        )
      ],
    );
  }
}
