import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_ess/themes/constant.dart';
import 'package:mobile_ess/widgets/button_two_row_widget.dart';
import 'package:mobile_ess/widgets/text_form_field_widget.dart';

class FormAplikasiTrainingScreen extends StatefulWidget {
  const FormAplikasiTrainingScreen({super.key});

  @override
  State<FormAplikasiTrainingScreen> createState() =>
      _FormAplikasiTrainingScreenState();
}

class _FormAplikasiTrainingScreenState
    extends State<FormAplikasiTrainingScreen> {
  bool? _isTinggiChecked = false;
  bool? _isNormalChecked = false;
  bool? _isRendahChecked = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nomorController = TextEditingController();
  final TextEditingController _nrpController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _jabatanController = TextEditingController();
  final TextEditingController _divisiController = TextEditingController();
  final TextEditingController _entitasController = TextEditingController();
  final TextEditingController _totalTrainingController =
      TextEditingController();
  final TextEditingController _tanggalTrainingController =
      TextEditingController();
  final TextEditingController _judulTrainingController =
      TextEditingController();
  final TextEditingController _institusiTrainingController =
      TextEditingController();
  final TextEditingController _lokasiTrainingController =
      TextEditingController();
  final TextEditingController _LampiranTrainingController =
      TextEditingController();
  final TextEditingController _jenisTrainingController =
      TextEditingController();
  final TextEditingController _ikatanDinasController = TextEditingController();
  final TextEditingController _ringkasanTrainingController =
      TextEditingController();
  final TextEditingController _manfaatTrainingBagiKaryawanController =
      TextEditingController();

  late String selectedFungsiTraining;
  late String selectedTujuanObjektif;
  late String selectedPenugasanKaryawan;

  final double _maxHeightNomor = 40.0;

  int current = 0;

  @override
  void initState() {
    super.initState();
    selectedFungsiTraining = 'Sangat Direkomendasikan';
    selectedTujuanObjektif = 'Pengambangan untuk kebutuhan jabatan';
    selectedPenugasanKaryawan = 'Presentasi isi Training';
  }

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime(3000, 2, 1, 10, 20);
    Size size = MediaQuery.of(context).size;
    double textSmall = size.width * 0.027;
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
            'Form Aplikasi Training',
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
                    child: Text(
                      'Prioritas',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: const Color(primaryBlack),
                          fontSize: textMedium,
                          fontFamily: 'Poppins',
                          letterSpacing: 0.9,
                          fontWeight: FontWeight.w500),
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
                    child: Text(
                      'Nomor',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: const Color(primaryBlack),
                          fontSize: textMedium,
                          fontFamily: 'Poppins',
                          letterSpacing: 0.9,
                          fontWeight: FontWeight.w500),
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
                      hintText: '0001/LND/HJU/V/2023',
                      maxHeightConstraints: _maxHeightNomor,
                    ),
                  ),
                  SizedBox(
                    height: sizedBoxHeightExtraTall,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontalNarrow),
                    child: Text(
                      'Tangal Pengajuan',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: const Color(primaryBlack),
                          fontSize: textMedium,
                          fontFamily: 'Poppins',
                          letterSpacing: 0.9,
                          fontWeight: FontWeight.w500),
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
                              fontWeight: FontWeight.w500,
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
                            // indicatorSize: TabBarIndicatorSize.label,
                            // indicatorColor: Colors.black,
                            labelColor: Colors.black,
                            unselectedLabelColor: Colors.grey,
                            labelPadding: EdgeInsets.symmetric(
                                horizontal: paddingHorizontalNarrow),
                            tabs: const [
                              Tab(
                                text: 'Diajukan oleh',
                              ),
                              Tab(
                                text: 'Informasi Training',
                              ),
                              Tab(
                                text: 'Evaluasi Pra - Training',
                              ),
                              Tab(
                                text: 'Evaluasi Hasil Training',
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
                                        Text(
                                          'Diajukan Oleh',
                                          style: TextStyle(
                                              color: const Color(primaryBlack),
                                              fontSize: textLarge,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightTall,
                                        ),
                                        Text(
                                          'Diisi oleh karyawan yang mengikuti training',
                                          style: TextStyle(
                                              color: const Color(primaryBlack),
                                              fontSize: textSmall,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w300),
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        Text(
                                          'NRP : ',
                                          style: TextStyle(
                                              color: const Color(primaryBlack),
                                              fontSize: textMedium,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormFieldWidget(
                                          controller: _nrpController,
                                          hintText: '78220012',
                                          maxHeightConstraints: _maxHeightNomor,
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightTall,
                                        ),
                                        Text(
                                          'Nama : ',
                                          style: TextStyle(
                                              color: const Color(primaryBlack),
                                              fontSize: textMedium,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormFieldWidget(
                                          controller: _namaController,
                                          hintText: 'Hasnur',
                                          maxHeightConstraints: _maxHeightNomor,
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightTall,
                                        ),
                                        Text(
                                          'Jabatan : ',
                                          style: TextStyle(
                                              color: const Color(primaryBlack),
                                              fontSize: textMedium,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormFieldWidget(
                                          controller: _jabatanController,
                                          hintText: 'Programmer',
                                          maxHeightConstraints: _maxHeightNomor,
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightTall,
                                        ),
                                        Text(
                                          'Divisi/Department : ',
                                          style: TextStyle(
                                              color: const Color(primaryBlack),
                                              fontSize: textMedium,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormFieldWidget(
                                          controller: _divisiController,
                                          hintText: 'Business Solution',
                                          maxHeightConstraints: _maxHeightNomor,
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightTall,
                                        ),
                                        Text(
                                          'Entitas : ',
                                          style: TextStyle(
                                              color: const Color(primaryBlack),
                                              fontSize: textMedium,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormFieldWidget(
                                          controller: _entitasController,
                                          hintText:
                                              'PT Hasnur Informasi Teknologi',
                                          maxHeightConstraints: _maxHeightNomor,
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightTall,
                                        ),
                                        Text(
                                          'Tanggal Mulai Bekerja : ',
                                          style: TextStyle(
                                              color: const Color(primaryBlack),
                                              fontSize: textMedium,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormFieldWidget(
                                          controller: _nrpController,
                                          hintText: 'dd/mm/yyyy',
                                          maxHeightConstraints: _maxHeightNomor,
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        Text(
                                          'Total Mengikuti Kegiatan Training : ',
                                          style: TextStyle(
                                              color: const Color(primaryBlack),
                                              fontSize: textMedium,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormFieldWidget(
                                          controller: _totalTrainingController,
                                          hintText: '2 Kali',
                                          maxHeightConstraints: _maxHeightNomor,
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
                                        Text(
                                          'Informasi Kegiatan Training',
                                          style: TextStyle(
                                              color: const Color(primaryBlack),
                                              fontSize: textLarge,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightTall,
                                        ),
                                        Text(
                                          'Mohon untuk dilampirkan brosur / pamflet / undangan kegiatan training',
                                          style: TextStyle(
                                              color: const Color(primaryBlack),
                                              fontSize: textSmall,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w300),
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        Text(
                                          'Tanggal Training : ',
                                          style: TextStyle(
                                              color: const Color(primaryBlack),
                                              fontSize: textMedium,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormFieldWidget(
                                          controller:
                                              _tanggalTrainingController,
                                          hintText: 'dd/mm/yyyy',
                                          maxHeightConstraints: _maxHeightNomor,
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightTall,
                                        ),
                                        Text(
                                          'Judul Training : ',
                                          style: TextStyle(
                                              color: const Color(primaryBlack),
                                              fontSize: textMedium,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormFieldWidget(
                                          controller: _judulTrainingController,
                                          hintText: 'Algoritma',
                                          maxHeightConstraints: _maxHeightNomor,
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightTall,
                                        ),
                                        Text(
                                          'Institusi Training : ',
                                          style: TextStyle(
                                              color: const Color(primaryBlack),
                                              fontSize: textMedium,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormFieldWidget(
                                          controller:
                                              _institusiTrainingController,
                                          hintText: 'Hasnur',
                                          maxHeightConstraints: _maxHeightNomor,
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightTall,
                                        ),
                                        Text(
                                          'Lokasi Training : ',
                                          style: TextStyle(
                                              color: const Color(primaryBlack),
                                              fontSize: textMedium,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormFieldWidget(
                                          controller: _lokasiTrainingController,
                                          hintText:
                                              'Banjarbaru, Kalimantan Selatan',
                                          maxHeightConstraints: _maxHeightNomor,
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightTall,
                                        ),
                                        Text(
                                          'Lampiran * : ',
                                          style: TextStyle(
                                              color: const Color(primaryBlack),
                                              fontSize: textMedium,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormFieldWidget(
                                          controller:
                                              _LampiranTrainingController,
                                          hintText: 'Lampiran',
                                          maxHeightConstraints: _maxHeightNomor,
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightTall,
                                        ),
                                        Text(
                                          'Jenis Training : ',
                                          style: TextStyle(
                                              color: const Color(primaryBlack),
                                              fontSize: textMedium,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormFieldWidget(
                                          controller: _jenisTrainingController,
                                          hintText: 'Sertifikasi Training',
                                          maxHeightConstraints: _maxHeightNomor,
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        Text(
                                          'Periode Ikatan Dinas : ',
                                          style: TextStyle(
                                              color: const Color(primaryBlack),
                                              fontSize: textMedium,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormFieldWidget(
                                          controller: _ikatanDinasController,
                                          hintText: '... bulan',
                                          maxHeightConstraints: _maxHeightNomor,
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
                                        Text(
                                          'Evaluasi Pra-Training',
                                          style: TextStyle(
                                              color: const Color(primaryBlack),
                                              fontSize: textLarge,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightTall,
                                        ),
                                        Text(
                                          'Disi oleh atasan karwayan yang akan mengajukan training',
                                          style: TextStyle(
                                              color: const Color(primaryBlack),
                                              fontSize: textSmall,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w300),
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        Text(
                                          'Fungsi training : ',
                                          style: TextStyle(
                                              color: const Color(primaryBlack),
                                              fontSize: textMedium,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        DropdownButtonFormField<String>(
                                          value: selectedFungsiTraining,
                                          onChanged: (newValue) {
                                            setState(() {
                                              selectedFungsiTraining =
                                                  newValue ?? '';
                                            });
                                          },
                                          items: <String>[
                                            'Sangat Direkomendasikan',
                                            'Option 2',
                                            'Option 3',
                                            'Option 4'
                                          ].map<DropdownMenuItem<String>>(
                                              (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(1.0),
                                                child: Text(
                                                  value,
                                                  style: TextStyle(
                                                    fontSize: textMedium,
                                                    fontFamily: 'Poppins',
                                                  ),
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                          decoration: InputDecoration(
                                            labelStyle:
                                                TextStyle(fontSize: textSmall),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              borderSide: const BorderSide(
                                                  color: Colors.transparent,
                                                  width: 0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              borderSide: const BorderSide(
                                                  color: Colors.black,
                                                  width: 1),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                borderSide: const BorderSide(
                                                    color: Colors.grey,
                                                    width: 0)),
                                            // constraints:
                                            //     BoxConstraints(maxHeight: 50),
                                          ),
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightTall,
                                        ),
                                        Text(
                                          'Tujuan Objektif : ',
                                          style: TextStyle(
                                              color: const Color(primaryBlack),
                                              fontSize: textMedium,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        DropdownButtonFormField<String>(
                                          value: selectedTujuanObjektif,
                                          onChanged: (newValue) {
                                            setState(() {
                                              selectedTujuanObjektif =
                                                  newValue ?? '';
                                            });
                                          },
                                          items: <String>[
                                            'Pengambangan untuk kebutuhan jabatan',
                                            'Option 2',
                                            'Option 3',
                                            'Option 4'
                                          ].map<DropdownMenuItem<String>>(
                                              (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(1.0),
                                                child: Text(
                                                  value,
                                                  style: TextStyle(
                                                    fontSize: textMedium,
                                                    fontFamily: 'Poppins',
                                                  ),
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                          decoration: InputDecoration(
                                            labelStyle:
                                                TextStyle(fontSize: textSmall),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              borderSide: const BorderSide(
                                                  color: Colors.transparent,
                                                  width: 0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              borderSide: const BorderSide(
                                                  color: Colors.black,
                                                  width: 1),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                borderSide: const BorderSide(
                                                    color: Colors.grey,
                                                    width: 0)),
                                            // constraints:
                                            //     BoxConstraints(maxHeight: 50),
                                          ),
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightTall,
                                        ),
                                        Text(
                                          'Penugasan Karyawan : ',
                                          style: TextStyle(
                                              color: const Color(primaryBlack),
                                              fontSize: textMedium,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        DropdownButtonFormField<String>(
                                          value: selectedPenugasanKaryawan,
                                          onChanged: (newValue) {
                                            setState(() {
                                              selectedPenugasanKaryawan =
                                                  newValue ?? '';
                                            });
                                          },
                                          items: <String>[
                                            'Presentasi isi Training',
                                            'Option 2',
                                            'Option 3',
                                            'Option 4'
                                          ].map<DropdownMenuItem<String>>(
                                              (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(1.0),
                                                child: Text(
                                                  value,
                                                  style: TextStyle(
                                                    fontSize: textMedium,
                                                    fontFamily: 'Poppins',
                                                  ),
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                          decoration: InputDecoration(
                                            labelStyle:
                                                TextStyle(fontSize: textSmall),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              borderSide: const BorderSide(
                                                  color: Colors.transparent,
                                                  width: 0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              borderSide: const BorderSide(
                                                  color: Colors.black,
                                                  width: 1),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                borderSide: const BorderSide(
                                                    color: Colors.grey,
                                                    width: 0)),
                                            // constraints:
                                            //     BoxConstraints(maxHeight: 50),
                                          ),
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
                                        Text(
                                          'Evaluasi hasil Training',
                                          style: TextStyle(
                                              color: const Color(primaryBlack),
                                              fontSize: textLarge,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightTall,
                                        ),
                                        Text(
                                          'Diisi oleh karyawan yang telah mengikuti training',
                                          style: TextStyle(
                                              color: const Color(primaryBlack),
                                              fontSize: textSmall,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w300),
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        Text(
                                          'Ringkasan Training : ',
                                          style: TextStyle(
                                              color: const Color(primaryBlack),
                                              fontSize: textMedium,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormFieldWidget(
                                          controller:
                                              _ringkasanTrainingController,
                                          hintText: '....',
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightTall,
                                        ),
                                        Text(
                                          'Manfaat Training bagi Karyawan : ',
                                          style: TextStyle(
                                              color: const Color(primaryBlack),
                                              fontSize: textMedium,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormFieldWidget(
                                          controller:
                                              _manfaatTrainingBagiKaryawanController,
                                          hintText:
                                              'Pengembangan untuk kebutuhan Jabatan',
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightTall,
                                        ),
                                        Text(
                                          'Manfaat Training bagi Perusahaan : ',
                                          style: TextStyle(
                                              color: const Color(primaryBlack),
                                              fontSize: textMedium,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormFieldWidget(
                                          controller:
                                              _manfaatTrainingBagiKaryawanController,
                                          hintText:
                                              'Memiliki Karyawan yang memiliki Pengetahuan Luas',
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightExtraTall,
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
                              onTabLeft: () {},
                              onTabRight: () {},
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
