import 'package:flutter/material.dart';
import 'package:mobile_ess/widgets/title_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DemografiAttendanceScreen extends StatefulWidget {
  @override
  State<DemografiAttendanceScreen> createState() =>
      _DemografiAttendanceScreenState();
}

class _DemografiAttendanceScreenState extends State<DemografiAttendanceScreen> {
  final List<EmployeeData> chartData = [
    EmployeeData('Permanen', 350),
    EmployeeData('Kontrak', 300),
    EmployeeData('Outsource', 150),
    EmployeeData('KHL/KHT', 200),
  ];

  final List<AttendanceData> chartData2 = [
    AttendanceData('Normal', 400),
    AttendanceData('Terlambat', 200),
  ];
  // ========================================================
  Map<String, String> entitasValues = {
    '1': 'Entitas',
  };
  String? entitasValue = '1'; // Default value
  // ========================================================
  Map<String, String> lokasiValues = {
    '1': 'Lokasi Kerja',
  };
  String? lokasiValue = '1'; // Default value
  // ========================================================
  Map<String, String> periodeValues = {
    '1': 'Periode',
  };
  String? periodeValue = '1'; // Default value
  String lokasiKerja = 'Lokasi Kerja';
  String periode = 'Periode';
  String pangkat = '';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double paddingHorizontalWide = size.width * 0.0585;
    double padding10 = size.width * 0.023;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: paddingHorizontalWide),
          child: const TitleWidget(title: 'Demografi & Attendance'),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: paddingHorizontalWide, vertical: padding10),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 40,
                  padding: EdgeInsets.all(4),
                  margin: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color:
                          Color.fromARGB(102, 158, 158, 158), // Set border color
                      width: 1, // Set border width
                    ),
                    borderRadius: BorderRadius.circular(
                        6), // BorderRadius -> .circular(12),all(10),only(topRight:Radius.circular(10)), vertical,horizontal
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 5, right: 5),
                    child: DropdownButton<String>(
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors
                            .black, // Set the font size for the dropdown items
                      ),
                      value: entitasValue,
                      iconSize: 24,
                      elevation: 16,
                      onChanged: (String? newValue) {
                        setState(() {
                          entitasValue = newValue;
                        });
                      },
                      items: entitasValues.keys
                          .map<DropdownMenuItem<String>>((String id) {
                        return DropdownMenuItem<String>(
                          value: id,
                          child: Text(entitasValues[id]!),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Container(
                  height: 40,
                  padding: EdgeInsets.all(4),
                  margin: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color:
                          Color.fromARGB(102, 158, 158, 158), // Set border color
                      width: 1, // Set border width
                    ),
                    borderRadius: BorderRadius.circular(
                        6), // BorderRadius -> .circular(12),all(10),only(topRight:Radius.circular(10)), vertical,horizontal
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 5, right: 5),
                    child: DropdownButton<String>(
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors
                            .black, // Set the font size for the dropdown items
                      ),
                      value: lokasiValue,
                      iconSize: 24,
                      elevation: 16,
                      onChanged: (String? newValue) {
                        setState(() {
                          lokasiValue = newValue;
                        });
                      },
                      items: lokasiValues.keys
                          .map<DropdownMenuItem<String>>((String id) {
                        return DropdownMenuItem<String>(
                          value: id,
                          child: Text(lokasiValues[id]!),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Container(
                  height: 40,
                  padding: EdgeInsets.all(4),
                  margin: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color:
                          Color.fromARGB(102, 158, 158, 158), // Set border color
                      width: 1, // Set border width
                    ),
                    borderRadius: BorderRadius.circular(
                        6), // BorderRadius -> .circular(12),all(10),only(topRight:Radius.circular(10)), vertical,horizontal
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 5, right: 5),
                    child: DropdownButton<String>(
                      value: periodeValue,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors
                            .black, // Set the font size for the dropdown items
                      ),
                      iconSize: 24,
                      elevation: 16,
                      onChanged: (String? newValue) {
                        setState(() {
                          periodeValue = newValue;
                        });
                      },
                      items: periodeValues.keys
                          .map<DropdownMenuItem<String>>((String id) {
                        return DropdownMenuItem<String>(
                          value: id,
                          child: Text(periodeValues[id]!),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Container(
              height: 40,
              width: 100,
              padding: EdgeInsets.all(4),
              margin: EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                border: Border.all(
                  color:
                      Color.fromARGB(102, 158, 158, 158), // Set border color
                  width: 1, // Set border width
                ),
                borderRadius: BorderRadius.circular(
                    6), // BorderRadius -> .circular(12),all(10),only(topRight:Radius.circular(10)), vertical,horizontal
              ),
              child: TextFormField(
                style: TextStyle(
                  fontSize: 12
                ),
                decoration: const InputDecoration(
                  hintText: 'Pangkat', // placeholder
                ),
                // onChanged: (val)=>vdata['Username']=val, // pilih salah satu
              ),
            ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: paddingHorizontalWide, vertical: padding10),
          child: Container(
            padding: const EdgeInsets.all(12.0), // Adjust the padding as needed
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: SfCartesianChart(
                title: ChartTitle(
                  text: 'Jumlah Karyawan',
                ),
                legend: Legend(isVisible: false),
                series: <ChartSeries>[
                  ColumnSeries<EmployeeData, String>(
                    color: Colors.amber,
                    gradient: const LinearGradient(
                      colors: [Colors.yellow, Colors.amber],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    width: 0.4,
                    dataSource: chartData,
                    xValueMapper: (EmployeeData data, _) => data.category,
                    yValueMapper: (EmployeeData data, _) => data.count,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8)),
                  )
                ],
                primaryXAxis: CategoryAxis(),
                primaryYAxis: NumericAxis(),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        // ===================================================
        Padding(
          padding: EdgeInsets.symmetric(horizontal: paddingHorizontalWide),
          child: Container(
            padding: EdgeInsets.all(12.0), // Adjust the padding as needed
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: SfCircularChart(
                title: ChartTitle(text: 'Kehadiran Karyawan'),
                legend: Legend(
                  isVisible: true,
                  position: LegendPosition.bottom,
                  overflowMode: LegendItemOverflowMode.wrap,
                ),
                series: <CircularSeries>[
                  DoughnutSeries<AttendanceData, String>(
                    dataSource: chartData2,
                    xValueMapper: (AttendanceData data, _) => data.category,
                    yValueMapper: (AttendanceData data, _) => data.count,
                    pointColorMapper: (AttendanceData data, _) {
                      if (data.category == 'Normal') {
                        return Colors
                            .amber; // Use the appropriate color for light blue
                      } else if (data.category == 'Terlambat') {
                        return Colors
                            .grey; // Use the appropriate color for navy blue
                      } else {
                        // Default color for other categories
                        return Colors.grey;
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ),

        SizedBox(
          height: 20,
        ),
        // =====================
        Padding(
          padding: EdgeInsets.symmetric(horizontal: paddingHorizontalWide),
          child: Container(
            padding: EdgeInsets.all(12.0), // Adjust the padding as needed
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(
                  // Configure the axis label to rotate at 45 degrees
                  labelIntersectAction: AxisLabelIntersectAction.rotate45,
                ),
                title: ChartTitle(
                    text: 'Total Biaya Rawat Jalan (In Million Rupiah)'),
                legend: Legend(
                  isVisible: true,
                  position: LegendPosition.bottom,
                ),
                series: <ChartSeries>[
                  ColumnSeries<ChartData, String>(
                    name: 'Rawat Jalan',
                    dataSource: [
                      ChartData('President Director', 45),
                      ChartData('Deputy Director', 40),
                      ChartData('Senior Manager', 35),
                      ChartData('Manager', 30),
                      ChartData('Assistant Manager', 25),
                      ChartData('Supervisor', 20),
                      ChartData('Officer', 15),
                      ChartData('Non Officer', 5),
                    ],
                    xValueMapper: (ChartData data, _) {
                      // Split the label by space and insert line breaks
                      return data.x.split(' ').join('\n');
                    },
                    yValueMapper: (ChartData data, _) => data.y,
                    color: Colors.blue[900],
                  ),
                  ColumnSeries<ChartData, String>(
                    name: 'Bingkai Kacamata',
                    dataSource: [
                      ChartData('President Director', 40),
                      ChartData('Deputy Director', 35),
                      ChartData('Senior Manager', 30),
                      ChartData('Manager', 25),
                      ChartData('Assistant Manager', 20),
                      ChartData('Supervisor', 15),
                      ChartData('Officer', 10),
                      ChartData('Non Officer', 5),
                    ],
                    xValueMapper: (ChartData data, _) {
                      // Split the label by space and insert line breaks
                      return data.x.split(' ').join('\n');
                    },
                    yValueMapper: (ChartData data, _) => data.y,
                    color: Colors.blue[600],
                  ),
                  ColumnSeries<ChartData, String>(
                    name: 'Lensa Kacamata',
                    dataSource: [
                      ChartData('President Director', 35),
                      ChartData('Deputy Director', 30),
                      ChartData('Senior Manager', 25),
                      ChartData('Manager', 20),
                      ChartData('Assistant Manager', 15),
                      ChartData('Supervisor', 10),
                      ChartData('Officer', 5),
                      ChartData('Non Officer', 0),
                    ],
                    xValueMapper: (ChartData data, _) {
                      // Split the label by space and insert line breaks
                      return data.x.split(' ').join('\n');
                    },
                    yValueMapper: (ChartData data, _) => data.y,
                    color: Colors.blue[300],
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        // ==================================
        Padding(
          padding: EdgeInsets.symmetric(horizontal: paddingHorizontalWide),
          child: Container(
            padding: EdgeInsets.all(12.0), // Adjust the padding as needed
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(
                    labelIntersectAction: AxisLabelIntersectAction.multipleRows,
                    labelRotation: -45,
                    labelStyle:
                        TextStyle(fontSize: 8), // Adjust font size as needed
                  ),
                  title: ChartTitle(
                      text: 'Total Biaya Rawat Jalan (In Million Rupiah)'),
                  legend: Legend(
                    isVisible: true,
                    position: LegendPosition.bottom,
                  ),
                  series: <ChartSeries>[
                    ColumnSeries<ChartData, String>(
                      name: 'Rawat Jalan',
                      dataSource: [
                        ChartData('President Director', 45),
                        ChartData('Deputy Director', 42),
                        ChartData('Senior Manager', 35),
                        ChartData('Manager', 30),
                        ChartData('Assistant Manager', 25),
                        ChartData('Supervisor', 20),
                        ChartData('Officer', 15),
                        ChartData('Non Officer', 8),
                      ],
                      xValueMapper: (ChartData data, _) {
                        // Split the label by space and insert line breaks
                        return data.x.split(' ').join('\n');
                      },
                      yValueMapper: (ChartData data, _) => data.y,
                    ),
                  ],
                )),
          ),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}

class EmployeeData {
  final String category;
  final int count;

  EmployeeData(this.category, this.count);
}

class ChartData {
  final String x;
  final double y;

  ChartData(this.x, this.y);
}

class AttendanceData {
  final String category;
  final int count;

  AttendanceData(this.category, this.count);
}
