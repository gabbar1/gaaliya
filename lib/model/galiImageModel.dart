class GaliImageModel {
  String image;
  String name;
  String type;
  String key;

  GaliImageModel({this.image, this.name, this.type,this.key});

  GaliImageModel.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    name = json['name'];
    type = json['type'];
    key = json['key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['name'] = this.name;
    data['type'] = this.type;
    data['key'] = this.key;
    return data;
  }
}
