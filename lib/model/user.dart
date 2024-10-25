class User {
  String? id;
  String? username;
  String? phone;
  String? password;
  String? usertype;


  User(
      {
      required this.id,
      required this.username,
      required this.phone,
      required this.password,
      required this.usertype});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    phone = json['phone'];
    password = json['password'];
    usertype = json['usertype'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['phone'] = phone;
    data['password'] = password;
    data['usertype'] = usertype;
    return data;
}
}