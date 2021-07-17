class FollowModel {
  String userID;
  String userName;
  String profile;
  String key;

  FollowModel({this.userID, this.userName,this.key,this.profile});

  FollowModel.fromJson(Map<String, dynamic> json) {
    userID = json['userID'];
    userName = json['userName'];
    profile = json['profile'];
    key = json['key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userID'] = this.userID;
    data['userName'] = this.userName;
    data['profile'] = this.profile;
    data['key'] = this.key;
    return data;
  }
}
