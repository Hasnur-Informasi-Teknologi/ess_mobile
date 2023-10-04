import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_ess/themes/constant.dart';
import 'package:mobile_ess/widgets/line_widget.dart';
import 'package:mobile_ess/widgets/text_form_field_widget.dart';
import 'package:mobile_ess/widgets/title_widget.dart';

class FormPengajuanCuti extends StatefulWidget {
  const FormPengajuanCuti({super.key});

  @override
  State<FormPengajuanCuti> createState() => _FormPengajuanCutiState();
}

class _FormPengajuanCutiState extends State<FormPengajuanCuti> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  double _maxHeightNama = 40.0;

  bool? _isDiBayar = false;
  bool? _isTidakDiBayar = false;
  bool? _isIzinLainnya = false;
  bool? _isRoster = false;

  @override
  Widget build(BuildContext context) {
    DateTime tanggalMulai = DateTime(3000, 2, 1, 10, 20);
    DateTime tanggalBerakhir = DateTime(3000, 2, 1, 10, 20);
    DateTime tanggalKembaliKerja = DateTime(3000, 2, 1, 10, 20);

    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightTall = size.height * 0.0163;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;
    double paddingHorizontalNarrow = size.width * 0.035;
    double paddingHorizontalWide = size.width * 0.0585;
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
          'Pengajuan Cuti',
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: size.width * 0.48,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: paddingHorizontalNarrow),
                            child: TitleWidget(
                              title: 'Atasan',
                              fontWeight: FontWeight.w300,
                              fontSize: textMedium,
                            ),
                          ),
                          SizedBox(
                            height: sizedBoxHeightShort,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: paddingHorizontalNarrow),
                            child: TextFormFieldWidget(
                              controller: _namaController,
                              maxHeightConstraints: _maxHeightNama,
                              hintText: 'Pilih Entitas',
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.48,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: paddingHorizontalNarrow),
                            child: TitleWidget(
                              title: ' ',
                              fontWeight: FontWeight.w300,
                              fontSize: textMedium,
                            ),
                          ),
                          SizedBox(
                            height: sizedBoxHeightShort,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: paddingHorizontalNarrow),
                            child: TextFormFieldWidget(
                              controller: _namaController,
                              maxHeightConstraints: _maxHeightNama,
                              hintText: 'Pilih Atasan',
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: sizedBoxHeightTall,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalWide),
                  child: TitleWidget(
                    title: 'Atasan dari Atasan',
                    fontWeight: FontWeight.w300,
                    fontSize: textMedium,
                  ),
                ),
                SizedBox(
                  height: sizedBoxHeightShort,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalWide),
                  child: TextFormFieldWidget(
                    controller: _namaController,
                    maxHeightConstraints: _maxHeightNama,
                    hintText: 'Pilih Atasan dari Atasan',
                  ),
                ),
                SizedBox(
                  height: sizedBoxHeightTall,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: size.width * 0.48,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: paddingHorizontalNarrow),
                            child: TitleWidget(
                              title: 'Karyawan Pengganti',
                              fontWeight: FontWeight.w300,
                              fontSize: textMedium,
                            ),
                          ),
                          SizedBox(
                            height: sizedBoxHeightShort,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: paddingHorizontalNarrow),
                            child: TextFormFieldWidget(
                              controller: _namaController,
                              maxHeightConstraints: _maxHeightNama,
                              hintText: 'Pilih Entitas',
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.48,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: paddingHorizontalNarrow),
                            child: TitleWidget(
                              title: ' ',
                              fontWeight: FontWeight.w300,
                              fontSize: textMedium,
                            ),
                          ),
                          SizedBox(
                            height: sizedBoxHeightShort,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: paddingHorizontalNarrow),
                            child: TextFormFieldWidget(
                              controller: _namaController,
                              maxHeightConstraints: _maxHeightNama,
                              hintText: 'Pilih Pengganti',
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: sizedBoxHeightTall,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalWide),
                  child: TitleWidget(
                    title: 'Keterangan Cuti',
                    fontWeight: FontWeight.w300,
                    fontSize: textMedium,
                  ),
                ),
                SizedBox(
                  height: sizedBoxHeightShort,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalWide),
                  child: const LineWidget(),
                ),
                SizedBox(
                  height: sizedBoxHeightShort,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: Column(
                    children: [
                      buildCheckboxKeterangan(
                          'Cuti Tahunan Dibayar', _isDiBayar),
                      buildCheckboxKeterangan(
                          'Cuti Tahunan Tidak Dibayar', _isTidakDiBayar),
                      buildCheckboxKeterangan('Izin Lainnya', _isIzinLainnya),
                      buildCheckboxKeterangan('Cuti Roaster', _isRoster),
                    ],
                  ),
                ),
                SizedBox(
                  height: sizedBoxHeightTall,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalWide),
                  child: TitleWidget(
                    title: 'Keperluan Cuti',
                    fontWeight: FontWeight.w300,
                    fontSize: textMedium,
                  ),
                ),
                SizedBox(
                  height: sizedBoxHeightShort,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalWide),
                  child: TextFormFieldWidget(
                    controller: _namaController,
                    maxHeightConstraints: _maxHeightNama,
                    hintText: 'Keperluan Cuti',
                  ),
                ),
                SizedBox(
                  height: sizedBoxHeightTall,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalWide),
                  child: TitleWidget(
                    title: 'Catatan Cuti',
                    fontWeight: FontWeight.w300,
                    fontSize: textMedium,
                  ),
                ),
                SizedBox(
                  height: sizedBoxHeightShort,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalWide),
                  child: const LineWidget(),
                ),
                SizedBox(
                  height: sizedBoxHeightExtraTall,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: size.width * 0.48,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: paddingHorizontalNarrow),
                            child: TitleWidget(
                              title: 'Cuti Yang Diambil',
                              fontWeight: FontWeight.w300,
                              fontSize: textMedium,
                            ),
                          ),
                          SizedBox(
                            height: sizedBoxHeightShort,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: paddingHorizontalNarrow),
                            child: TextFormFieldWidget(
                              controller: _namaController,
                              maxHeightConstraints: _maxHeightNama,
                              hintText: '4 Hari',
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.48,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: paddingHorizontalNarrow),
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
                            padding: EdgeInsets.symmetric(
                                horizontal: paddingHorizontalNarrow),
                            child: TextFormFieldWidget(
                              controller: _namaController,
                              maxHeightConstraints: _maxHeightNama,
                              hintText: '12 Hari',
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: sizedBoxHeightTall,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalWide),
                  child: TitleWidget(
                    title: 'Tanggal Pengajuan Cuti',
                    fontWeight: FontWeight.w300,
                    fontSize: textMedium,
                  ),
                ),
                SizedBox(
                  height: sizedBoxHeightShort,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalWide),
                  child: const LineWidget(),
                ),
                SizedBox(
                  height: sizedBoxHeightExtraTall,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: size.width * 0.48,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: paddingHorizontalNarrow),
                            child: TitleWidget(
                              title: 'Tanggal Mulai',
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Icon(
                                    Icons.calendar_month_outlined,
                                    color: Colors.grey,
                                  ),
                                  Text(
                                    '${tanggalMulai.day}-${tanggalMulai.month}-${tanggalMulai.year}',
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
                                    initialDateTime: tanggalMulai,
                                    onDateTimeChanged: (DateTime newTime) {
                                      setState(() => tanggalMulai = newTime);
                                      print(tanggalMulai);
                                    },
                                    use24hFormat: true,
                                    mode: CupertinoDatePickerMode.date,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.48,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: paddingHorizontalNarrow),
                            child: TitleWidget(
                              title: 'Tanggal Berakhir',
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Icon(
                                    Icons.calendar_month_outlined,
                                    color: Colors.grey,
                                  ),
                                  Text(
                                    '${tanggalBerakhir.day}-${tanggalBerakhir.month}-${tanggalBerakhir.year}',
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
                                    initialDateTime: tanggalBerakhir,
                                    onDateTimeChanged: (DateTime newTime) {
                                      setState(() => tanggalBerakhir = newTime);
                                      print(tanggalBerakhir);
                                    },
                                    use24hFormat: true,
                                    mode: CupertinoDatePickerMode.date,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: sizedBoxHeightShort,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalWide),
                  child: TitleWidget(
                    title: 'Tanggal Kembali Kerja',
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
                      EdgeInsets.symmetric(horizontal: paddingHorizontalWide),
                  child: TitleWidget(
                    title: 'Alamat Cuti',
                    fontWeight: FontWeight.w300,
                    fontSize: textMedium,
                  ),
                ),
                SizedBox(
                  height: sizedBoxHeightShort,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalWide),
                  child: TextFormFieldWidget(
                    controller: _namaController,
                    maxHeightConstraints: _maxHeightNama,
                    hintText: 'Alamat Cuti',
                  ),
                ),
                SizedBox(
                  height: sizedBoxHeightTall,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalWide),
                  child: TitleWidget(
                    title: 'No Telepon',
                    fontWeight: FontWeight.w300,
                    fontSize: textMedium,
                  ),
                ),
                SizedBox(
                  height: sizedBoxHeightShort,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalWide),
                  child: TextFormFieldWidget(
                    controller: _namaController,
                    maxHeightConstraints: _maxHeightNama,
                    hintText: '089XXXX',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
              _isDiBayar = label == 'Cuti Tahunan Dibayar' ? newValue : false;
              _isTidakDiBayar =
                  label == 'Cuti Tahunan Tidak Dibayar' ? newValue : false;
              _isIzinLainnya = label == 'Izin Lainnya' ? newValue : false;
              _isRoster = label == 'Cuti Roaster' ? newValue : false;
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
