import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';

import 'package:udon_flutter/model.dart';
import 'package:udon_flutter/screen/realhome.dart';

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

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<TestList>? model;

  @override
  void initState() {
    super.initState();
    model = getList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: model,
      builder: (context, snapshot) {
        return Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 12.h, 0.w, 0.h),
                child: Row(
                  children: [
                    Image.asset(
                      "assets/img/logo.png",
                      width: 48.w,
                      height: 48.h,
                    ),
                    SizedBox(width: 4.w),
                    Column(
                      children: [
                        SizedBox(height: 8.h),
                        Text(
                          "우리 동네 안전지대",
                          style: TextStyle(
                            fontFamily: 'NotoSansKR',
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 45.h, 0.w, 0.h),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 83.w,
                        height: 34.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFA902),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '내 위치',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 11.w),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/', (_) => false);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RealHome()),
                        );
                      },
                      child: Container(
                        width: 70.w,
                        height: 34.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1D1B20).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '본가',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: const Color(0xFF1D1B20).withOpacity(0.38),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 48.h, 0.w, 0.h),
                child: Text(
                  '안양시 만안구',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'NotoSansKR',
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
