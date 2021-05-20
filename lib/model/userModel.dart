class UserModel {
  String profile;
  String userEmail;
  String userID;
  String userName;
  String galiUserID;
  String followers;
  String following;
  String key;
  String folderID;

  UserModel({this.profile, this.userEmail, this.userID, this.userName,this.key,this.folderID});

  UserModel.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    profile = json['profile'];
    userEmail = json['userEmail'];
    userID = json['userID'];
    userName = json['userName'];
    folderID = json['folderID'];
    galiUserID = json['galiUserID'];
    followers = json['followers'].toString();
    following = json['following'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['profile'] = this.profile;
    data['userEmail'] = this.userEmail;
    data['userID'] = this.userID;
    data['userName'] = this.userName;
    data['following'] = this.following;
    data['followers'] = this.followers;
    data['folderID'] = this.folderID;
    data['galiUserID'] = this.galiUserID;
    return data;
  }
}