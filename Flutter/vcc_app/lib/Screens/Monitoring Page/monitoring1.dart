import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:core';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vcc_app/Screens/HomePage/MenuScreen.dart';
import 'package:vcc_app/global.dart';


class Monitoring1 extends StatelessWidget {
  const Monitoring1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.grey,
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Header1(
                text: 'Process Monitoring',
              ),
              SizedBox(
                height: 8,
              ),
              Header2(
                text: 'VCC SetUp',
              ),
              SizedBox(
                height: 12,
              ),
              Expanded(
                child: MonitoringSection(),
              ),
              SizedBox(
                height: 12,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      padding: EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 32.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Back',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MonitoringSection extends StatefulWidget {
  const MonitoringSection({super.key});

  @override
  State<MonitoringSection> createState() => _MonitoringSectionState();
}

class _MonitoringSectionState extends State<MonitoringSection> {
  bool isReady = false;
  bool isOn = false;
  int rpmLevel = 0; // -1 indicates no RPM selected initially
  int powerConsumption = 0;
  int rotation = -1;
  Timer? timer;
  Random random = Random();
  String name = "";

  final List<int> buttonLabels = [
    700, 750, 800, 850, 900, 950, 1000, 1050,
  ];

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    print(' -------- Fetching Data -------');
    setState(() {
      isReady = false; // Show loading state
    });
    try {
      final response = await http.post(Uri.parse('${URL_DataSource}/info'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('-------- Got the data: ${data} -----');
        setState(() {
          isOn = data['machineStatus'];
          rpmLevel = data['rpmLevel'];
          rotation = data['rotation'];
          if (isOn) {
            startPowerConsumption(); // Start power consumption updates if the machine is on
          }
        });
      } else {
        Fluttertoast.showToast(msg: 'Failed to load data');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e');
    }
    setState(() {
      isReady = true;
    });
  }

  void toggleMachineStatus() async {
    if (!isOn && rpmLevel == 0) {
      Fluttertoast.showToast(msg: 'Select RPM Level!');
      return;
    }
    if (rotation == -1) {
      Fluttertoast.showToast(msg: 'Select the Rotation!');
      return;
    }
    setState(() {
      isReady = false; // Show loading state
    });
    try {
      late http.Response response;
      if (isOn) {
        response = await http.post(
          Uri.parse('${URL_DataSource}/setstatus?status=false'),
        );
        resetParameters();
      } else {
        response = await http.post(
          Uri.parse('${URL_DataSource}/setstatus?status=true&rpm=$rpmLevel&rotation=$rotation'),
        );
        startPowerConsumption();
      }
      if (response.statusCode == 200) {
        setState(() {
          isOn = !isOn;
        });
      } else {
        Fluttertoast.showToast(msg: 'Status code: ${jsonDecode(response.body)}');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error while starting/stopping machine');
      print("Error while starting/stopping machine: $e");
    }
    setState(() {
      isReady = true; // Hide loading state
    });
  }

  void startPowerConsumption() {
    timer?.cancel();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        powerConsumption = rpmLevel + random.nextInt(100);
      });
    });
  }



  void resetParameters() {
    timer?.cancel();
    setState(() {
      rpmLevel = 0;
      powerConsumption = 0;
      rotation = -1;
    });
  }

  void setRotation(int r)async {
    if (!isOn) {
      setState(() {
        rotation = r;
      });
      return;
    }

    setState(() {
      isReady = false; // Show loading state
    });
    try {
      final response = await http.post(Uri.parse('${URL_DataSource}/setrotation?rotation=$r'));
      if (response.statusCode == 200) {
        setState(() {
          rotation = r;
          Fluttertoast.showToast(msg: 'Successfully changed Rotation to ${r == 1 ? "Clock Wise":"Anti-clock Wise"}');
        });
      } else {
        Fluttertoast.showToast(msg: 'Something went wrong');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error while setting Rotation');
      print("Error while setting Rotation: $e");
    }
    setState(() {
      isReady = true; // Hide loading state
    });

  }


  void setRpmLevel(int level) async {
    if (!isOn) {
      setState(() {
        rpmLevel = level;
      });
      return;
    }

    setState(() {
      isReady = false; // Show loading state
    });
    try {
      final response = await http.post(Uri.parse('${URL_DataSource}/setrpm?rpm=$level'));
      if (response.statusCode == 200) {
        setState(() {
          rpmLevel = level;
          Fluttertoast.showToast(msg: 'Successfully changed to $rpmLevel');
        });
      } else {
        Fluttertoast.showToast(msg: 'Something went wrong');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error while setting RPM');
      print("Error while setting RPM: $e");
    }
    setState(() {
      isReady = true; // Hide loading state
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Opacity(
          opacity: isReady ? 1.0 : 0.5,
          child: AbsorbPointer(
            absorbing: !isReady,
            child: Center(
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Status',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: toggleMachineStatus,
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isOn ? Colors.green : Colors.red,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  isOn ? 'On' : 'Off',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      Text(
                        'Set RPM Level',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12),
                      GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                          childAspectRatio: 2,
                        ),
                        itemCount: buttonLabels.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setRpmLevel(buttonLabels[index]);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: buttonLabels[index] == rpmLevel
                                    ? Colors.green
                                    : Colors.blue,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  buttonLabels[index].toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 12,),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.blue[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Set Rotation',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setRotation(1);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: rotation == 1 ? Colors.green[300] : Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Image.network(
                                      'https://cdn1.iconfinder.com/data/icons/unigrid-bluetone-symbols-arrows-vol-1/60/024_044_rotate_clockwise_arrow_circle-1024.png',
                                      height: 30,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8), // Add some spacing between the buttons
                                GestureDetector(
                                  onTap: () {
                                    setRotation(2);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: rotation == 2 ? Colors.green[300] : Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Image.network(
                                      'https://cdn0.iconfinder.com/data/icons/audio-visual-material-design-icons/512/replay-512.png',
                                      height: 30,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Power Consumption',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.blue[600],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                powerConsumption.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        if (!isReady)
          Center(
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }
}

