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
  //class 생성
  final List<Test>? tests; //tests라는 List 생성
  TestList({this.tests}); //생성자로 TestList에 받기
  factory TestList.fromJson(List<dynamic> json) {
    //factory
    List<Test> tests = <Test>[];
    tests = json.map((i) => Test.fromJson(i)).toList();

    return TestList(
      tests: tests,
    );
  }
}
