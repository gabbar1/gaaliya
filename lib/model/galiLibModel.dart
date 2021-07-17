class GaliLibModel {
  String content;
  String type;
  String key;

  GaliLibModel({this.content, this.type,this.key});

  GaliLibModel.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    type = json['type'];
    key = json['key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['content'] = this.content;
    data['type'] = this.type;
    data['key'] = this.key;
    return data;
  }
}
