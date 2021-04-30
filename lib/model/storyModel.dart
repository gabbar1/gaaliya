class StoryModel {
  String story;
  String time;
  String key;
  StoryModel({this.time,this.story,this.key});

  StoryModel.fromJson(Map<String, dynamic> json) {
    story = json['story'];
    time = json['time'];
    key = json['key'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['story'] = this.story;
    data['time'] = this.time;
    return data;
  }
}