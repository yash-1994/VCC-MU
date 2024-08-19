// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:charts_flutter/flutter.dart' as charts;
// import 'package:vcc_app/global.dart';
//
//
// class VCCSetup extends StatefulWidget {
//   @override
//   _VCCSetupState createState() => _VCCSetupState();
// }
//
// class _VCCSetupState extends State<VCCSetup> {
//   late bool isMachineOn;
//   int rpm = 500;
//   TextEditingController txtRpmController = TextEditingController();
//   List<String> rpmXData = [];
//   List<charts.Series<TimeSeriesData, int>> rpmSeries = [];
//   List<String> pwrXData = [];
//   List<charts.Series<TimeSeriesData, int>> pwrSeries = [];
//
//   @override
//   void initState() {
//     super.initState();
//     // Initialize data fetching
//     checkMachineInfo();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('VCC Setup')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Card(
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('Machine Status'),
//                     ElevatedButton(
//                       onPressed: toggleMachineStatus,
//                       child: Text(isMachineOn ? 'ON' : 'OFF'),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: isMachineOn ? Colors.green : Colors.red,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(height: 16.0),
//             Card(
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('Set RPM'),
//                     Row(
//                       children: [
//                         IconButton(
//                           icon: Icon(Icons.remove),
//                           onPressed: decreaseRPM,
//                         ),
//                         Expanded(
//                           child: TextField(
//                             controller: txtRpmController,
//                             keyboardType: TextInputType.number,
//                             decoration: InputDecoration(
//                               labelText: 'RPM',
//                             ),
//                             onChanged: (value) {
//                               if (value.isNotEmpty) {
//                                 int rpmValue = int.parse(value);
//                                 if (rpmValue < 1) {
//                                   txtRpmController.text = '1';
//                                 } else if (rpmValue > 999) {
//                                   txtRpmController.text = '999';
//                                 }
//                                 // Update RPM on machine if it's ON
//                                 if (isMachineOn) {
//                                   setMachineRPM(txtRpmController.text);
//                                 }
//                               }
//                             },
//                           ),
//                         ),
//                         IconButton(
//                           icon: Icon(Icons.add),
//                           onPressed: increaseRPM,
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(height: 16.0),
//             // RPM Graph
//             Expanded(
//               child: charts.LineChart(
//                 rpmSeries,
//                 animate: true,
//                 behaviors: [
//                   charts.SeriesLegend(),
//                 ],
//                 domainAxis: charts.NumericAxisSpec(
//                   tickProviderSpec: charts.BasicNumericTickProviderSpec(
//                     desiredTickCount: 5,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Method to toggle machine status
//   void toggleMachineStatus() {
//     setState(() {
//       isMachineOn = !isMachineOn;
//       if (isMachineOn) {
//        // setMachineStatus("1");
//         pri('-------- MACHINE STATUS 1');
//         setMachineRPM(rpm);
//       } else {
//         pri("--------- MAHINE STATUS 0");
//        // setMachineStatus("0");
//       }
//     });
//   }
//
//   // Method to set RPM on machine
//
//
//   // Method to increase RPM
//   void increaseRPM() {
//     int currentRPM = int.parse(txtRpmController.text);
//     if (currentRPM < 999) {
//       txtRpmController.text = (currentRPM + 5).toString();
//       setMachineRPM(txtRpmController.text);
//     } else {
//       txtRpmController.text = '999';
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Maximum RPM is 999')),
//       );
//     }
//   }
//
//   // Method to decrease RPM
//   void decreaseRPM() {
//     int currentRPM = int.parse(txtRpmController.text);
//     if (currentRPM > 1) {
//       txtRpmController.text = (currentRPM - 5).toString();
//       setMachineRPM(txtRpmController.text);
//     } else {
//       txtRpmController.text = '1';
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Minimum RPM is 1')),
//       );
//     }
//   }
//
//   // Method to check machine information
//   void checkMachineInfo() {
//     // Implement your HTTP requests here to get machine status, RPM, and power consumption
//     // For brevity, I'll omit the implementation of HTTP requests in this example
//   }
// }
//
// // Data model for time series data
// class TimeSeriesData {
//   final String time;
//   final int value;
//
//   TimeSeriesData(this.time, this.value);
// }
