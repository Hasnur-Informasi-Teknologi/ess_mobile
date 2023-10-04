import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_ess/widgets/text_form_field_widget.dart';
import 'package:mobile_ess/widgets/title_widget.dart';

class FormSuratKeterangan extends StatefulWidget {
  const FormSuratKeterangan({super.key});

  @override
  State<FormSuratKeterangan> createState() => _FormSuratKeteranganState();
}

class _FormSuratKeteranganState extends State<FormSuratKeterangan> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final double _maxHeightNama = 40.0;

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime(3000, 2, 1, 10, 20);
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightTall = size.height * 0.0163;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;
    double paddingHorizontalNarrow = size.width * 0.035;
    double padding5 = size.width * 0.0115;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
            // Navigator.pop(context);
          },
        ),
        title: const Text(
          'Surat Keterangan',
        ),
      ),
      body: ListView(
        children: [
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: sizedBoxHeightTall,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: TitleWidget(
                    title: 'Nomor Surat Keterangan',
                    fontWeight: FontWeight.w300,
                    fontSize: textMedium,
                  ),
                ),
                SizedBox(
                  height: sizedBoxHeightShort,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: TextFormFieldWidget(
                    controller: _namaController,
                    maxHeightConstraints: _maxHeightNama,
                    hintText: 'XX-XXXXXX',
                  ),
                ),
                SizedBox(
                  height: sizedBoxHeightExtraTall,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: const TitleWidget(title: 'Surat Dibuat Untuk'),
                ),
                SizedBox(
                  height: sizedBoxHeightExtraTall,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: TitleWidget(
                    title: 'NRP',
                    fontWeight: FontWeight.w300,
                    fontSize: textMedium,
                  ),
                ),
                SizedBox(
                  height: sizedBoxHeightShort,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: TextFormFieldWidget(
                    controller: _namaController,
                    maxHeightConstraints: _maxHeightNama,
                    hintText: 'NRP',
                  ),
                ),
                SizedBox(
                  height: sizedBoxHeightTall,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: TitleWidget(
                    title: 'Nama',
                    fontWeight: FontWeight.w300,
                    fontSize: textMedium,
                  ),
                ),
                SizedBox(
                  height: sizedBoxHeightShort,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: TextFormFieldWidget(
                    controller: _namaController,
                    maxHeightConstraints: _maxHeightNama,
                    hintText: 'Nama',
                  ),
                ),
                SizedBox(
                  height: sizedBoxHeightTall,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: TitleWidget(
                    title: 'Posisi',
                    fontWeight: FontWeight.w300,
                    fontSize: textMedium,
                  ),
                ),
                SizedBox(
                  height: sizedBoxHeightShort,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: TextFormFieldWidget(
                    controller: _namaController,
                    maxHeightConstraints: _maxHeightNama,
                    hintText: 'Posisi',
                  ),
                ),
                SizedBox(
                  height: sizedBoxHeightTall,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: TitleWidget(
                    title: 'Status Karyawan',
                    fontWeight: FontWeight.w300,
                    fontSize: textMedium,
                  ),
                ),
                SizedBox(
                  height: sizedBoxHeightShort,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: TextFormFieldWidget(
                    controller: _namaController,
                    maxHeightConstraints: _maxHeightNama,
                    hintText: 'Status Karyawan',
                  ),
                ),
                SizedBox(
                  height: sizedBoxHeightTall,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: TitleWidget(
                    title: 'Entitas',
                    fontWeight: FontWeight.w300,
                    fontSize: textMedium,
                  ),
                ),
                SizedBox(
                  height: sizedBoxHeightShort,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: TextFormFieldWidget(
                    controller: _namaController,
                    maxHeightConstraints: _maxHeightNama,
                    hintText: 'Entitas',
                  ),
                ),
                SizedBox(
                  height: sizedBoxHeightTall,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: TitleWidget(
                    title: 'Lokasi Kerja',
                    fontWeight: FontWeight.w300,
                    fontSize: textMedium,
                  ),
                ),
                SizedBox(
                  height: sizedBoxHeightShort,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: TextFormFieldWidget(
                    controller: _namaController,
                    maxHeightConstraints: _maxHeightNama,
                    hintText: 'Lokasi Kerja',
                  ),
                ),
                SizedBox(
                  height: sizedBoxHeightTall,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: TitleWidget(
                    title: 'Tanggal Bergabung',
                    fontWeight: FontWeight.w300,
                    fontSize: textMedium,
                  ),
                ),
                CupertinoButton(
                  child: Container(
                    width: size.width,
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontalNarrow,
                        vertical: padding5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(
                          Icons.calendar_month_outlined,
                          color: Colors.grey,
                        ),
                        Text(
                          '${dateTime.day}-${dateTime.month}-${dateTime.year}',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: textMedium,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {
                    showCupertinoModalPopup(
                      context: context,
                      builder: (BuildContext context) => SizedBox(
                        height: 250,
                        child: CupertinoDatePicker(
                          backgroundColor: Colors.white,
                          initialDateTime: dateTime,
                          onDateTimeChanged: (DateTime newTime) {
                            setState(() => dateTime = newTime);
                            print(dateTime);
                          },
                          use24hFormat: true,
                          mode: CupertinoDatePickerMode.date,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: sizedBoxHeightShort,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: TitleWidget(
                    title: 'Tujuan Dikeluarkannya Surat',
                    fontWeight: FontWeight.w300,
                    fontSize: textMedium,
                  ),
                ),
                SizedBox(
                  height: sizedBoxHeightShort,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: TextFormFieldWidget(
                    controller: _namaController,
                    maxHeightConstraints: _maxHeightNama,
                    hintText: 'Pengajuan Visa',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
