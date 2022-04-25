class BillingHistoryM {
  String id,date;
  double bills,totalkwh;

  BillingHistoryM(
    this.id,
    this.date,
    this.bills,
    this.totalkwh
  );

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "date": date,
      "bills": bills,
      "totalkwh": totalkwh
    };
  }

  BillingHistoryM.fromJson(Map<String, dynamic> json)
      : id= json['id'],
        date= json['date'],
        bills= json['bills'],
        totalkwh= json['totalkwh'];

  Map<String, dynamic> toJson() => {
        "id": id,
        "date": date,
        "bills": bills,
        "totalkwh": totalkwh
      };

}

class SampleBillingHistoryM{

  SampleBillingHistoryM();

  getSampleBillingHistoryM(){
    List<BillingHistoryM> data = [
      BillingHistoryM('0', '07/11/21', 3200.00,100),
      BillingHistoryM('1', '08/11/21', 9000.00,100),
      BillingHistoryM('2', '09/11/21', 500.00,100),
      BillingHistoryM('3', '10/11/21', 800.00,100)
    ];

    return data;
  }
}