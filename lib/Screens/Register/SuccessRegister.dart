import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SuccessRegister extends StatefulWidget {
  const SuccessRegister({Key? key}) : super(key: key);

  @override
  _SuccessRegisterState createState() => _SuccessRegisterState();
}

class _SuccessRegisterState extends State<SuccessRegister> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Center(
      child: Container(
        height: size.height * 1,
        color: Color.fromARGB(255, 134, 41, 134),
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: FaIcon(
                FontAwesomeIcons.solidCheckCircle,
                color: Color.fromARGB(255, 26, 228, 32),
                size: 100,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                'ACCOUNT SUCCESSFULLY CREATED!',
                style: TextStyle(
                    color: Colors.white, decoration: TextDecoration.none),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: TextButton(
                  style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(Size(150, 50)),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.pink[100]),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)))),
                  onPressed: () =>
                      {Navigator.popAndPushNamed(context, 'LoginPortal')},
                  child: Text(
                    'Log in',
                    style: TextStyle(
                      color: Colors.white,
                      // decoration: TextDecoration.underline
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
