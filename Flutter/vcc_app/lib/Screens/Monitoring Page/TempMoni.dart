import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:vcc_app/Screens/HomePage/MenuScreen.dart';
import 'package:vcc_app/global.dart';

class TemperaturePage extends StatefulWidget {
  const TemperaturePage({super.key});

  @override
  State<TemperaturePage> createState() => _TemperaturePageState();
}

class _TemperaturePageState extends State<TemperaturePage> {
  Timer? timer;
  String temperature = 'Fetching...';

  @override
  void initState() {
    super.initState();
    startFetchingTemperature();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startFetchingTemperature() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) async {
      try {
        final response = await http.post(
            Uri.parse('${URL_DataSource}/temperature'));
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          print(data);
          setState(() {
            temperature = data['temperature'].toString();
          });
        } else {
          setState(() {
            temperature = "Something Went Wrong!";
          });
        }
      } catch (e) {
        setState(() {
          temperature = "Error: $e";
        });
      }
    });
  }

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
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Temperature',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          temperature,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
