import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_ess/themes/constant.dart';
import 'package:mobile_ess/widgets/text_form_field_widget.dart';
import 'package:mobile_ess/widgets/title_widget.dart';

class FormSuratIzinKeluar extends StatefulWidget {
  const FormSuratIzinKeluar({super.key});

  @override
  State<FormSuratIzinKeluar> createState() => _FormSuratIzinKeluarState();
}

class _FormSuratIzinKeluarState extends State<FormSuratIzinKeluar> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  double _maxHeightNama = 40.0;

  bool? _isDinasChecked = false;
  bool? _isIzinPribadiChecked = false;
  bool? _isSakitChecked = false;
  bool? _isLainnyaChecked = false;

  bool? _isKembaliChecked = false;
  bool? _isTidakKembaliChecked = false;

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime(3000, 2, 1, 10, 20);
    DateTime jamKeluar = DateTime(3000, 2, 1, 17, 10);
    DateTime jamKembali = DateTime(3000, 2, 1, 17, 10);
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double textLarge = size.width * 0.04;
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
          'Surat Izin Keluar',
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
                    title: 'Tanggal',
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
                    title: 'NRP *',
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
                    title: 'Jabatan',
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
                    hintText: 'Bussiness Solution',
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
                    title: 'Pengajuan Untuk *',
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
                    hintText: 'Group',
                  ),
                ),
                SizedBox(
                  height: sizedBoxHeightTall,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: TitleWidget(
                    title: 'Group',
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
                    title: 'Jam Keluar',
                    fontWeight: FontWeight.w300,
                    fontSize: textMedium,
                  ),
                ),
                CupertinoButton(
                  child: Container(
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
                          Icons.watch_later_outlined,
                          color: Colors.grey,
                        ),
                        Text(
                          '${jamKeluar.hour}:${jamKeluar.minute}',
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
                          initialDateTime: jamKeluar,
                          onDateTimeChanged: (DateTime newTime) {
                            setState(() => jamKeluar = newTime);
                            print(jamKeluar);
                          },
                          use24hFormat: true,
                          mode: CupertinoDatePickerMode.time,
                        ),
                      ),
                    );
                  },
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: TitleWidget(
                    title: 'Jam Kembali',
                    fontWeight: FontWeight.w300,
                    fontSize: textMedium,
                  ),
                ),
                CupertinoButton(
                  child: Container(
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
                          Icons.watch_later_outlined,
                          color: Colors.grey,
                        ),
                        Text(
                          '${jamKembali.hour}:${jamKembali.minute}',
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
                          initialDateTime: jamKembali,
                          onDateTimeChanged: (DateTime newTime) {
                            setState(() => jamKembali = newTime);
                            print(jamKembali);
                          },
                          use24hFormat: true,
                          mode: CupertinoDatePickerMode.time,
                        ),
                      ),
                    );
                  },
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: TitleWidget(
                    title: 'Keperluan',
                    fontWeight: FontWeight.w300,
                    fontSize: textLarge,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    buildCheckboxKeperluan('Dinas', _isDinasChecked),
                    buildCheckboxKeperluan(
                        'Izin Pribadi', _isIzinPribadiChecked),
                    buildCheckboxKeperluan('Sakit', _isSakitChecked),
                    buildCheckboxKeperluan('Lainnya', _isLainnyaChecked),
                  ],
                ),
                SizedBox(
                  height: sizedBoxHeightTall,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: TitleWidget(
                    title: 'Keterangan',
                    fontWeight: FontWeight.w300,
                    fontSize: textLarge,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    buildCheckboxKeterangan(
                        'Kembali Ke Kantor', _isKembaliChecked),
                    buildCheckboxKeterangan(
                        'Tidak Kembali Ke Kantor', _isTidakKembaliChecked),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCheckboxKeperluan(String label, bool? value) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Checkbox(
          value: value ?? false,
          onChanged: (newValue) {
            setState(() {
              _isDinasChecked = label == 'Dinas' ? newValue : false;
              _isIzinPribadiChecked =
                  label == 'Izin Pribadi' ? newValue : false;
              _isSakitChecked = label == 'Sakit' ? newValue : false;
              _isLainnyaChecked = label == 'Lainnya' ? newValue : false;
            });
          },
        ),
        Text(
          label,
          style: TextStyle(
              color: const Color(primaryBlack),
              fontSize: textMedium,
              fontFamily: 'Poppins',
              letterSpacing: 0.9,
              fontWeight: FontWeight.w300),
        ),
      ],
    );
  }

  Widget buildCheckboxKeterangan(String label, bool? value) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Checkbox(
          value: value ?? false,
          onChanged: (newValue) {
            setState(() {
              _isKembaliChecked =
                  label == 'Kembali Ke Kantor' ? newValue : false;
              _isTidakKembaliChecked =
                  label == 'Tidak Kembali Ke Kantor' ? newValue : false;
            });
          },
        ),
        Text(
          label,
          style: TextStyle(
              color: const Color(primaryBlack),
              fontSize: textMedium,
              fontFamily: 'Poppins',
              letterSpacing: 0.9,
              fontWeight: FontWeight.w300),
        ),
      ],
    );
  }
}
