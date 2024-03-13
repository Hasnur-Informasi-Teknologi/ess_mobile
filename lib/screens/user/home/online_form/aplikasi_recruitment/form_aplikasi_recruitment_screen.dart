import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:mobile_ess/widgets/button_two_row_widget.dart';
import 'package:mobile_ess/widgets/text_form_field_widget.dart';
import 'package:mobile_ess/widgets/title_widget.dart';

class FormAplikasiRecruitmentScreen extends StatefulWidget {
  const FormAplikasiRecruitmentScreen({super.key});

  @override
  State<FormAplikasiRecruitmentScreen> createState() =>
      _FormAplikasiRecruitmentScreenState();
}

class _FormAplikasiRecruitmentScreenState
    extends State<FormAplikasiRecruitmentScreen> {
  bool? _isTinggiChecked = false;
  bool? _isNormalChecked = false;
  bool? _isRendahChecked = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nomorController = TextEditingController();
  final TextEditingController _nrpController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _jabatanController = TextEditingController();
  final TextEditingController _entitasController = TextEditingController();

  final double _maxHeightNomor = 40.0;
  int current = 0;

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime(3000, 2, 1, 10, 20);
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double textLarge = size.width * 0.04;
    double sizedBoxHeightTall = size.height * 0.0163;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;
    double paddingHorizontalNarrow = size.width * 0.035;
    double padding5 = size.width * 0.0115;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: false,
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Get.back();
            },
          ),
          title: const Text(
            'Form Aplikasi Rekrutmen',
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
                    height: sizedBoxHeightExtraTall,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontalNarrow),
                    child: TitleWidget(
                      title: 'Prioritas',
                      fontWeight: FontWeight.w500,
                      fontSize: textMedium,
                    ),
                  ),
                  SizedBox(
                    height: sizedBoxHeightShort,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildCheckbox('Tinggi', _isTinggiChecked),
                      buildCheckbox('Normal', _isNormalChecked),
                      buildCheckbox('Rendah', _isRendahChecked),
                    ],
                  ),
                  SizedBox(
                    height: sizedBoxHeightTall,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontalNarrow),
                    child: TitleWidget(
                      title: 'Nomor',
                      fontWeight: FontWeight.w500,
                      fontSize: textMedium,
                    ),
                  ),
                  SizedBox(
                    height: sizedBoxHeightTall,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontalNarrow),
                    child: TextFormFieldWidget(
                      controller: _nomorController,
                      maxHeightConstraints: _maxHeightNomor,
                      hintText: '0001/LND/HJU/V/2023',
                    ),
                  ),
                  SizedBox(
                    height: sizedBoxHeightExtraTall,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontalNarrow),
                    child: TitleWidget(
                      title: 'Tangal Pengajuan',
                      fontWeight: FontWeight.w500,
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
                  SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: paddingHorizontalNarrow,
                          vertical: padding5),
                      width: double.infinity,
                      height: 400,
                      child: Column(
                        children: [
                          TabBar(
                            isScrollable: true,
                            indicatorSize: TabBarIndicatorSize.label,
                            labelColor: Colors.black,
                            unselectedLabelColor: Colors.grey,
                            labelPadding: EdgeInsets.symmetric(
                                horizontal: paddingHorizontalNarrow),
                            tabs: const [
                              Tab(
                                text: 'Diajukan oleh',
                              ),
                              Tab(
                                text: 'Permintaan Rekrutmen Karyawan',
                              ),
                              Tab(
                                text: 'Kualifikasi',
                              ),
                              Tab(
                                text: 'Informasi Tambahan',
                              ),
                            ],
                            onTap: (index) {
                              setState(() {
                                current = index;
                              });
                            },
                          ),
                          //Main Body
                          Expanded(
                            child: TabBarView(
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                SingleChildScrollView(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: padding5),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: sizedBoxHeightExtraTall,
                                        ),
                                        TitleWidget(
                                          title: 'Diajukan Oleh',
                                          fontWeight: FontWeight.w500,
                                          fontSize: textLarge,
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightTall,
                                        ),
                                        TitleWidget(
                                          title: 'NRP : ',
                                          fontWeight: FontWeight.w300,
                                          fontSize: textMedium,
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormFieldWidget(
                                          controller: _nrpController,
                                          maxHeightConstraints: _maxHeightNomor,
                                          hintText: '78220012',
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightTall,
                                        ),
                                        TitleWidget(
                                          title: 'Nama : ',
                                          fontWeight: FontWeight.w300,
                                          fontSize: textMedium,
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormFieldWidget(
                                          controller: _namaController,
                                          maxHeightConstraints: _maxHeightNomor,
                                          hintText: 'Hasnur',
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightTall,
                                        ),
                                        TitleWidget(
                                          title: 'Jabatan : ',
                                          fontWeight: FontWeight.w300,
                                          fontSize: textMedium,
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormFieldWidget(
                                          controller: _jabatanController,
                                          maxHeightConstraints: _maxHeightNomor,
                                          hintText: 'Programmer',
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightTall,
                                        ),
                                        TitleWidget(
                                          title: 'Entitas : ',
                                          fontWeight: FontWeight.w300,
                                          fontSize: textMedium,
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormFieldWidget(
                                          controller: _entitasController,
                                          maxHeightConstraints: _maxHeightNomor,
                                          hintText:
                                              'PT Hasnur Informasi Teknologi',
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightExtraTall,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SingleChildScrollView(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: padding5),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: sizedBoxHeightExtraTall,
                                        ),
                                        TitleWidget(
                                          title:
                                              'Permintaan Rekrutmen Karyawan Untuk',
                                          fontWeight: FontWeight.w500,
                                          fontSize: textLarge,
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightTall,
                                        ),
                                        TitleWidget(
                                          title: 'Atasan Langsung * : ',
                                          fontWeight: FontWeight.w300,
                                          fontSize: textMedium,
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormFieldWidget(
                                          controller: _nrpController,
                                          maxHeightConstraints: _maxHeightNomor,
                                          hintText: 'Ayudia',
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightTall,
                                        ),
                                        TitleWidget(
                                          title: 'Entitas * : ',
                                          fontWeight: FontWeight.w300,
                                          fontSize: textMedium,
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormFieldWidget(
                                          controller: _nrpController,
                                          maxHeightConstraints: _maxHeightNomor,
                                          hintText:
                                              'PT Hasnur Informasi Teknologi',
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightTall,
                                        ),
                                        TitleWidget(
                                          title: 'Lokasi Kerja * : ',
                                          fontWeight: FontWeight.w300,
                                          fontSize: textMedium,
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormFieldWidget(
                                          controller: _nrpController,
                                          maxHeightConstraints: _maxHeightNomor,
                                          hintText:
                                              'BanjarBaru, Kalimantan Selatan',
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightTall,
                                        ),
                                        TitleWidget(
                                          title: 'Divisi/Department : ',
                                          fontWeight: FontWeight.w300,
                                          fontSize: textMedium,
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormFieldWidget(
                                          controller: _nrpController,
                                          maxHeightConstraints: _maxHeightNomor,
                                          hintText: 'Business Solution',
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightTall,
                                        ),
                                        TitleWidget(
                                          title: 'Jabatan * : ',
                                          fontWeight: FontWeight.w300,
                                          fontSize: textMedium,
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormFieldWidget(
                                          controller: _nrpController,
                                          maxHeightConstraints: _maxHeightNomor,
                                          hintText: 'System Analist',
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightTall,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: padding5),
                                              child: SizedBox(
                                                width: size.width * 0.43,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    TitleWidget(
                                                      title: 'Pangkat * : ',
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      fontSize: textMedium,
                                                    ),
                                                    SizedBox(
                                                      height:
                                                          sizedBoxHeightShort,
                                                    ),
                                                    TextFormFieldWidget(
                                                      controller:
                                                          _namaController,
                                                      maxHeightConstraints:
                                                          _maxHeightNomor,
                                                      hintText: 'Minimun',
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: padding5),
                                              child: SizedBox(
                                                width: size.width * 0.43,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(''),
                                                    SizedBox(
                                                      height:
                                                          sizedBoxHeightShort,
                                                    ),
                                                    TextFormFieldWidget(
                                                      controller:
                                                          _namaController,
                                                      maxHeightConstraints:
                                                          _maxHeightNomor,
                                                      hintText: 'Maksimum',
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightTall,
                                        ),
                                        TitleWidget(
                                          title: 'Estimasi Mulai Bekerja * : ',
                                          fontWeight: FontWeight.w300,
                                          fontSize: textMedium,
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormFieldWidget(
                                          controller: _nrpController,
                                          maxHeightConstraints: _maxHeightNomor,
                                          hintText: 'dd/mm/yyyy',
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TitleWidget(
                                          title: 'Jumlah * : ',
                                          fontWeight: FontWeight.w300,
                                          fontSize: textMedium,
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormFieldWidget(
                                          controller: _nrpController,
                                          maxHeightConstraints: _maxHeightNomor,
                                          hintText: '2 Orang',
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TitleWidget(
                                          title: 'Catatan * : ',
                                          fontWeight: FontWeight.w300,
                                          fontSize: textMedium,
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormFieldWidget(
                                          controller: _nrpController,
                                          maxHeightConstraints: _maxHeightNomor,
                                          hintText: 'Sangat Diperlukan',
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightExtraTall,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SingleChildScrollView(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: padding5),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: sizedBoxHeightExtraTall,
                                        ),
                                        TitleWidget(
                                          title: 'Kualifikasi yang Dibutuhkan',
                                          fontWeight: FontWeight.w500,
                                          fontSize: textLarge,
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightTall,
                                        ),
                                        TitleWidget(
                                          title: 'Pendidikan * : ',
                                          fontWeight: FontWeight.w300,
                                          fontSize: textMedium,
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormFieldWidget(
                                          controller: _nrpController,
                                          maxHeightConstraints: _maxHeightNomor,
                                          hintText: 'S1',
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightTall,
                                        ),
                                        TitleWidget(
                                          title: 'Jurusan Utama * : ',
                                          fontWeight: FontWeight.w300,
                                          fontSize: textMedium,
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormFieldWidget(
                                          controller: _nrpController,
                                          maxHeightConstraints: _maxHeightNomor,
                                          hintText: 'Sistem Informasi',
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightTall,
                                        ),
                                        TitleWidget(
                                          title: 'Jurusan Lainnya * : ',
                                          fontWeight: FontWeight.w300,
                                          fontSize: textMedium,
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormFieldWidget(
                                          controller: _nrpController,
                                          maxHeightConstraints: _maxHeightNomor,
                                          hintText: 'Sistem Informasi',
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightTall,
                                        ),
                                        TitleWidget(
                                          title: 'IPK / Nilai * : ',
                                          fontWeight: FontWeight.w300,
                                          fontSize: textMedium,
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormFieldWidget(
                                          controller: _nrpController,
                                          maxHeightConstraints: _maxHeightNomor,
                                          hintText: '> 3.5',
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightTall,
                                        ),
                                        TitleWidget(
                                          title: 'Sertifikasi * : ',
                                          fontWeight: FontWeight.w300,
                                          fontSize: textMedium,
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormFieldWidget(
                                          controller: _nrpController,
                                          maxHeightConstraints: _maxHeightNomor,
                                          hintText: '---',
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightTall,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: padding5),
                                              child: SizedBox(
                                                width: size.width * 0.43,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    TitleWidget(
                                                      title:
                                                          'Rentang Usia * : ',
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      fontSize: textMedium,
                                                    ),
                                                    SizedBox(
                                                      height:
                                                          sizedBoxHeightShort,
                                                    ),
                                                    TextFormFieldWidget(
                                                      controller:
                                                          _namaController,
                                                      maxHeightConstraints:
                                                          _maxHeightNomor,
                                                      hintText: 'Minimun',
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: padding5),
                                              child: SizedBox(
                                                width: size.width * 0.43,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(''),
                                                    SizedBox(
                                                      height:
                                                          sizedBoxHeightShort,
                                                    ),
                                                    TextFormFieldWidget(
                                                      controller:
                                                          _namaController,
                                                      maxHeightConstraints:
                                                          _maxHeightNomor,
                                                      hintText: 'Maksimum',
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightTall,
                                        ),
                                        TitleWidget(
                                          title: 'Jenis Kelamin * : ',
                                          fontWeight: FontWeight.w300,
                                          fontSize: textMedium,
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormFieldWidget(
                                          controller: _nrpController,
                                          maxHeightConstraints: _maxHeightNomor,
                                          hintText: 'Perempuan',
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TitleWidget(
                                          title: 'Pengalaman Kerja * : ',
                                          fontWeight: FontWeight.w300,
                                          fontSize: textMedium,
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormFieldWidget(
                                          controller: _nrpController,
                                          maxHeightConstraints: _maxHeightNomor,
                                          hintText: 'Minimal 1 Tahun',
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightExtraTall,
                                        ),
                                        TitleWidget(
                                          title: 'Soft Skill * : ',
                                          fontWeight: FontWeight.w300,
                                          fontSize: textMedium,
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormFieldWidget(
                                          controller: _nrpController,
                                          maxHeightConstraints: _maxHeightNomor,
                                          hintText: 'Percaya Diri',
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightTall,
                                        ),
                                        TitleWidget(
                                          title: 'Hard Skill * : ',
                                          fontWeight: FontWeight.w300,
                                          fontSize: textMedium,
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormFieldWidget(
                                          controller: _nrpController,
                                          maxHeightConstraints: _maxHeightNomor,
                                          hintText:
                                              'Pengatahuan Tentang Database',
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightTall,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SingleChildScrollView(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: padding5),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: sizedBoxHeightExtraTall,
                                        ),
                                        TitleWidget(
                                          title: 'Tujuan Jabatan * : ',
                                          fontWeight: FontWeight.w300,
                                          fontSize: textMedium,
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormFieldWidget(
                                          controller: _nrpController,
                                          maxHeightConstraints: _maxHeightNomor,
                                          hintText:
                                              'Pengatahuan Tentang Database',
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightTall,
                                        ),
                                        TitleWidget(
                                          title: 'Tujuan & Tanggung Jawab * : ',
                                          fontWeight: FontWeight.w300,
                                          fontSize: textMedium,
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormFieldWidget(
                                          controller: _nrpController,
                                          hintText:
                                              'Bertanggung Jawab untuk ...',
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightTall,
                                        ),
                                        TitleWidget(
                                          title:
                                              'Lampiran Struktur Organisasi * : ',
                                          fontWeight: FontWeight.w300,
                                          fontSize: textMedium,
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormFieldWidget(
                                          controller: _nrpController,
                                          maxHeightConstraints: _maxHeightNomor,
                                          hintText: 'Lampiran',
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightTall,
                                        ),
                                        TitleWidget(
                                          title: 'Status Karyawan * : ',
                                          fontWeight: FontWeight.w300,
                                          fontSize: textMedium,
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormFieldWidget(
                                          controller: _nrpController,
                                          hintText: 'Kontrak',
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightTall,
                                        ),
                                        TitleWidget(
                                          title: 'Tahun * : ',
                                          fontWeight: FontWeight.w300,
                                          fontSize: textMedium,
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormFieldWidget(
                                          controller: _nrpController,
                                          maxHeightConstraints: _maxHeightNomor,
                                          hintText: '1',
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightTall,
                                        ),
                                        TitleWidget(
                                          title: 'Bulan * : ',
                                          fontWeight: FontWeight.w300,
                                          fontSize: textMedium,
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormFieldWidget(
                                          controller: _nrpController,
                                          maxHeightConstraints: _maxHeightNomor,
                                          hintText: '-',
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightTall,
                                        ),
                                        TitleWidget(
                                          title:
                                              'Status Aplikasi Rekrutmen * : ',
                                          fontWeight: FontWeight.w300,
                                          fontSize: textMedium,
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormFieldWidget(
                                          controller: _nrpController,
                                          maxHeightConstraints: _maxHeightNomor,
                                          hintText: 'Baru (New Hire)',
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightTall,
                                        ),
                                        TitleWidget(
                                          title: 'Nama * : ',
                                          fontWeight: FontWeight.w300,
                                          fontSize: textMedium,
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormFieldWidget(
                                          controller: _nrpController,
                                          maxHeightConstraints: _maxHeightNomor,
                                          hintText: 'Hasnur',
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightTall,
                                        ),
                                        TitleWidget(
                                          title: 'Jabatan * : ',
                                          fontWeight: FontWeight.w300,
                                          fontSize: textMedium,
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormFieldWidget(
                                          controller: _nrpController,
                                          maxHeightConstraints: _maxHeightNomor,
                                          hintText: 'System Analys',
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightTall,
                                        ),
                                        TitleWidget(
                                          title: 'Pangkat * : ',
                                          fontWeight: FontWeight.w300,
                                          fontSize: textMedium,
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormFieldWidget(
                                          controller: _nrpController,
                                          maxHeightConstraints: _maxHeightNomor,
                                          hintText: 'Senior',
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightTall,
                                        ),
                                        TitleWidget(
                                          title: 'Entitas * : ',
                                          fontWeight: FontWeight.w300,
                                          fontSize: textMedium,
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormFieldWidget(
                                          controller: _nrpController,
                                          maxHeightConstraints: _maxHeightNomor,
                                          hintText:
                                              'PT Hasnur Informasi Teknologi',
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightTall,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: sizedBoxHeightTall,
                          ),
                          SizedBox(
                            width: size.width,
                            child: ButtonTwoRowWidget(
                              textLeft: 'Draft',
                              textRight: 'Submit',
                              onTabLeft: () {
                                print('Cancel');
                              },
                              onTabRight: () {
                                print('Cancel');
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCheckbox(String label, bool? value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Checkbox(
          value: value ?? false,
          onChanged: (newValue) {
            setState(() {
              _isTinggiChecked = label == 'Tinggi' ? newValue : false;
              _isNormalChecked = label == 'Normal' ? newValue : false;
              _isRendahChecked = label == 'Rendah' ? newValue : false;
            });
          },
        ),
        Text(label),
      ],
    );
  }
}
