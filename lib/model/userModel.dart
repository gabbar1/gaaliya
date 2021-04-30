class UserModel {
  String profile;
  String userEmail;
  String userID;
  String userName;
  String key;

  UserModel({this.profile, this.userEmail, this.userID, this.userName,this.key});

  UserModel.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    profile = json['profile'];
    userEmail = json['userEmail'];
    userID = json['userID'];
    userName = json['userName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['profile'] = this.profile;
    data['userEmail'] = this.userEmail;
    data['userID'] = this.userID;
    data['userName'] = this.userName;
    return data;
  }
}