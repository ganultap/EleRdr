import 'package:elecon_app/Controller/FirebaseController.dart';
import 'package:elecon_app/Models/BillingHistoryM.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class BillingHistory extends StatefulWidget {
  const BillingHistory({Key? key}) : super(key: key);

  @override
  _BillingHistoryState createState() => _BillingHistoryState();
}

class _BillingHistoryState extends State<BillingHistory> {
  final ScrollController _sc = ScrollController();
  final formatCurrency =
      NumberFormat.simpleCurrency(locale: "fil", name: "PHP");
  List<BillingHistoryM> datalist = [];

  @override
  initState() {
    super.initState();
    initData();
  }

  initData() async {
    var datalisttemp = await FirebaseController.getBillingHistory();

    setState(() {
      datalist = datalisttemp;
    });
  }

  Widget defaultBillingHistory() {
    return Card(
      child: ListTile(
          title: Center(
        child: Text('Nothing to Show'),
      )),
    );
  }

  Widget _billhistoryCard(data) {
    return Card(
      child: ListTile(
          title: Center(
            child: Text(
              data.date.toString().split(' ')[0],
            ),
          ),
          subtitle: Center(
            child: Text(formatCurrency.format(data.bills).toString()),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context);

    return AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      title: Center(
        child: Text(
          'Billing History',
          style: TextStyle(fontSize: 25, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
      content: Container(
          height: size.size.height * .50,
          color: Colors.transparent,
          child: SingleChildScrollView(
            controller: _sc,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  // maxHeight: size.size.height * .05,
                  ),
              child: Column(
                children: datalist.isNotEmpty
                    ? (datalist
                        .map<Widget>((data) => _billhistoryCard(data))
                        .toList())
                    : [defaultBillingHistory()],
              ),
            ),
          )),
    );
  }
}
