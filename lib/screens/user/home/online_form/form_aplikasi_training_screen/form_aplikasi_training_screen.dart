import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:mobile_ess/themes/constant.dart';
import 'package:mobile_ess/widgets/button_two_row_widget.dart';

class FormAplikasiTrainingScreen extends StatefulWidget {
  const FormAplikasiTrainingScreen({super.key});

  @override
  State<FormAplikasiTrainingScreen> createState() =>
      _FormAplikasiTrainingScreenState();
}

List<String> options = ['Tinggi', 'Normal', 'Rendah'];

class _FormAplikasiTrainingScreenState
    extends State<FormAplikasiTrainingScreen> {
  String currentOption = options[0];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nrpController = TextEditingController();
  final TextEditingController _judulTrainingController =
      TextEditingController();
  final TextEditingController _fungsiTrainingController =
      TextEditingController();
  final TextEditingController _ringkasanTrainingController =
      TextEditingController();

  final _nomorController = TextEditingController();
  double _maxHeightNomor = 40.0;

  List<String> items = [
    'Diajukan Oleh',
    'Informasi Training',
    'Evaluasi Pra - Training',
    'Evaluasi Hasil Training'
  ];

  int current = 0;

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime(3000, 2, 1, 10, 20);
    Size size = MediaQuery.of(context).size;

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
                  const SizedBox(
                    height: sizedBoxHeightExtraTall,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      'Prioritas',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Color(primaryBlack),
                          fontSize: textMedium,
                          fontFamily: 'Poppins',
                          letterSpacing: 0.9,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(
                    height: sizedBoxHeightShort,
                  ),
                  ListTile(
                    title: const Text(
                      'Tinggi',
                      style: TextStyle(
                          color: Color(primaryBlack),
                          fontSize: textMedium,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w300),
                    ),
                    leading: Radio(
                      value: options[0],
                      groupValue: currentOption,
                      onChanged: (value) {
                        setState(() {
                          currentOption = value.toString();
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text(
                      'Normal',
                      style: TextStyle(
                          color: Color(primaryBlack),
                          fontSize: textMedium,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w300),
                    ),
                    leading: Radio(
                      value: options[1],
                      groupValue: currentOption,
                      onChanged: (value) {
                        setState(() {
                          currentOption = value.toString();
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text(
                      'Rendah',
                      style: TextStyle(
                          color: Color(primaryBlack),
                          fontSize: textMedium,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w300),
                    ),
                    leading: Radio(
                      value: options[2],
                      groupValue: currentOption,
                      onChanged: (value) {
                        setState(() {
                          currentOption = value.toString();
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    height: sizedBoxHeightTall,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      'Nomor',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Color(primaryBlack),
                          fontSize: textMedium,
                          fontFamily: 'Poppins',
                          letterSpacing: 0.9,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(
                    height: sizedBoxHeightTall,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: paddingHorizontalNarrow),
                    child: TextFormField(
                      controller: _nomorController,
                      // validator: (value) {
                      //   if (value == null || value.isEmpty) {
                      //     return 'NRP Kosong';
                      //   } else if (value.length < 8) {
                      //     return 'Password Kosong';
                      //   }
                      //   return null;
                      // },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                            width: 0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                                color: Colors.black, width: 1)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide:
                                const BorderSide(color: Colors.grey, width: 0)),
                        constraints: BoxConstraints(maxHeight: _maxHeightNomor),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: '0001/LND/HJU/V/2023',
                        hintStyle: const TextStyle(
                          fontSize: textMedium,
                          fontFamily: 'Poppins',
                          color: Color(textPlaceholder),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: sizedBoxHeightExtraTall,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      'Tangal Pengajuan',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Color(primaryBlack),
                          fontSize: textMedium,
                          fontFamily: 'Poppins',
                          letterSpacing: 0.9,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  CupertinoButton(
                    child: Container(
                      width: size.width,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
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
                            style: const TextStyle(
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
                  const SizedBox(
                    height: sizedBoxHeightShort,
                  ),
                  SingleChildScrollView(
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      width: double.infinity,
                      height: 400,
                      child: Column(
                        children: [
                          TabBar(
                            indicatorSize: TabBarIndicatorSize.label,
                            indicatorColor: Colors.black,
                            labelColor: Colors.black,
                            unselectedLabelColor: Colors.grey,
                            labelPadding:
                                const EdgeInsets.symmetric(horizontal: 16),
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: sizedBoxHeightExtraTall,
                                        ),
                                        const Text(
                                          'NRP : ',
                                          style: TextStyle(
                                              color: Color(primaryBlack),
                                              fontSize: textMedium,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w300),
                                        ),
                                        const SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormField(
                                          controller: _nrpController,
                                          decoration: InputDecoration(
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
                                            constraints: BoxConstraints(
                                                maxHeight: _maxHeightNomor),
                                            filled: true,
                                            fillColor: Colors.white,
                                            hintText: '78220012',
                                            hintStyle: const TextStyle(
                                              fontSize: textSmall,
                                              fontFamily: 'Poppins',
                                              color: Color(textPlaceholder),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: sizedBoxHeightTall,
                                        ),
                                        const Text(
                                          'Nama : ',
                                          style: TextStyle(
                                              color: Color(primaryBlack),
                                              fontSize: textMedium,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w300),
                                        ),
                                        const SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormField(
                                          controller: _nrpController,
                                          decoration: InputDecoration(
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
                                            constraints: BoxConstraints(
                                                maxHeight: _maxHeightNomor),
                                            filled: true,
                                            fillColor: Colors.white,
                                            hintText: 'Hasnur',
                                            hintStyle: const TextStyle(
                                              fontSize: textSmall,
                                              fontFamily: 'Poppins',
                                              color: Color(textPlaceholder),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: sizedBoxHeightTall,
                                        ),
                                        const Text(
                                          'Jabatan : ',
                                          style: TextStyle(
                                              color: Color(primaryBlack),
                                              fontSize: textMedium,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w300),
                                        ),
                                        const SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormField(
                                          controller: _nrpController,
                                          decoration: InputDecoration(
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
                                            constraints: BoxConstraints(
                                                maxHeight: _maxHeightNomor),
                                            filled: true,
                                            fillColor: Colors.white,
                                            hintText: 'Programmer',
                                            hintStyle: const TextStyle(
                                              fontSize: textSmall,
                                              fontFamily: 'Poppins',
                                              color: Color(textPlaceholder),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: sizedBoxHeightTall,
                                        ),
                                        const Text(
                                          'Divisi/Department : ',
                                          style: TextStyle(
                                              color: Color(primaryBlack),
                                              fontSize: textMedium,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w300),
                                        ),
                                        const SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormField(
                                          controller: _nrpController,
                                          decoration: InputDecoration(
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
                                            constraints: BoxConstraints(
                                                maxHeight: _maxHeightNomor),
                                            filled: true,
                                            fillColor: Colors.white,
                                            hintText: 'Business Solution',
                                            hintStyle: const TextStyle(
                                              fontSize: textSmall,
                                              fontFamily: 'Poppins',
                                              color: Color(textPlaceholder),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: sizedBoxHeightTall,
                                        ),
                                        const Text(
                                          'Entitas : ',
                                          style: TextStyle(
                                              color: Color(primaryBlack),
                                              fontSize: textMedium,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w300),
                                        ),
                                        const SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormField(
                                          controller: _nrpController,
                                          decoration: InputDecoration(
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
                                            constraints: BoxConstraints(
                                                maxHeight: _maxHeightNomor),
                                            filled: true,
                                            fillColor: Colors.white,
                                            hintText:
                                                'PT Hasnur Informasi Teknologi',
                                            hintStyle: const TextStyle(
                                              fontSize: textSmall,
                                              fontFamily: 'Poppins',
                                              color: Color(textPlaceholder),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: sizedBoxHeightTall,
                                        ),
                                        const Text(
                                          'Tanggal Mulai Bekerja : ',
                                          style: TextStyle(
                                              color: Color(primaryBlack),
                                              fontSize: textMedium,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w300),
                                        ),
                                        const SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormField(
                                          controller: _nrpController,
                                          decoration: InputDecoration(
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
                                            constraints: BoxConstraints(
                                                maxHeight: _maxHeightNomor),
                                            filled: true,
                                            fillColor: Colors.white,
                                            hintText: 'dd/mm/yyyy',
                                            hintStyle: const TextStyle(
                                              fontSize: textSmall,
                                              fontFamily: 'Poppins',
                                              color: Color(textPlaceholder),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        const Text(
                                          'Total Mengikuti Kegiatan Training : ',
                                          style: TextStyle(
                                              color: Color(primaryBlack),
                                              fontSize: textMedium,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w300),
                                        ),
                                        const SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormField(
                                          controller: _nrpController,
                                          decoration: InputDecoration(
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
                                            constraints: BoxConstraints(
                                                maxHeight: _maxHeightNomor),
                                            filled: true,
                                            fillColor: Colors.white,
                                            hintText: '2 Kali',
                                            hintStyle: const TextStyle(
                                              fontSize: textSmall,
                                              fontFamily: 'Poppins',
                                              color: Color(textPlaceholder),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: sizedBoxHeightExtraTall,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: sizedBoxHeightExtraTall,
                                        ),
                                        const Text(
                                          'NRP : ',
                                          style: TextStyle(
                                              color: Color(primaryBlack),
                                              fontSize: textMedium,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w300),
                                        ),
                                        const SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormField(
                                          controller: _nrpController,
                                          decoration: InputDecoration(
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
                                            constraints: BoxConstraints(
                                                maxHeight: _maxHeightNomor),
                                            filled: true,
                                            fillColor: Colors.white,
                                            hintText: '78220012',
                                            hintStyle: const TextStyle(
                                              fontSize: textSmall,
                                              fontFamily: 'Poppins',
                                              color: Color(textPlaceholder),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: sizedBoxHeightTall,
                                        ),
                                        const Text(
                                          'Nama : ',
                                          style: TextStyle(
                                              color: Color(primaryBlack),
                                              fontSize: textMedium,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w300),
                                        ),
                                        const SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormField(
                                          controller: _nrpController,
                                          decoration: InputDecoration(
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
                                            constraints: BoxConstraints(
                                                maxHeight: _maxHeightNomor),
                                            filled: true,
                                            fillColor: Colors.white,
                                            hintText: 'Hasnur',
                                            hintStyle: const TextStyle(
                                              fontSize: textSmall,
                                              fontFamily: 'Poppins',
                                              color: Color(textPlaceholder),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: sizedBoxHeightTall,
                                        ),
                                        const Text(
                                          'Jabatan : ',
                                          style: TextStyle(
                                              color: Color(primaryBlack),
                                              fontSize: textMedium,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w300),
                                        ),
                                        const SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormField(
                                          controller: _nrpController,
                                          decoration: InputDecoration(
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
                                            constraints: BoxConstraints(
                                                maxHeight: _maxHeightNomor),
                                            filled: true,
                                            fillColor: Colors.white,
                                            hintText: 'Programmer',
                                            hintStyle: const TextStyle(
                                              fontSize: textSmall,
                                              fontFamily: 'Poppins',
                                              color: Color(textPlaceholder),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: sizedBoxHeightTall,
                                        ),
                                        const Text(
                                          'Divisi/Department : ',
                                          style: TextStyle(
                                              color: Color(primaryBlack),
                                              fontSize: textMedium,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w300),
                                        ),
                                        const SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormField(
                                          controller: _nrpController,
                                          decoration: InputDecoration(
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
                                            constraints: BoxConstraints(
                                                maxHeight: _maxHeightNomor),
                                            filled: true,
                                            fillColor: Colors.white,
                                            hintText: 'Business Solution',
                                            hintStyle: const TextStyle(
                                              fontSize: textSmall,
                                              fontFamily: 'Poppins',
                                              color: Color(textPlaceholder),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: sizedBoxHeightTall,
                                        ),
                                        const Text(
                                          'Entitas : ',
                                          style: TextStyle(
                                              color: Color(primaryBlack),
                                              fontSize: textMedium,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w300),
                                        ),
                                        const SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormField(
                                          controller: _nrpController,
                                          decoration: InputDecoration(
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
                                            constraints: BoxConstraints(
                                                maxHeight: _maxHeightNomor),
                                            filled: true,
                                            fillColor: Colors.white,
                                            hintText:
                                                'PT Hasnur Informasi Teknologi',
                                            hintStyle: const TextStyle(
                                              fontSize: textSmall,
                                              fontFamily: 'Poppins',
                                              color: Color(textPlaceholder),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: sizedBoxHeightTall,
                                        ),
                                        const Text(
                                          'Tanggal Mulai Bekerja : ',
                                          style: TextStyle(
                                              color: Color(primaryBlack),
                                              fontSize: textMedium,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w300),
                                        ),
                                        const SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormField(
                                          controller: _nrpController,
                                          decoration: InputDecoration(
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
                                            constraints: BoxConstraints(
                                                maxHeight: _maxHeightNomor),
                                            filled: true,
                                            fillColor: Colors.white,
                                            hintText: 'dd/mm/yyyy',
                                            hintStyle: const TextStyle(
                                              fontSize: textSmall,
                                              fontFamily: 'Poppins',
                                              color: Color(textPlaceholder),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        const Text(
                                          'Total Mengikuti Kegiatan Training : ',
                                          style: TextStyle(
                                              color: Color(primaryBlack),
                                              fontSize: textMedium,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w300),
                                        ),
                                        const SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormField(
                                          controller: _nrpController,
                                          decoration: InputDecoration(
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
                                            constraints: BoxConstraints(
                                                maxHeight: _maxHeightNomor),
                                            filled: true,
                                            fillColor: Colors.white,
                                            hintText: '2 Kali',
                                            hintStyle: const TextStyle(
                                              fontSize: textSmall,
                                              fontFamily: 'Poppins',
                                              color: Color(textPlaceholder),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: sizedBoxHeightExtraTall,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: sizedBoxHeightExtraTall,
                                        ),
                                        const Text(
                                          'NRP : ',
                                          style: TextStyle(
                                              color: Color(primaryBlack),
                                              fontSize: textMedium,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w300),
                                        ),
                                        const SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormField(
                                          controller: _nrpController,
                                          decoration: InputDecoration(
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
                                            constraints: BoxConstraints(
                                                maxHeight: _maxHeightNomor),
                                            filled: true,
                                            fillColor: Colors.white,
                                            hintText: '78220012',
                                            hintStyle: const TextStyle(
                                              fontSize: textSmall,
                                              fontFamily: 'Poppins',
                                              color: Color(textPlaceholder),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: sizedBoxHeightTall,
                                        ),
                                        const Text(
                                          'Nama : ',
                                          style: TextStyle(
                                              color: Color(primaryBlack),
                                              fontSize: textMedium,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w300),
                                        ),
                                        const SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormField(
                                          controller: _nrpController,
                                          decoration: InputDecoration(
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
                                            constraints: BoxConstraints(
                                                maxHeight: _maxHeightNomor),
                                            filled: true,
                                            fillColor: Colors.white,
                                            hintText: 'Hasnur',
                                            hintStyle: const TextStyle(
                                              fontSize: textSmall,
                                              fontFamily: 'Poppins',
                                              color: Color(textPlaceholder),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: sizedBoxHeightTall,
                                        ),
                                        const Text(
                                          'Jabatan : ',
                                          style: TextStyle(
                                              color: Color(primaryBlack),
                                              fontSize: textMedium,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w300),
                                        ),
                                        const SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormField(
                                          controller: _nrpController,
                                          decoration: InputDecoration(
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
                                            constraints: BoxConstraints(
                                                maxHeight: _maxHeightNomor),
                                            filled: true,
                                            fillColor: Colors.white,
                                            hintText: 'Programmer',
                                            hintStyle: const TextStyle(
                                              fontSize: textSmall,
                                              fontFamily: 'Poppins',
                                              color: Color(textPlaceholder),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: sizedBoxHeightTall,
                                        ),
                                        const Text(
                                          'Divisi/Department : ',
                                          style: TextStyle(
                                              color: Color(primaryBlack),
                                              fontSize: textMedium,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w300),
                                        ),
                                        const SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormField(
                                          controller: _nrpController,
                                          decoration: InputDecoration(
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
                                            constraints: BoxConstraints(
                                                maxHeight: _maxHeightNomor),
                                            filled: true,
                                            fillColor: Colors.white,
                                            hintText: 'Business Solution',
                                            hintStyle: const TextStyle(
                                              fontSize: textSmall,
                                              fontFamily: 'Poppins',
                                              color: Color(textPlaceholder),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: sizedBoxHeightTall,
                                        ),
                                        const Text(
                                          'Entitas : ',
                                          style: TextStyle(
                                              color: Color(primaryBlack),
                                              fontSize: textMedium,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w300),
                                        ),
                                        const SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormField(
                                          controller: _nrpController,
                                          decoration: InputDecoration(
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
                                            constraints: BoxConstraints(
                                                maxHeight: _maxHeightNomor),
                                            filled: true,
                                            fillColor: Colors.white,
                                            hintText:
                                                'PT Hasnur Informasi Teknologi',
                                            hintStyle: const TextStyle(
                                              fontSize: textSmall,
                                              fontFamily: 'Poppins',
                                              color: Color(textPlaceholder),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: sizedBoxHeightTall,
                                        ),
                                        const Text(
                                          'Tanggal Mulai Bekerja : ',
                                          style: TextStyle(
                                              color: Color(primaryBlack),
                                              fontSize: textMedium,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w300),
                                        ),
                                        const SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormField(
                                          controller: _nrpController,
                                          decoration: InputDecoration(
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
                                            constraints: BoxConstraints(
                                                maxHeight: _maxHeightNomor),
                                            filled: true,
                                            fillColor: Colors.white,
                                            hintText: 'dd/mm/yyyy',
                                            hintStyle: const TextStyle(
                                              fontSize: textSmall,
                                              fontFamily: 'Poppins',
                                              color: Color(textPlaceholder),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        const Text(
                                          'Total Mengikuti Kegiatan Training : ',
                                          style: TextStyle(
                                              color: Color(primaryBlack),
                                              fontSize: textMedium,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w300),
                                        ),
                                        const SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormField(
                                          controller: _nrpController,
                                          decoration: InputDecoration(
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
                                            constraints: BoxConstraints(
                                                maxHeight: _maxHeightNomor),
                                            filled: true,
                                            fillColor: Colors.white,
                                            hintText: '2 Kali',
                                            hintStyle: const TextStyle(
                                              fontSize: textSmall,
                                              fontFamily: 'Poppins',
                                              color: Color(textPlaceholder),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: sizedBoxHeightExtraTall,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: sizedBoxHeightExtraTall,
                                        ),
                                        const Text(
                                          'NRP : ',
                                          style: TextStyle(
                                              color: Color(primaryBlack),
                                              fontSize: textMedium,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w300),
                                        ),
                                        const SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormField(
                                          controller: _nrpController,
                                          decoration: InputDecoration(
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
                                            constraints: BoxConstraints(
                                                maxHeight: _maxHeightNomor),
                                            filled: true,
                                            fillColor: Colors.white,
                                            hintText: '78220012',
                                            hintStyle: const TextStyle(
                                              fontSize: textSmall,
                                              fontFamily: 'Poppins',
                                              color: Color(textPlaceholder),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: sizedBoxHeightTall,
                                        ),
                                        const Text(
                                          'Nama : ',
                                          style: TextStyle(
                                              color: Color(primaryBlack),
                                              fontSize: textMedium,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w300),
                                        ),
                                        const SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormField(
                                          controller: _nrpController,
                                          decoration: InputDecoration(
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
                                            constraints: BoxConstraints(
                                                maxHeight: _maxHeightNomor),
                                            filled: true,
                                            fillColor: Colors.white,
                                            hintText: 'Hasnur',
                                            hintStyle: const TextStyle(
                                              fontSize: textSmall,
                                              fontFamily: 'Poppins',
                                              color: Color(textPlaceholder),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: sizedBoxHeightTall,
                                        ),
                                        const Text(
                                          'Jabatan : ',
                                          style: TextStyle(
                                              color: Color(primaryBlack),
                                              fontSize: textMedium,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w300),
                                        ),
                                        const SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormField(
                                          controller: _nrpController,
                                          decoration: InputDecoration(
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
                                            constraints: BoxConstraints(
                                                maxHeight: _maxHeightNomor),
                                            filled: true,
                                            fillColor: Colors.white,
                                            hintText: 'Programmer',
                                            hintStyle: const TextStyle(
                                              fontSize: textSmall,
                                              fontFamily: 'Poppins',
                                              color: Color(textPlaceholder),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: sizedBoxHeightTall,
                                        ),
                                        const Text(
                                          'Divisi/Department : ',
                                          style: TextStyle(
                                              color: Color(primaryBlack),
                                              fontSize: textMedium,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w300),
                                        ),
                                        const SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormField(
                                          controller: _nrpController,
                                          decoration: InputDecoration(
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
                                            constraints: BoxConstraints(
                                                maxHeight: _maxHeightNomor),
                                            filled: true,
                                            fillColor: Colors.white,
                                            hintText: 'Business Solution',
                                            hintStyle: const TextStyle(
                                              fontSize: textSmall,
                                              fontFamily: 'Poppins',
                                              color: Color(textPlaceholder),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: sizedBoxHeightTall,
                                        ),
                                        const Text(
                                          'Entitas : ',
                                          style: TextStyle(
                                              color: Color(primaryBlack),
                                              fontSize: textMedium,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w300),
                                        ),
                                        const SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormField(
                                          controller: _nrpController,
                                          decoration: InputDecoration(
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
                                            constraints: BoxConstraints(
                                                maxHeight: _maxHeightNomor),
                                            filled: true,
                                            fillColor: Colors.white,
                                            hintText:
                                                'PT Hasnur Informasi Teknologi',
                                            hintStyle: const TextStyle(
                                              fontSize: textSmall,
                                              fontFamily: 'Poppins',
                                              color: Color(textPlaceholder),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: sizedBoxHeightTall,
                                        ),
                                        const Text(
                                          'Tanggal Mulai Bekerja : ',
                                          style: TextStyle(
                                              color: Color(primaryBlack),
                                              fontSize: textMedium,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w300),
                                        ),
                                        const SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormField(
                                          controller: _nrpController,
                                          decoration: InputDecoration(
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
                                            constraints: BoxConstraints(
                                                maxHeight: _maxHeightNomor),
                                            filled: true,
                                            fillColor: Colors.white,
                                            hintText: 'dd/mm/yyyy',
                                            hintStyle: const TextStyle(
                                              fontSize: textSmall,
                                              fontFamily: 'Poppins',
                                              color: Color(textPlaceholder),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        const Text(
                                          'Total Mengikuti Kegiatan Training : ',
                                          style: TextStyle(
                                              color: Color(primaryBlack),
                                              fontSize: textMedium,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w300),
                                        ),
                                        const SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormField(
                                          controller: _nrpController,
                                          decoration: InputDecoration(
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
                                            constraints: BoxConstraints(
                                                maxHeight: _maxHeightNomor),
                                            filled: true,
                                            fillColor: Colors.white,
                                            hintText: '2 Kali',
                                            hintStyle: const TextStyle(
                                              fontSize: textSmall,
                                              fontFamily: 'Poppins',
                                              color: Color(textPlaceholder),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: sizedBoxHeightExtraTall,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
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
}
