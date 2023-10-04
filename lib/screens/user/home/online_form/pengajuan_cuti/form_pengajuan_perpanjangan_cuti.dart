import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_ess/widgets/text_form_field_widget.dart';
import 'package:mobile_ess/widgets/title_widget.dart';

class FormPengajuanPerpanjanganCuti extends StatefulWidget {
  const FormPengajuanPerpanjanganCuti({super.key});

  @override
  State<FormPengajuanPerpanjanganCuti> createState() =>
      _FormPengajuanPerpanjanganCutiState();
}

class _FormPengajuanPerpanjanganCutiState
    extends State<FormPengajuanPerpanjanganCuti> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  double _maxHeightNama = 40.0;

  @override
  Widget build(BuildContext context) {
    DateTime tanggalKembaliKerja = DateTime(3000, 2, 1, 10, 20);

    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightTall = size.height * 0.0163;
    double sizedBoxHeightShort = size.height * 0.0086;
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
          'Pengajuan Perpanjangan Cuti',
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
                    title: 'Tanggal Pengajuan',
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
                          '${tanggalKembaliKerja.day}-${tanggalKembaliKerja.month}-${tanggalKembaliKerja.year}',
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
                          initialDateTime: tanggalKembaliKerja,
                          onDateTimeChanged: (DateTime newTime) {
                            setState(() => tanggalKembaliKerja = newTime);
                            print(tanggalKembaliKerja);
                          },
                          use24hFormat: true,
                          mode: CupertinoDatePickerMode.date,
                        ),
                      ),
                    );
                  },
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
                    hintText: '78220012',
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
                    hintText: 'Nama Karyawan',
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
                    hintText: 'PT Hasnur Informasi Teknologi',
                  ),
                ),
                SizedBox(
                  height: sizedBoxHeightTall,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: TitleWidget(
                    title: 'Atasan *',
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
                    hintText: 'Nama Atasan',
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
                          '${tanggalKembaliKerja.day}-${tanggalKembaliKerja.month}-${tanggalKembaliKerja.year}',
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
                          initialDateTime: tanggalKembaliKerja,
                          onDateTimeChanged: (DateTime newTime) {
                            setState(() => tanggalKembaliKerja = newTime);
                            print(tanggalKembaliKerja);
                          },
                          use24hFormat: true,
                          mode: CupertinoDatePickerMode.date,
                        ),
                      ),
                    );
                  },
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: TitleWidget(
                    title: 'Tanggal Jatuh Tempo',
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
                          '${tanggalKembaliKerja.day}-${tanggalKembaliKerja.month}-${tanggalKembaliKerja.year}',
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
                          initialDateTime: tanggalKembaliKerja,
                          onDateTimeChanged: (DateTime newTime) {
                            setState(() => tanggalKembaliKerja = newTime);
                            print(tanggalKembaliKerja);
                          },
                          use24hFormat: true,
                          mode: CupertinoDatePickerMode.date,
                        ),
                      ),
                    );
                  },
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: TitleWidget(
                    title: 'Sisa Cuti',
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
                    hintText: '5 Hari',
                  ),
                ),
                SizedBox(
                  height: sizedBoxHeightTall,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: TitleWidget(
                    title: 'Masa Perpanjangan',
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
                          '${tanggalKembaliKerja.day}-${tanggalKembaliKerja.month}-${tanggalKembaliKerja.year}',
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
                          initialDateTime: tanggalKembaliKerja,
                          onDateTimeChanged: (DateTime newTime) {
                            setState(() => tanggalKembaliKerja = newTime);
                            print(tanggalKembaliKerja);
                          },
                          use24hFormat: true,
                          mode: CupertinoDatePickerMode.date,
                        ),
                      ),
                    );
                  },
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: TitleWidget(
                    title: 'Alasan Cuti Tidak Digunakan *',
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
                    hintText: 'Karena ada ....',
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
