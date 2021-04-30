class CommentModel {
  String comment;
  int likes;
  String name;
  String postID;
  String key;
  String time;
  String userID;
  CommentModel({this.comment, this.likes, this.name, this.postID,this.key,this.time,this.userID});

  CommentModel.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    comment = json['comment'];
    likes = json['likes'];
    name = json['name'];
    postID = json['postID'];
    time = json['time'];
    userID = json['userID'];
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['comment'] = this.comment;
    data['likes'] = this.likes;
    data['name'] = this.name;
    data['postID'] = this.postID;
    data['time'] = this.time;
    data['userID'] = this.userID;
    return data;
  }
}