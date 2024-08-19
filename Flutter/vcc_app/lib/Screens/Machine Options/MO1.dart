import 'package:flutter/material.dart';
// Assuming Header1 and Header2 are defined in 'MenuScreen.dart'
import 'package:vcc_app/Screens/HomePage/MenuScreen.dart';
import 'package:vcc_app/Screens/Monitoring%20Page/monitoring1.dart';
import 'package:vcc_app/Screens/Monitoring%20Page/monitoring2.dart';
import 'package:vcc_app/main.dart';

class Machineoptions1 extends StatelessWidget {
  const Machineoptions1({super.key});

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
              SizedBox(height: 8),
              Header2(
                text: '',
              ),
              SizedBox(height: 12),
              Expanded(
                child: OptionsPanel(), // Embedding OptionsPanel here
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OptionsPanel extends StatelessWidget {
  const OptionsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    void _handleTileTap(String text) {
      // Handle tile tap
      if (text == 'VCC Setup') {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ResponsiveWrapper(
                    child: Monitoring1(),
                  )),
        );
      } else if (text == 'Melting Furnace') {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ResponsiveWrapper(child: Monitoring2())),
        );
      } else {
        print('object');
      }
    }

    final List<Map<String, dynamic>> options = [
      {'text': 'VCC Setup', 'color': Colors.lightBlue},
      {'text': 'Melting Furnace', 'color': Colors.cyan},
      {'text': 'Heating Furnace', 'color': Colors.cyan},
      {'text': 'Environment Module', 'color': Colors.lightBlue},
      {'text': 'Vertical Centrifugal Casting', 'color': Colors.lightBlue},
      {'text': 'Sand Casting', 'color': Colors.cyan},
      {'text': 'Jewellery Casting', 'color': Colors.cyan},
      {'text': 'Investment Casting', 'color': Colors.lightBlue},
    ];

    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: 1.0,
            ),
            itemCount: options.length,
            itemBuilder: (context, index) {
              final option = options[index];
              return CustomTile(
                text: option['text'],
                color: option['color'],
                onTap: () => _handleTileTap(option['text']),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Back',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

class CustomTile extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onTap;

  CustomTile({
    required this.text,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
