class CustomObject {
  String? title;
  String? body;

  CustomObject.fromJson(Map<String, dynamic> data) {
    title = data["title"];
    body = data["body"];
  }
}
