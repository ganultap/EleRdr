import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ElectricityCalculator extends StatefulWidget {
  const ElectricityCalculator({Key? key}) : super(key: key);

  @override
  _ElectricityCalculatorState createState() => _ElectricityCalculatorState();
}

class _ElectricityCalculatorState extends State<ElectricityCalculator> {
  List<TextEditingController> text = [];
  final ScrollController _sc = ScrollController();

  @override
  initState() {
    super.initState();
    setState(() {
      for (int i = 0; i < 10; i++) {
        text.add(TextEditingController());
        text[i].text = '0';
      }
    });
  }

  calculate() {
    double watt = double.parse(text[0].text);
    double kwhrate = double.parse(text[2].text);
    double hoursused = double.parse(text[1].text);

    double result = (watt / 1000) * kwhrate * hoursused;
    setState(() {
      text[3].text = result.toStringAsFixed(2);
    });
  }

  reset() {
    setState(() {
      for (int i = 0; i < 10; i++) {
        text[i].text = '0';
      }
    });
  }

  Widget _textField(index, type) {
    return TextField(
      keyboardType: type,
      controller: text[index],
      decoration: InputDecoration(
        fillColor: Colors.pink[50],
        filled: true,
        border: OutlineInputBorder(borderSide: BorderSide(width: 1)),
      ),
      textAlign: TextAlign.right,
      style: TextStyle(fontSize: 25),
    );
  }

  Widget _resulTextField(index, type) {
    return TextField(
      keyboardType: type,
      controller: text[index],
      readOnly: true,
      decoration: InputDecoration(
        fillColor: Colors.pink[50],
        filled: true,
        border: OutlineInputBorder(borderSide: BorderSide(width: 1)),
      ),
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 25),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return AlertDialog(
        content: SingleChildScrollView(
      controller: _sc,
      child: Container(
        padding: EdgeInsets.all(10),
        // height: size.height*.4,
        child: Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                'Enter the Following',
                style: TextStyle(fontSize: 25),
                textAlign: TextAlign.center,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                'Requirements:',
                style: TextStyle(fontSize: 25),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: size.height * .18,
                    child: Text(
                      'Watts (appliance):',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(
                    width: size.height * .10,
                    child: Center(
                      child: _textField(0, TextInputType.number),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: size.height * .18,
                    child: Text(
                      'Time (hours used):',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(
                    width: size.height * .10,
                    child: Center(
                      child: _textField(1, TextInputType.number),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: size.height * .18,
                    child: Text(
                      'KhW rate:',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(
                    width: size.height * .10,
                    child: Center(
                      child: _textField(2, TextInputType.number),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 18,
            ),
            SizedBox(
              width: size.height * .30,
              child: Text(
                'Result in Php',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              width: size.height * .30,
              child: Center(
                child: _resulTextField(3, TextInputType.number),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                    style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all(
                            Size(size.width * .30, 45)),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.pink[50]),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(1)))),
                    onPressed: () => reset(),
                    child: Text(
                      'Reset',
                      style: TextStyle(
                        color: Colors.black,
                        // decoration: TextDecoration.underline
                      ),
                    )),
                TextButton(
                    style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all(
                            Size(size.width * .30, 45)),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.pink[50]),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(1)))),
                    onPressed: () => calculate(),
                    child: Text(
                      'Calculate',
                      style: TextStyle(
                        color: Colors.black,
                        // decoration: TextDecoration.underline
                      ),
                    )),
              ],
            )
          ],
        ),
      ),
    ));
  }
}
