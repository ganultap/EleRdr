import 'package:elecon_app/Screens/LandingPage/DashbaordView.dart';
import 'package:elecon_app/Screens/LandingPage/HomeView.dart';
import 'package:elecon_app/Screens/LandingPage/NotificationView.dart';
import 'package:elecon_app/Utils/SharedPreferences.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import "string_extension.dart";

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool isdashboard = true;
  bool isnotification = false;
  String username = 'USER';

  @override
  initState() {
    super.initState();
    setState(() {
      initData();
    });
  }

  initData() async {
    username = await DataStorage.getData('fullname');
    setState(() {
      username = username;
    });
  }

  Widget _titleView() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
          padding: EdgeInsets.only(top: 80),
          // height: 150,
          // color: Colors.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: isnotification
                ? [
                    Center(
                      child: Text(
                        'Notification',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 50,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ]
                : isdashboard
                    ? [
                        Center(
                          child: Text(
                            'WELCOME',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 50,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Center(
                          child: Text(
                            username.toTitleCase() + '!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ]
                    : [
                        Center(
                          child: Text(
                            'Home',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 50,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            toolbarHeight: 180,
            leading: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        if (isnotification) {
                          isnotification = false;
                        } else {
                          isdashboard = !isdashboard;
                        }
                      });
                    },
                    icon: FaIcon(
                      FontAwesomeIcons.home,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                )),
            title: _titleView(),
            // titleSpacing: 20,
            actions: [
              Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    margin: EdgeInsets.only(top: 10, right: 10),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          isnotification = !isnotification;
                        });
                      },
                      icon: FaIcon(
                        FontAwesomeIcons.bell,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ))
            ],
            backgroundColor: Colors.purple[300],
          ),
          backgroundColor: Colors.purple[300],
          resizeToAvoidBottomInset: true,
          body: isnotification
              ? const NotificationView()
              : isdashboard
                  ? const DashboardView()
                  : const HomeView()),
    );
  }
}
