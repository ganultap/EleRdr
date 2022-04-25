class UserModel {
  String id,fullname,email,password,dateofbirth;
  double kwhpesorate;

  UserModel(
    this.id,
    this.fullname,
    this.email,
    this.password,
    this.dateofbirth,
    this.kwhpesorate
  );

  Map<String, dynamic> toMap() {
    return {
      id: id,
      fullname: fullname,
      email: email,
      password: password,
      dateofbirth: dateofbirth,
      kwhpesorate.toString(): kwhpesorate
    };
  }

  UserModel.fromJson(Map<String, dynamic> json)
      : id= json['id'],
        fullname= json['fullname'],
        email= json['email'],
        password= json['password'],
        dateofbirth= json['dateofbirth'],
        kwhpesorate= double.parse(json['kwhpesorate'].toString());

  Map<String, dynamic> toJson() => {
        "id": id,
        "fullname": fullname,
        "email": email,
        "password": password,
        "dateofbirth": dateofbirth,
        "kwhpesorate": kwhpesorate
      };

}