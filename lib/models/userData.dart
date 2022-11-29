class UserData {
  late User user;
  late bool error;
  late String message;

  UserData(this.user, this.error, this.message, );

  UserData.fromJson(Map<String, dynamic> json) {
    if(json.containsKey('user')){
      user = User.fromJson(json['user']);
    }
    message = json['message'];
    error = json['error'];
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['error'] = error;
    data['message'] = message;
    data['user'] = user.toJson();
    return data;
  }

}

class User {
  late String name;
  late String mobile;
  late String email;
  late String profile;
  late String app_token;


  User(this.name, this.mobile, this.email, this.profile, this.app_token);

  User.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    name = json['name'];
    mobile = json['mobile'];
    profile = json['profile'];
    app_token = json['app_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['name'] = name;
    data['mobile'] = mobile;
    data['profile'] = profile;
    data['app_token'] = app_token;

    return data;
  }
}
