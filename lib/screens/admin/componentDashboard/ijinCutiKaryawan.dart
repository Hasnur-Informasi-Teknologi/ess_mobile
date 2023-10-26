import 'package:flutter/material.dart';
import 'package:mobile_ess/widgets/title_widget.dart';

class IjinCutiKaryawan extends StatefulWidget {
  const IjinCutiKaryawan({super.key});

  @override
  State<IjinCutiKaryawan> createState() => IjinCutiKaryawanState();
}

class IjinCutiKaryawanState extends State<IjinCutiKaryawan> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textSmall = size.width * 0.027;
    double paddingHorizontalWide = size.width * 0.0585;
    double padding10 = size.width * 0.023;
    double sizedBoxHeightTall = size.height * 0.0163;

    return Column(
      children: [
        Text(
                'Daftar Cuti Karyawan',
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
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(10.0),
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
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Keterangan',
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: textSmall,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      Text(
                                        'Cuti Tahunan Dibayar',
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: textSmall,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Keperluan Cuti',
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: textSmall,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      Text(
                                        'Liburan',
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: textSmall,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Tanggal Mulai',
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: textSmall,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      Text(
                                        '10/12/2023',
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: textSmall,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Tanggal Berakhir',
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: textSmall,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      Text(
                                        '10/12/2023',
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: textSmall,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Jumlah Cuti Yang diambil',
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: textSmall,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      Text(
                                        '2 days',
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: textSmall,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Tanggal Kembali Kerja',
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: textSmall,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      Text(
                                        '10/23/20',
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: textSmall,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w300,
                                        ),
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
    );
  }
}
