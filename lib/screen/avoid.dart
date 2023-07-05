import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

import 'package:udon_flutter/model.dart';

Future<TestList> getList() async {
  var url = 'https://jsonplaceholder.typicode.com/albums';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    return TestList.fromJson(
      jsonDecode(response.body),
    );
  } else {
    throw Exception('No Server Response');
  }
}

class Avoid extends StatefulWidget {
  const Avoid({Key? key}) : super(key: key);

  @override
  State<Avoid> createState() => _AvoidState();
}

class _AvoidState extends State<Avoid> {
  Future<TestList>? model;

  @override //model
  void initState() {
    super.initState();
    model = getList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: model,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              toolbarHeight: 99.w,
              elevation: 0,
              surfaceTintColor: Colors.white,
              title: Text(
                '대피 방법',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'NotoSansKR',
                  color: Colors.black,
                ),
              ),
              leading: Padding(
                padding: EdgeInsets.only(left: 10.w),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            body: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: snapshot.data!.tests!.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      title: Text(
                        '${index + 1}. 우동 우동 우동 우동 우동 우동 우동',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'NotoSansKR',
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h)
                  ],
                );
              },
            ),
          );
        } else if (snapshot.hasError) {
          return Text(snapshot.hasError.toString());
        } else {
          return Scaffold(
            backgroundColor: const Color(0xFFFFD615),
            body: Center(
              child: Image.asset(
                'assets/img/logo.png',
              ),
            ),
          );
        }
      },
    );
  }
}
