class Notifications {
  final String id,date;
  final double kwh;

  Notifications(
    this.id,
    this.date,
    this.kwh,
  );

}

class SampleNotifications{

  SampleNotifications();

  getSampleNotifications(){
    List<Notifications> data = [
      Notifications('0', '07/11/21', 32.00),
      Notifications('1', '08/11/21', 90.00),
      Notifications('2', '09/11/21', 50.00),
      Notifications('3', '10/11/21', 80.00)
    ];

    return data;
  }
}