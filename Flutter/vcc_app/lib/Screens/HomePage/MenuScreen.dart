import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vcc_app/Screens/Machine%20Options/MO1.dart';
import 'package:vcc_app/main.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.grey,
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              Header1(
                text: '',
              ),
              SizedBox(
                height: 8,
              ),
              Header2(
                text: '',
              ),
              SizedBox(
                height: 12,
              ),
              OptionsSection()
            ],
          ),
        ),
      ),
    );
  }
}

class Header1 extends StatelessWidget {
  final String text;
  const Header1({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Image.asset(
            "assets/images/m_logo.jpg",
          ),
          Container(
            child: Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  text,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class Header2 extends StatelessWidget {
  final String text;

  const Header2({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.green, borderRadius: BorderRadius.circular(12)),
      child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "SMART Foundry 2020",
              style: TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              text,
              style: TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ]),
    );
  }
}

class OptionsPanel extends StatelessWidget {
  final Map<Object, Object> obj;

  const OptionsPanel({super.key, required this.obj});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      padding: EdgeInsets.only(left: 12, right: 6),
      decoration: BoxDecoration(
          color: obj[Color] as Color, borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    obj['title'] as String,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    obj['desc'] as String,
                    style: TextStyle(fontSize: 8, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          Image.asset(
            obj['icon'] as String,
            height: 120,
          )
        ],
      ),
    );
  }
}

class OptionsSection extends StatelessWidget {
  const OptionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    void _handleNext() {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ResponsiveWrapper(
                  child: Machineoptions1(),
                )),
      );
    }

    var options = [
      {
        'title': 'Process Monitoring',
        'desc':
            "Aute sit ad sit in occaecat sint.Ad quis amet est eu aute mollit minim excepteur voluptate.",
        'icon': 'assets/images/process_monitoring_logo.png',
        Color: Colors.amber
      },
      {
        'title': ' Data Monotoring',
        'desc':
            "Aute sit ad sit in occaecat sint.Ad quis amet est eu aute mollit minim excepteur voluptate.",
        'icon': 'assets/images/process_monitoring_logo.png',
        Color: Colors.orange
      },
      {
        'title': 'Process Monitoring',
        'desc':
            "Aute sit ad sit in occaecat sint.Ad quis amet est eu aute mollit minim excepteur voluptate.",
        'icon': 'assets/images/process_monitoring_logo.png',
        Color: Colors.green
      },
      {
        'title': ' Data Monotoring',
        'desc':
            "Aute sit ad sit in occaecat sint.Ad quis amet est eu aute mollit minim excepteur voluptate.",
        'icon': 'assets/images/process_monitoring_logo.png',
        Color: Colors.red
      },
    ];

    return Container(
      child: Expanded(
        child: SingleChildScrollView(
          child: Column(
              mainAxisSize: MainAxisSize.max,
              children: options.map((op) {
                return GestureDetector(
                    onTap: () => _handleNext(), child: OptionsPanel(obj: op));
              }).toList()),
        ),
      ),
    );
  }
}
