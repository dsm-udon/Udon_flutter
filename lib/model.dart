class Test {
  int? userId;
  int? id;
  String? title;

  Test({this.userId, this.id, this.title});

  Test.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    id = json['id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['id'] = id;
    data['title'] = title;
    return data;
  }
}

class TestList {
  final List<Test>? tests;
  TestList({this.tests});
  factory TestList.fromJson(List<dynamic> json) {
    List<Test> tests = <Test>[];
    tests = json.map((i) => Test.fromJson(i)).toList();

    return TestList(
      tests: tests,
    );
  }
}
