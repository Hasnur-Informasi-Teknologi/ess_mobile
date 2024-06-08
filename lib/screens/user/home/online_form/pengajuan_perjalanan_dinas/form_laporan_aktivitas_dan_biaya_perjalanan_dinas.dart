import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile_ess/helpers/http_override.dart';
import 'package:mobile_ess/helpers/url_helper.dart';
import 'package:mobile_ess/themes/colors.dart';
import 'package:mobile_ess/widgets/line_widget.dart';
import 'package:mobile_ess/widgets/row_with_button_widget.dart';
import 'package:mobile_ess/widgets/title_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class FormLaporanAktivitasDanBiayaPerjalananDinas extends StatefulWidget {
  const FormLaporanAktivitasDanBiayaPerjalananDinas({super.key});

  @override
  State<FormLaporanAktivitasDanBiayaPerjalananDinas> createState() =>
      _FormLaporanAktivitasDanBiayaPerjalananDinasState();
}

class _FormLaporanAktivitasDanBiayaPerjalananDinasState
    extends State<FormLaporanAktivitasDanBiayaPerjalananDinas> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Sesi 1
  List<Map<String, dynamic>> selectedTripNumber = [];
  String? selectedValueTripNumber;
  final _nrpController = TextEditingController();
  final _namaController = TextEditingController();
  final _departmentController = TextEditingController();
  final _perusahaanController = TextEditingController();
  final _lokasiDinasController = TextEditingController();
  final _perihalController = TextEditingController();
  // Sesi 1 Extra For Submit
  final _idTPerdinController = TextEditingController();
  final _jabatanController = TextEditingController();
  final _typeCostAssignController = TextEditingController();
  final _lamaPengajuanController = TextEditingController();
  final _lamaAktualController = TextEditingController();
  DateTime? datePengajuanBerangkat;
  TimeOfDay? timePengajuanBerangkat;
  DateTime? datePengajuanPulang;
  TimeOfDay? timePengajuanPulang;
  late DateTime selectedDateAktualBerangkat;
  late TimeOfDay selectedTimeAktualBerangkat;
  late DateTime selectedDateAktualPulang;
  late TimeOfDay selectedTimeAktualPulang;

  final _jumlahKasDiterimaController = TextEditingController();
  final _jumlahPengeluaranController = TextEditingController();
  final _kelebihanKasController = TextEditingController();
  final _kekuranganKasController = TextEditingController();

  // Sesi 2
  List<Map<String, dynamic>> activitiesReport = [];
  final _catatanAktivitasController = TextEditingController();

  // Sesi 3
  // `Laporan Biaya` Perjalanan Dinas
  List<Map<String, dynamic>> costReport = [];
  List<Map<String, dynamic>> selectedKategori = [];
  List<String?> selectedValueKategori = [];
  List<PlatformFile>? files;
  final _catatanBiayaController = TextEditingController();

  final double _maxHeightNama = 40.0;
  double _sizeKbs = 0;
  final int maxSizeKbs = 1024;
  final String apiUrl = API_URL;
  bool _isFileNull = false;
  bool _isLoading = false;
  bool _isLoadingTripNumber = true;
  Map<String, String?> validationMessages = {};
  Map<int, String> errorMessages = {};

  Timer? _debounce;

  // Define a function that takes a string and returns a tuple of the first and second words.
  Map<String, String> extractWords(String? input) {
    if (input == null) {
      return {'firstWord': '', 'secondWord': ''};
    }
    // Split the string by the hyphen.
    List<String> parts = input.split('-');
    if (parts.length >= 2) {
      // If there are at least two parts, return them in a map.
      return {
        'firstWord':
            parts[0].trim(), // Trim to remove any leading/trailing whitespace
        'secondWord': parts[1].trim()
      };
    } else {
      // Return an empty map if there aren't enough parts.
      return {'firstWord': '', 'secondWord': ''};
    }
  }

  String formatDate(DateTime? date, TimeOfDay? time, {bool isoFormat = false}) {
    if (date == null || time == null) return '';
    // Format month, day, hour, and minute with leading zeros if necessary
    String month = date.month.toString().padLeft(2, '0');
    String day = date.day.toString().padLeft(2, '0');
    String hour = time.hour.toString().padLeft(2, '0');
    String minute = time.minute.toString().padLeft(2, '0');
    // Construct the final date-time string based on format choice
    if (isoFormat) {
      return '${date.year}-$month-$day' 'T$hour:$minute';
    } else {
      return '${date.year}-$month-$day $hour:$minute:00';
    }
  }

  Future<void> calculateFinancials() async {
    // Logging the start of the function
    debugPrint('calculateFinancials - Start');

    // Calculating the total expenses
    int totalExpenses = costReport.fold(0, (sum, item) {
      int value = int.tryParse(item['nilai'].text) ?? 0;
      debugPrint('calculateFinancials - Total Expenses: $value');
      return sum + value;
    });

    // Logging the total expenses
    debugPrint('calculateFinancials - Total Expenses: $totalExpenses');

    // Parsing the jumlahKasDiterima text
    int jumlahKasDiterima =
        int.tryParse(_jumlahKasDiterimaController.text) ?? 0;

    // Logging the jumlahKasDiterima
    debugPrint('calculateFinancials - Jumlah Kas Diterima: $jumlahKasDiterima');

    // Updating the _jumlahPengeluaranController text
    _jumlahPengeluaranController.text = totalExpenses.toString();
    debugPrint('calculateFinancials - Jumlah Pengeluaran: $totalExpenses');

    // Checking if jumlahKasDiterima is greater than or equal to totalExpenses
    if (jumlahKasDiterima >= totalExpenses) {
      // Updating the _kelebihanKasController text
      _kelebihanKasController.text =
          (jumlahKasDiterima - totalExpenses).toString();
      debugPrint(
          'calculateFinancials - Kelebihan Kas: ${(jumlahKasDiterima - totalExpenses)}');

      // Updating the _kekuranganKasController text
      _kekuranganKasController.text = '0';
      debugPrint('calculateFinancials - Kekurangan Kas: 0');
    } else {
      // Updating the _kekuranganKasController text
      _kekuranganKasController.text =
          (totalExpenses - jumlahKasDiterima).toString();
      debugPrint(
          'calculateFinancials - Kekurangan Kas: ${(totalExpenses - jumlahKasDiterima)}');

      // Updating the _kelebihanKasController text
      _kelebihanKasController.text = '0';
      debugPrint('calculateFinancials - Kelebihan Kas: 0');
    }

    // Logging the end of the function
    debugPrint('calculateFinancials - End');
  }

  Future<void> debounceCalculation(VoidCallback action,
      {int milliseconds = 2000}) async {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(Duration(milliseconds: milliseconds), action);
  }

  // Fungsi reusable untuk menghitung durasi dan menampilkannya ke dalam bentuk tulisan
  String calculateDuration(DateTime startDateTime, DateTime endDateTime) {
    // Log the startDateTime
    debugPrint('Calculate duration with startDateTime: $startDateTime');

    // Log the endDateTime
    debugPrint('Calculate duration with endDateTime: $endDateTime');

    // Calculate the time difference between the two dates
    Duration difference = endDateTime.difference(startDateTime);

    // Get the number of days, hours and minutes in the time difference
    int days = difference.inDays;
    int hours = difference.inHours % 24;
    int minutes = difference.inMinutes % 60;

    // Format and return the duration string
    String durationString = '$days Hari $hours Jam $minutes Menit';
    debugPrint('Calculated duration: $durationString');
    return durationString;
  }

  // Fungsi untuk mendapatkan list nomor trip dari API
  Future<void> getTripNumber() async {
    // Retrieve the token from the shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    setState(() {
      _isLoadingTripNumber = true;
    });

    if (token != null) {
      try {
        final ioClient = createIOClientWithInsecureConnection();
        final response = await ioClient.get(
          Uri.parse("$apiUrl/laporan-perdin/get_trip_number"),
          headers: <String, String>{
            'Content-Type': 'application/json;charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
        );

        debugPrint('API Response: ${response.body}');
        final responseData = jsonDecode(response.body);

        setState(() {
          selectedTripNumber =
              List<Map<String, dynamic>>.from(responseData['data']);
          _isLoadingTripNumber = false;
        });
      } catch (e) {
        debugPrint('Error in getTripNumber: $e');
        setState(() {
          _isLoadingTripNumber = false;
        });
      }
    } else {
      setState(() {
        _isLoadingTripNumber = false;
      });
    }
  }

  // Fungsi untuk mendapatkan data detail dari selected trip number
  Future<void> getDataTripNumber(String tripNumber) async {
    // Retrieve the token from the shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      try {
        // Make a GET request to the API endpoint
        final ioClient = createIOClientWithInsecureConnection();
        final response = await ioClient.get(
          Uri.parse(
              "$apiUrl/laporan-perdin/get_im_perdin?trip_number=$tripNumber"),
          headers: <String, String>{
            'Content-Type': 'application/json;charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
        );

        // Decode the response data
        final responseData = jsonDecode(response.body);
        final data = responseData['parent'];

        // Log the response
        debugPrint('API Response Parent: $data');

        // Update the state with the relevant data
        setState(() {
          // Parse the datetime values
          DateTime startDate = DateTime.parse(data['tgl_berangkat']);
          DateTime endDate = DateTime.parse(data['tgl_kembali']);

          // Update the relevant fields in the state
          _nrpController.text = data['nrp_user'] ?? '';
          _namaController.text = data['nama_user'] ?? '';
          _departmentController.text = data['department_user'] ?? '';
          _perusahaanController.text = data['entitas_user'] ?? '';
          _lokasiDinasController.text =
              data['tempat_tujuan'] + ', ' + data['nama_negara'] ?? '';
          _perihalController.text = data['perihal'] ?? '';
          _lamaPengajuanController.text = calculateDuration(startDate, endDate);
          _jumlahKasDiterimaController.text = data['total_nilai'].toString();
          _idTPerdinController.text =
              responseData['child'][0]['id_tperdin'].toString();
          _jabatanController.text = data['jabatan_user'] ?? '';
          _typeCostAssignController.text = data['type_cost_assign'] ?? '';

          datePengajuanBerangkat = startDate;
          timePengajuanBerangkat = TimeOfDay.fromDateTime(startDate);
          datePengajuanPulang = endDate;
          timePengajuanPulang = TimeOfDay.fromDateTime(endDate);

          selectedKategori = List<Map<String, dynamic>>.from(
            responseData['list_cost_assign'],
          );
        });
      } catch (e) {
        // Log any errors that occur
        debugPrint('Error in getDataTripNumber: $e');
      }
    }
  }

  // Fungsi untuk set textfield Lama Aktual Perjalanan Dinas
  Future<void> _updateDuration() async {
    // Log the startDateTime
    debugPrint('updateDuration - startDateTime: '
        '${selectedDateAktualBerangkat.toString()} ${selectedTimeAktualBerangkat.toString()}');

    // Log the endDateTime
    debugPrint('updateDuration - endDateTime: '
        '${selectedDateAktualPulang.toString()} ${selectedTimeAktualPulang.toString()}');

    final DateTime startDateTime = DateTime(
      selectedDateAktualBerangkat.year,
      selectedDateAktualBerangkat.month,
      selectedDateAktualBerangkat.day,
      selectedTimeAktualBerangkat.hour,
      selectedTimeAktualBerangkat.minute,
    );

    final DateTime endDateTime = DateTime(
      selectedDateAktualPulang.year,
      selectedDateAktualPulang.month,
      selectedDateAktualPulang.day,
      selectedTimeAktualPulang.hour,
      selectedTimeAktualPulang.minute,
    );

    if (endDateTime.isAfter(startDateTime)) {
      setState(() {
        _lamaAktualController.text =
            calculateDuration(startDateTime, endDateTime);
      });
    } else {
      // Display snackbar notification if the end date and time is before the start date and time
      debugPrint('updateDuration - Waktu pulang harus setelah berangkat');
      Get.snackbar(
        "Waktu Tidak Valid",
        "Waktu pulang harus setelah berangkat",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        borderRadius: 20,
        margin: const EdgeInsets.all(15),
        duration: const Duration(seconds: 4),
      );
    }
  }

  // Fungsi untuk memperbarui tanggal pada sesi Laporan Aktivitas Perjalanan Dinas
  // jika terjadi perubahan tanggal waktu aktual berangkat dan tanggal waktu aktual pulang
  Future<void> _updateActivityDates(
      {required List<dynamic> reportType, required String keyField}) async {
    // Log the start date and time
    debugPrint('updateActivityDates - startDateTime: '
        '${selectedDateAktualBerangkat.toString()} '
        '${selectedTimeAktualBerangkat.toString()}');

    // Log the end date and time
    debugPrint('updateActivityDates - endDateTime: '
        '${selectedDateAktualPulang.toString()} '
        '${selectedTimeAktualPulang.toString()}');

    for (var report in reportType) {
      DateTime tanggal = DateTime.parse(report[keyField]);
      if (tanggal.isBefore(selectedDateAktualBerangkat) ||
          tanggal.isAfter(selectedDateAktualPulang)) {
        // Reset the report date to the start date or the closest valid date
        debugPrint('updateActivityDates - Reset report date to start date');
        report[keyField] = selectedDateAktualBerangkat.toString();
      }
    }
  }

  // Fungsi untuk memilih tanggal dan waktu aktual berangkat
  Future<void> _selectDateTimeAktualBerangkat(BuildContext context) async {
    // Log the initial values
    debugPrint('selectDateTimeAktualBerangkat - Initial values: '
        '${selectedDateAktualBerangkat.toString()} '
        '${selectedTimeAktualBerangkat.toString()}');

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateAktualBerangkat,
      firstDate: DateTime(2022),
      lastDate: DateTime(5022),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: selectedTimeAktualBerangkat,
      );

      if (pickedTime != null) {
        // Log the selected values
        debugPrint('selectDateTimeAktualBerangkat - Selected values: '
            '${pickedDate.toString()} ${pickedTime.toString()}');

        setState(() {
          selectedDateAktualBerangkat = pickedDate;
          selectedTimeAktualBerangkat = pickedTime;
          _updateActivityDates(
            reportType: activitiesReport,
            keyField: "tanggalAktivitas",
          );
          _updateDuration();
        });
      }
    }
  }

  // Fungsi untuk memilih tanggal dan waktu aktual pulang
  Future<void> _selectDateTimeAktualPulang(BuildContext context) async {
    // Log the initial values
    debugPrint('selectDateTimeAktualPulang - Initial values: '
        '${selectedDateAktualPulang.toString()} '
        '${selectedTimeAktualPulang.toString()}');

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateAktualPulang,
      firstDate: DateTime(2022),
      lastDate: DateTime(5022),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: selectedTimeAktualPulang,
      );

      if (pickedTime != null) {
        // Log the selected values
        debugPrint('selectDateTimeAktualPulang - Selected values: '
            '${pickedDate.toString()} ${pickedTime.toString()}');

        setState(() {
          selectedDateAktualPulang = pickedDate;
          selectedTimeAktualPulang = pickedTime;
          _updateActivityDates(
            reportType: costReport,
            keyField: "tanggalBiaya",
          );
          _updateDuration();
        });
      }
    }
  }

  // Fungsi untuk memilih tanggal pada sesi Laporan Aktivitas Perjalanan Dinas
  Future<void> _selectDate(
      {required int index,
      required List<dynamic> reportType,
      required String keyField}) async {
    // Log the initial date
    debugPrint(
        'selectDate - index: $index, initial date: ${reportType[index][keyField]}');

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.parse(reportType[index][keyField]),
      firstDate: selectedDateAktualBerangkat,
      lastDate: selectedDateAktualPulang,
    );

    // Log the picked date
    debugPrint('selectDate - index: $index, picked date: $picked');

    if (picked != null &&
        picked != DateTime.parse(reportType[index][keyField])) {
      setState(() {
        reportType[index][keyField] = picked.toString();
      });
    }
  }

  Future<void> pickFiles(
      {required int index, required List<dynamic> reportType}) async {
    // Logging the start of the function
    debugPrint('pickFiles - Start');

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png', 'jpeg'],
    );

    // Logging the result of the pickFiles function
    debugPrint('pickFiles - Result: $result');

    if (result != null) {
      final size = result.files.first.size;
      _sizeKbs = size / 1024;
      if (_sizeKbs > maxSizeKbs) {
        _isFileNull = true;
        Get.snackbar(
          'File Tidak Valid',
          'Ukuran file melebihi batas maksimum yang diizinkan sebesar 5 MB.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          borderRadius: 20,
          margin: const EdgeInsets.all(15),
          duration: const Duration(seconds: 4),
        );
      } else {
        setState(() {
          reportType[index]['files'] = result.files;
          _isFileNull = false;
        });
        Get.snackbar(
          'Success',
          'File berhasil diproses.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          borderRadius: 20,
          margin: const EdgeInsets.all(15),
          duration: const Duration(seconds: 4),
        );
      }
    }

    // Logging the end of the function
    debugPrint('pickFiles - End');
  }

  @override
  void dispose() {
    for (var activity in activitiesReport) {
      activity['aktivitas'].dispose();
      activity['hasilAktivitas'].dispose();
      activity['hambatan'].dispose();
      activity['tindakLanjut'].dispose();
    }

    for (var activity in costReport) {
      activity['uraian'].dispose();
      activity['nilai'].dispose();
    }

    _debounce?.cancel();
    _nrpController.dispose();
    _namaController.dispose();
    _departmentController.dispose();
    _perusahaanController.dispose();
    _lokasiDinasController.dispose();
    _perihalController.dispose();
    _lamaPengajuanController.dispose();
    _lamaAktualController.dispose();
    _jumlahKasDiterimaController.dispose();
    _jumlahPengeluaranController.dispose();
    _kelebihanKasController.dispose();
    _kekuranganKasController.dispose();

    // Log the disposal of all controllers
    debugPrint('FormLaporanAktivitasDanBiayaPerjalananDinas disposed.');

    _debounce?.cancel();

    // Call the superclass's dispose method
    super.dispose();
  }

  Future<void> addActivity(
      {required List<Map<String, dynamic>> reportType}) async {
    // Log the current state of reportType
    for (var report in reportType) {
      debugPrint('addActivity - Current reportType: $report');
    }

    setState(() {
      if (reportType == activitiesReport) {
        reportType.add({
          "tanggalAktivitas": selectedDateAktualBerangkat.toString(),
          "aktivitas": TextEditingController(),
          "hasilAktivitas": TextEditingController(),
          "hambatan": TextEditingController(),
          "tindakLanjut": TextEditingController(),
          "selected": false
        });
      } else if (reportType == costReport) {
        reportType.add({
          "tanggalBiaya": selectedDateAktualBerangkat.toString(),
          "uraian": TextEditingController(),
          "nilai": TextEditingController(),
          "files": <PlatformFile>[],
        });
        selectedValueKategori.add(null);
      }
    });
  }

  Future<void> removeActivity(
      {required int index,
      required List<Map<String, dynamic>> reportType}) async {
    // Log the current state of reportType
    debugPrint(
        'removeActivity - Current reportType: $reportType at index: $index');

    // Remove the activity at the given index from the list
    if (reportType == activitiesReport) {
      setState(() {
        activitiesReport.removeAt(index);
      });
    } else if (reportType == costReport) {
      setState(() {
        costReport.removeAt(index);
        selectedValueKategori[index] = null;
        files?[index] = <PlatformFile>[] as PlatformFile;
      });
    }
  }

  @override
  void initState() {
    // Call the super class to initialize the state
    super.initState();

    // Retrieve the trip number
    getTripNumber();

    // Set the initial selected date and time for aktual berangkat and aktual pulang
    selectedDateAktualBerangkat = DateTime.now();
    selectedTimeAktualBerangkat = TimeOfDay.now();
    selectedDateAktualPulang = DateTime.now();
    selectedTimeAktualPulang = TimeOfDay.now();

    // Log the initialization of the widget
    debugPrint('Initialized FormLaporanAktivitasDanBiayaPerjalananDinasState');
  }

  Future<void> _submit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    setState(() {
      _isLoading = true;
    });

    if (!_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$apiUrl/laporan-perdin/add'),
    );
    request.headers['Content-Type'] = 'multipart/form-data';
    request.headers['Authorization'] = 'Bearer $token';

    Map<String, dynamic> formattedReport = {};
    for (int i = 0; i < costReport.length; i++) {
      String input = selectedValueKategori[i] ?? '';
      Map<String, String> words = extractWords(input);

      List<PlatformFile> files =
          costReport[i]['files'] as List<PlatformFile>? ?? <PlatformFile>[];

      if (files.isNotEmpty) {
        // We'll just take the first file for this example
        PlatformFile platformFile = files[i];
        File file = File(platformFile.path!);

        formattedReport['vtable2[$i][tgl_biaya]'] =
            costReport[i]['tanggalBiaya'];
        formattedReport['vtable2[$i][kategori]'] = words['firstWord']!;
        formattedReport['vtable2[$i][kategori_name]'] = words['secondWord']!;
        formattedReport['vtable2[$i][uraian]'] = costReport[i]['uraian'].text;
        formattedReport['vtable2[$i][nilai]'] = costReport[i]['nilai'].text;
        request.files.add(http.MultipartFile('vtable2[$i][lampiran]',
            file.readAsBytes().asStream(), file.lengthSync(),
            filename: file.path.split('/').last));
      } else {
        Get.snackbar('Infomation', 'File Wajib Diisi',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.amber,
            icon: const Icon(
              Icons.info,
              color: Colors.white,
            ),
            shouldIconPulse: false);
        setState(() {
          _isLoading = false;
        });
        return;
      }
    }
    request.fields['jml_kas_diterima'] = _jumlahKasDiterimaController.text;
    request.fields['jml_pengeluaran'] = _jumlahPengeluaranController.text;
    request.fields['jml_kelebihan_kas'] = _kelebihanKasController.text;
    request.fields['jml_kekurangan_kas'] = _kekuranganKasController.text;
    request.fields['trip_number'] = selectedValueTripNumber.toString();
    request.fields['id_tperdin'] = _idTPerdinController.text;
    request.fields['nrp_user'] = _nrpController.text;
    request.fields['jabatan_user'] = _jabatanController.text;
    request.fields['department_user'] = _departmentController.text;
    request.fields['entitas_user'] = _perusahaanController.text;
    request.fields['tempat_tujuan'] = _lokasiDinasController.text;
    request.fields['perihal'] = _perihalController.text;
    request.fields['tgl_berangkat'] =
        formatDate(datePengajuanBerangkat, timePengajuanBerangkat);
    request.fields['tgl_kembali'] =
        formatDate(datePengajuanPulang, timePengajuanPulang);
    request.fields['type_cost_assign'] = _typeCostAssignController.text;
    request.fields['lama_rencana_perdin'] = _lamaPengajuanController.text;
    request.fields['lama_aktual_perdin'] = _lamaAktualController.text;
    request.fields['tgl_aktual_berangkat'] = formatDate(
        selectedDateAktualBerangkat, selectedTimeAktualBerangkat,
        isoFormat: true);
    request.fields['tgl_aktual_kembali'] = formatDate(
        selectedDateAktualPulang, selectedTimeAktualPulang,
        isoFormat: true);
    request.fields['catatan_biaya'] = _catatanBiayaController.text;
    request.fields['catatan_aktivitas'] = _catatanAktivitasController.text;
    request.fields['vtable'] = jsonEncode(activitiesReport.map((activity) {
      return {
        "tgl_aktivitas": activity["tanggalAktivitas"],
        "aktivitas": activity["aktivitas"].text,
        "hasil_aktivitas": activity["hasilAktivitas"].text,
        "hambatan": activity["hambatan"].text,
        "tindak_lanjut": activity["tindakLanjut"].text,
        "selected": activity["selected"]
      };
    }).toList());
    formattedReport.forEach((key, value) {
      request.fields[key] = value;
    });

    debugPrint('Body: ${request.fields}');

    try {
      var response = await request.send();
      final responseData = await response.stream.bytesToString();
      final responseDataMessage = json.decode(responseData);
      Get.snackbar('Infomation', responseDataMessage['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.amber,
          icon: const Icon(
            Icons.info,
            color: Colors.white,
          ),
          shouldIconPulse: false);
      setState(() {
        _isLoading = false;
      });
      debugPrint('Message $responseDataMessage');
      if (responseDataMessage['status'] == 'success') {
        activitiesReport.clear();
        costReport.clear();
        Get.offAllNamed(
            '/user/main/home/online_form/pengajuan_perjalanan_dinas');
      }
    } catch (e) {
      debugPrint('Error: $e');
      Get.snackbar('Error', 'Failed to submit the form. Please try again.');
      rethrow;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textSmall = size.width * 0.027;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightTall = size.height * 0.0163;
    double sizedBoxHeightShort = size.height * 0.0086;
    double paddingHorizontalNarrow = size.width * 0.035;
    double paddingHorizontalWide = size.width * 0.0585;
    double padding5 = size.width * 0.0115;
    double padding10 = size.width * 0.023;

    // Single Field Validation
    String? validateField(String? value, String fieldName) {
      if (value == null || value.isEmpty) {
        return validationMessages[fieldName] = 'Field $fieldName wajib diisi!';
      }
      return null;
    }

    // Multiple Field Validation
    String? validateFieldIndex(String? value, String fieldName, int index) {
      if (value == null || value.isEmpty) {
        return errorMessages[index] = 'Field $fieldName wajib diisi!';
      }
      errorMessages.remove(index); // Clear error if input is valid
      return null;
    }

    Widget validateContainer(String? field) {
      return Padding(
        padding: const EdgeInsets.only(left: 25, top: 5),
        child: Text(
          validationMessages[field]!,
          style: TextStyle(color: Colors.red.shade900, fontSize: 12),
        ),
      );
    }

    Widget dropdownlistTripNumber() {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
        height: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.grey),
        ),
        child: DropdownButtonFormField<String>(
          validator: (value) {
            String? validationResult = validateField(value, 'Trip Number');
            setState(() {
              validationMessages['Trip Number'] = validationResult;
            });
            return null;
          },
          hint: const Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              'Pilih Trip Number',
              style: TextStyle(fontSize: 12),
            ),
          ),
          value: selectedValueTripNumber,
          icon: _isLoadingTripNumber
              ? const SizedBox(
                  height: 15,
                  width: 15,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                )
              : const Icon(Icons.arrow_drop_down),
          onChanged: (newValue) {
            if (!_isLoadingTripNumber && selectedTripNumber.isEmpty) return;
            setState(() {
              selectedValueTripNumber = newValue!;
              validationMessages['Trip Number'] = null;
              getDataTripNumber(selectedValueTripNumber!);
            });
          },
          items: selectedTripNumber.isNotEmpty
              ? selectedTripNumber.map((value) {
                  return DropdownMenuItem<String>(
                    value: value["trip_number"].toString(),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        value["trip_number"],
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  );
                }).toList()
              : [
                  const DropdownMenuItem(
                    value: "no-data",
                    enabled: false,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        'No Data Available',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  )
                ],
          decoration: InputDecoration(
            labelStyle: const TextStyle(fontSize: 12),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
                width: 1.0,
              ),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: selectedValueTripNumber != null
                    ? Colors.transparent
                    : Colors.transparent,
                width: 1.0,
              ),
            ),
          ),
        ),
      );
    }

    return _isLoading
        ? const Scaffold(body: Center(child: CircularProgressIndicator()))
        : Scaffold(
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
                'Laporan Aktivitas & Biaya Perjalanan Dinas',
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
                      // Trip Number
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: buildLabelRequired(title: 'Trip Number'),
                      ),
                      SizedBox(
                        height: sizedBoxHeightShort,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          dropdownlistTripNumber(),
                          if (validationMessages['Trip Number'] != null)
                            validateContainer('Trip Number'),
                        ],
                      ),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      // NRP
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: buildLabelRequired(title: 'NRP'),
                      ),
                      SizedBox(
                        height: sizedBoxHeightShort,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: TextFormField(
                          style: const TextStyle(fontSize: 12),
                          controller: _nrpController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            enabled: false,
                            hintText: 'NRP',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      // Nama
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: buildLabelRequired(title: 'Nama'),
                      ),
                      SizedBox(
                        height: sizedBoxHeightShort,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: TextFormField(
                          style: const TextStyle(fontSize: 12),
                          controller: _namaController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            enabled: false,
                            hintText: 'Nama',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      // Department
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: buildLabelRequired(title: 'Department'),
                      ),
                      SizedBox(
                        height: sizedBoxHeightShort,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: TextFormField(
                          style: const TextStyle(fontSize: 12),
                          controller: _departmentController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            enabled: false,
                            hintText: 'Department',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      // Perusahaan
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: buildLabelRequired(title: 'Perusahaan'),
                      ),
                      SizedBox(
                        height: sizedBoxHeightShort,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: TextFormField(
                          style: const TextStyle(fontSize: 12),
                          controller: _perusahaanController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            enabled: false,
                            hintText: 'Perusahaan',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      // Lokasi Dinas
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: buildLabelRequired(title: 'Lokasi Dinas'),
                      ),
                      SizedBox(
                        height: sizedBoxHeightShort,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: TextFormField(
                          style: const TextStyle(fontSize: 12),
                          controller: _lokasiDinasController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            enabled: false,
                            hintText: 'Lokasi Dinas',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      // Perihal
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: buildLabelRequired(title: 'Perihal'),
                      ),
                      SizedBox(
                        height: sizedBoxHeightShort,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: TextFormField(
                          style: const TextStyle(fontSize: 12),
                          controller: _perihalController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            enabled: false,
                            hintText: 'Perihal',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      // Tanggal Pengajuan Berangkat
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: buildLabelRequired(
                          title: 'Tanggal Pengajuan Berangkat',
                        ),
                      ),
                      CupertinoButton(
                        onPressed: null,
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
                                datePengajuanBerangkat == null ||
                                        timePengajuanBerangkat == null
                                    ? 'Tanggal Pengajuan Berangkat'
                                    : '${datePengajuanBerangkat!.day}-${datePengajuanBerangkat!.month}-${datePengajuanBerangkat!.year} ${timePengajuanBerangkat!.format(context)}',
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
                      ),
                      // Tanggal Pengajuan Pulang
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: buildLabelRequired(
                          title: 'Tanggal Pengajuan Pulang',
                        ),
                      ),
                      CupertinoButton(
                        onPressed: null,
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
                                datePengajuanPulang == null ||
                                        timePengajuanPulang == null
                                    ? 'Tanggal Pengajuan Pulang'
                                    : '${datePengajuanPulang!.day}-${datePengajuanPulang!.month}-${datePengajuanPulang!.year} ${timePengajuanPulang!.format(context)}',
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
                      ),
                      SizedBox(
                        height: sizedBoxHeightShort,
                      ),
                      // Lama Pengajuan Perjalanan Dinas
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: buildLabelRequired(
                          title: 'Lama Pengajuan Perjalanan Dinas',
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightShort,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: TextFormField(
                          style: const TextStyle(fontSize: 12),
                          controller: _lamaPengajuanController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            enabled: false,
                            hintText: 'Lama Pengajuan Perjalanan Dinas',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      // Tanggal Aktual Berangkat
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: buildLabelRequired(
                          title: 'Tanggal Aktual Berangkat',
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
                                '${selectedDateAktualBerangkat.day}-${selectedDateAktualBerangkat.month}-${selectedDateAktualBerangkat.year}-${selectedTimeAktualBerangkat.format(context)}',
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
                          _selectDateTimeAktualBerangkat(context);
                        },
                      ),
                      // Tanggal Aktual Pulang
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child:
                            buildLabelRequired(title: 'Tanggal Aktual Pulang'),
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
                                '${selectedDateAktualPulang.day}-${selectedDateAktualPulang.month}-${selectedDateAktualPulang.year}-${selectedTimeAktualPulang.format(context)}',
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
                          _selectDateTimeAktualPulang(context);
                        },
                      ),
                      SizedBox(
                        height: sizedBoxHeightShort,
                      ),
                      // Lama Aktual Perjalanan Dinas
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: buildLabelRequired(
                          title: 'Lama Aktual Perjalanan Dinas',
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightShort,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: TextFormField(
                          validator: (value) => validateField(
                              value, 'Lama Aktual Perjalanan Dinas'),
                          style: const TextStyle(fontSize: 12),
                          controller: _lamaAktualController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            enabled: false,
                            hintText: 'Lama Aktual Perjalanan Dinas',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      // Laporan Aktivitas Perjalanan Dinas
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow,
                            vertical: padding10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const LineWidget(),
                            SizedBox(
                              height: sizedBoxHeightTall,
                            ),
                            RowWithButtonWidget(
                              textLeft: 'Laporan Aktivitas Perjalanan Dinas',
                              textRight: 'Tambah +',
                              fontSizeLeft: textMedium,
                              fontSizeRight: textSmall,
                              onTab: () {
                                addActivity(
                                  reportType: activitiesReport,
                                );
                              },
                              isEnabled: selectedValueTripNumber != null,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightShort,
                      ),
                      SizedBox(
                        height: activitiesReport.isEmpty ? 0 : size.width * 1.1,
                        child: ListView.builder(
                            itemCount: activitiesReport.length,
                            itemBuilder: (context, index) {
                              Map<String, dynamic> activity =
                                  activitiesReport[index];
                              TextEditingController aktivitas =
                                  activity['aktivitas'];
                              TextEditingController hasilAktivitas =
                                  activity['hasilAktivitas'];
                              TextEditingController hambatan =
                                  activity['hambatan'];
                              TextEditingController tindakLanjut =
                                  activity['tindakLanjut'];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Tanggal
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: paddingHorizontalNarrow),
                                    child: buildLabelRequired(title: 'Tanggal'),
                                  ),
                                  CupertinoButton(
                                    child: Container(
                                      width: size.width,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: paddingHorizontalNarrow,
                                          vertical: padding5),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border:
                                              Border.all(color: Colors.grey)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Icon(
                                            Icons.calendar_month_outlined,
                                            color: Colors.grey,
                                          ),
                                          Text(
                                            DateFormat('dd-MM-yyyy').format(
                                                DateTime.parse(
                                                    activitiesReport[index]
                                                        ["tanggalAktivitas"])),
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
                                    onPressed: () => _selectDate(
                                      index: index,
                                      reportType: activitiesReport,
                                      keyField: 'tanggalAktivitas',
                                    ),
                                  ),
                                  // Aktivitas
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: paddingHorizontalNarrow),
                                    child:
                                        buildLabelRequired(title: 'Aktivitas'),
                                  ),
                                  SizedBox(
                                    height: sizedBoxHeightShort,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: paddingHorizontalNarrow),
                                    child: TextFormField(
                                      validator: (value) => validateFieldIndex(
                                          value, 'Aktivitas', index),
                                      style: const TextStyle(fontSize: 12),
                                      controller: aktivitas,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 10),
                                        hintText: '---',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: sizedBoxHeightTall,
                                  ),
                                  // Hasil Aktivitas
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: paddingHorizontalNarrow),
                                    child: buildLabelRequired(
                                      title: 'Hasil Aktivitas',
                                    ),
                                  ),
                                  SizedBox(
                                    height: sizedBoxHeightShort,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: paddingHorizontalNarrow),
                                    child: TextFormField(
                                      validator: (value) => validateFieldIndex(
                                          value, 'Hasil Aktivitas', index),
                                      style: const TextStyle(fontSize: 12),
                                      controller: hasilAktivitas,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 10),
                                        hintText: '---',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: sizedBoxHeightTall,
                                  ),
                                  // Hambatan (Problem Indentification)
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: paddingHorizontalNarrow),
                                    child: buildLabelRequired(
                                      title:
                                          'Hambatan (Problem Indentification)',
                                    ),
                                  ),
                                  SizedBox(
                                    height: sizedBoxHeightShort,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: paddingHorizontalNarrow),
                                    child: TextFormField(
                                      validator: (value) => validateFieldIndex(
                                          value,
                                          'Hambatan (Problem Indentification)',
                                          index),
                                      style: const TextStyle(fontSize: 12),
                                      controller: hambatan,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 10),
                                        hintText: '---',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: sizedBoxHeightTall,
                                  ),
                                  // Tindak Lanjut (Corrective Action)
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: paddingHorizontalNarrow),
                                    child: buildLabelRequired(
                                      title:
                                          'Tindak Lanjut (Corrective Action)',
                                    ),
                                  ),
                                  SizedBox(
                                    height: sizedBoxHeightShort,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: paddingHorizontalNarrow),
                                    child: TextFormField(
                                      validator: (value) => validateFieldIndex(
                                          value,
                                          'Tindak Lanjut (Corrective Action)',
                                          index),
                                      style: const TextStyle(fontSize: 12),
                                      controller: tindakLanjut,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 10),
                                        hintText: '---',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: sizedBoxHeightTall,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () => removeActivity(
                                            index: index,
                                            reportType: activitiesReport),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            }),
                      ),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalWide),
                        child: buildLabelRequired(title: 'Catatan'),
                      ),
                      SizedBox(
                        height: sizedBoxHeightShort,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: TextFormField(
                          validator: (value) => validateField(value, 'Catatan'),
                          style: const TextStyle(fontSize: 12),
                          controller: _catatanAktivitasController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            hintText: '---',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      // Laporan Biaya Perjalanan Dinas
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow,
                            vertical: padding10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const LineWidget(),
                            SizedBox(
                              height: sizedBoxHeightTall,
                            ),
                            RowWithButtonWidget(
                              textLeft: 'Laporan Biaya Perjalanan Dinas',
                              textRight: 'Tambah +',
                              fontSizeLeft: textMedium,
                              fontSizeRight: textSmall,
                              onTab: () {
                                addActivity(
                                  reportType: costReport,
                                );
                              },
                              isEnabled: selectedValueTripNumber != null,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightShort,
                      ),
                      SizedBox(
                        height: costReport.isEmpty ? 0 : size.width,
                        child: ListView.builder(
                            itemCount: costReport.length,
                            itemBuilder: (context, index) {
                              Map<String, dynamic> cost = costReport[index];
                              TextEditingController uraian = cost['uraian'];
                              TextEditingController nilai = cost['nilai'];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Tanggal
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: paddingHorizontalNarrow),
                                    child: buildLabelRequired(title: 'Tanggal'),
                                  ),
                                  CupertinoButton(
                                    child: Container(
                                      width: size.width,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: paddingHorizontalNarrow,
                                          vertical: padding5),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border:
                                              Border.all(color: Colors.grey)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Icon(
                                            Icons.calendar_month_outlined,
                                            color: Colors.grey,
                                          ),
                                          Text(
                                            DateFormat('dd-MM-yyyy').format(
                                                DateTime.parse(costReport[index]
                                                    ["tanggalBiaya"])),
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
                                    onPressed: () => _selectDate(
                                      index: index,
                                      reportType: costReport,
                                      keyField: 'tanggalBiaya',
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: paddingHorizontalNarrow),
                                    child:
                                        buildLabelRequired(title: 'Kategori'),
                                  ),
                                  SizedBox(
                                    height: sizedBoxHeightShort,
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: paddingHorizontalNarrow),
                                    height: 45,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(color: Colors.grey),
                                    ),
                                    child: DropdownButtonFormField<String>(
                                      hint: const Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Text(
                                          'Pilih Kategori',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ),
                                      value: selectedValueKategori[index],
                                      icon: selectedKategori.isEmpty
                                          ? const SizedBox(
                                              height: 15,
                                              width: 15,
                                              child: CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(Colors.blue),
                                              ),
                                            )
                                          : const Icon(Icons.arrow_drop_down),
                                      onChanged: (newValue) {
                                        setState(() {
                                          selectedValueKategori[index] =
                                              newValue!;
                                        });
                                      },
                                      items: selectedKategori.map((value) {
                                        return DropdownMenuItem<String>(
                                          value: value["kode_cost"] +
                                              ' - ' +
                                              value["deskripsi"],
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Text(
                                              value["deskripsi"],
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      decoration: InputDecoration(
                                        labelStyle:
                                            const TextStyle(fontSize: 12),
                                        focusedBorder:
                                            const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.transparent,
                                            width: 1.0,
                                          ),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color:
                                                selectedValueTripNumber != null
                                                    ? Colors.transparent
                                                    : Colors.transparent,
                                            width: 1.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: sizedBoxHeightTall,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: paddingHorizontalNarrow),
                                    child: buildLabelRequired(title: 'Uraian'),
                                  ),
                                  SizedBox(
                                    height: sizedBoxHeightShort,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: paddingHorizontalNarrow),
                                    child: TextFormField(
                                      validator: (value) => validateFieldIndex(
                                          value, 'Uraian', index),
                                      style: const TextStyle(fontSize: 12),
                                      controller: uraian,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 10),
                                        hintText: '---',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: sizedBoxHeightTall,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: paddingHorizontalNarrow),
                                    child: buildLabelRequired(title: 'Nilai'),
                                  ),
                                  SizedBox(
                                    height: sizedBoxHeightShort,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: paddingHorizontalNarrow),
                                    child: TextFormField(
                                      validator: (value) => validateFieldIndex(
                                          value, 'Nilai', index),
                                      style: const TextStyle(fontSize: 12),
                                      controller: nilai,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 10),
                                        hintText: '---',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'^[0-9]*$'))
                                      ],
                                      onChanged: (String value) {
                                        debounceCalculation(
                                            calculateFinancials);
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: sizedBoxHeightTall,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: paddingHorizontalNarrow),
                                    child: Row(
                                      children: [
                                        buildLabelRequired(
                                          title: 'Lampiran',
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: sizedBoxHeightShort,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: paddingHorizontalNarrow),
                                    child: Column(
                                      children: [
                                        Center(
                                          child: ElevatedButton(
                                            onPressed: () => pickFiles(
                                                index: index,
                                                reportType: costReport),
                                            child: const Text('Pilih File'),
                                          ),
                                        ),
                                        if (costReport[index]['files'] != null)
                                          Column(
                                            children: (costReport[index]
                                                        ['files']
                                                    as List<PlatformFile>)
                                                .map((file) {
                                              return ListTile(
                                                title: Text(file.name),
                                              );
                                            }).toList(),
                                          ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: sizedBoxHeightTall,
                                  ),
                                  _isFileNull
                                      ? Center(
                                          child: Text(
                                          'File Kosong',
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.w500,
                                              fontSize: textMedium),
                                        ))
                                      : const Text(''),
                                  SizedBox(
                                    height: sizedBoxHeightTall,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () => removeActivity(
                                            index: index,
                                            reportType: costReport),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            }),
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
                                  child: buildLabelRequired(
                                    title: 'Jumlah Kas Diterima',
                                  ),
                                ),
                                SizedBox(
                                  height: sizedBoxHeightShort,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: paddingHorizontalNarrow),
                                  child: TextFormField(
                                    style: const TextStyle(fontSize: 12),
                                    controller: _jumlahKasDiterimaController,
                                    enabled: false,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 10),
                                      hintText: '---',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
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
                                  child: buildLabelRequired(
                                    title: 'Jumlah Pengeluaran',
                                  ),
                                ),
                                SizedBox(
                                  height: sizedBoxHeightShort,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: paddingHorizontalNarrow),
                                  child: TextFormField(
                                    style: const TextStyle(fontSize: 12),
                                    controller: _jumlahPengeluaranController,
                                    enabled: false,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 10),
                                      hintText: '---',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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
                                  child: buildLabelRequired(
                                      title: 'Kelebihan Kas'),
                                ),
                                SizedBox(
                                  height: sizedBoxHeightShort,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: paddingHorizontalNarrow),
                                  child: TextFormField(
                                    style: const TextStyle(fontSize: 12),
                                    controller: _kelebihanKasController,
                                    enabled: false,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 10),
                                      hintText: '---',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
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
                                  child: buildLabelRequired(
                                    title: 'Kekurangan Kas',
                                  ),
                                ),
                                SizedBox(
                                  height: sizedBoxHeightShort,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: paddingHorizontalNarrow),
                                  child: TextFormField(
                                    style: const TextStyle(fontSize: 12),
                                    controller: _kekuranganKasController,
                                    enabled: false,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 10),
                                      hintText: '---',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
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
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalWide),
                        child: buildLabelRequired(title: 'Catatan'),
                      ),
                      SizedBox(
                        height: sizedBoxHeightShort,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: TextFormField(
                          validator: (value) => validateField(value, 'Catatan'),
                          style: const TextStyle(fontSize: 12),
                          controller: _catatanBiayaController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            hintText: '---',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      SizedBox(
                        width: size.width,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow,
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              _submit();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(primaryYellow),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Submit',
                              style: TextStyle(
                                  color: const Color(primaryBlack),
                                  fontSize: textMedium,
                                  fontFamily: 'Poppins',
                                  letterSpacing: 0.9,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
              ],
            ));
  }

  Widget buildLabelRequired({required String title}) {
    Size size = MediaQuery.of(context).size;
    double textSmall = size.width * 0.027;
    double textMedium = size.width * 0.0329;

    return Row(
      children: [
        TitleWidget(
          title: title,
          fontWeight: FontWeight.w300,
          fontSize: textMedium,
        ),
        Text(
          ' * ',
          textAlign: TextAlign.start,
          style: TextStyle(
              color: Colors.red,
              fontSize: textSmall,
              fontFamily: 'Poppins',
              letterSpacing: 0.6,
              fontWeight: FontWeight.w300),
        )
      ],
    );
  }
}
