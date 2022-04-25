import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  ScrollController sc = ScrollController();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        controller: sc,
        child: Container(
          decoration: BoxDecoration(
            // gradient: LinearGradient(
            //   begin: Alignment.topRight,
            //   end: Alignment(2, 2),
            //   colors: [
            //     Colors.purpleAccent,
            //     Colors.pinkAccent,
            //   ],
            // )
            color: Colors.purple[400]
          ),
          height: size.height,
          child: Center(
            child: Container(
              padding: EdgeInsets.all(20),
              height: size.height*.80,
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                    )
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
                      // padding:EdgeInsets.all(10),
                      // decoration: BoxDecoration(color: Colors.white),
                      child: Image.asset(
                        "assets/logos/EleCon-removebg.png",
                        color: Colors.white,
                        fit: BoxFit.fill,
                      ),
                    )
                  ),
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        padding: EdgeInsets.only(left: 20,right: 20),
                        child: Text(
                          'Electricity consumption calculator and Home appliances manager',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            // fontWeight: FontWeight.bold
                            ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    )
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton(
                            style: ButtonStyle(
                              fixedSize: MaterialStateProperty.all(Size(150, 45)),
                              backgroundColor: MaterialStateProperty.all(Colors.pink[300]),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)
                                )
                              ) 
                            ),
                            onPressed: ()=>{
                              Navigator.pushNamed(context, 'Register')
                            }, 
                            child: Text(
                              'Sign up',
                              style: TextStyle(
                                color: Colors.white,
                                // decoration: TextDecoration.underline
                              ),
                            )
                          ),
                          TextButton(
                            style: ButtonStyle(
                              fixedSize: MaterialStateProperty.all(Size(150, 45)),
                              backgroundColor: MaterialStateProperty.all(Colors.pink[100]),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)
                                )
                              ) 
                            ),
                            onPressed: ()=>{
                              Navigator.pushNamed(context, 'LoginPortal')
                            }, 
                            child: Text(
                              'Log in',
                              style: TextStyle(
                                color: Colors.purple,
                                // decoration: TextDecoration.underline
                              ),
                            )
                          ),
                        ],
                      ),
                    )
                  ),
                ],
              ),
            )
          ),
        ),
      ),
    );
  }
}
