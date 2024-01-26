class FeedbackType {
  int? id;
  String? label;
  String? description;
  String? imageUrl;

  FeedbackType({this.id, this.label, this.description, this.imageUrl});

  FeedbackType.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    label = json["label"];
    description = json["description"];
    imageUrl = json["imageUrl"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["label"] = label;
    _data["description"] = description;
    _data["imageUrl"] = imageUrl;
    return _data;
  }
}
