import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';

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

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

int _selecte1 = 1;
int _selecte2 = 0;

class _HomePageState extends State<HomePage> {
  Future<TestList>? model;

  void getLocation() async {
    // 위치 정보 서비스 사용 가능한지 확인
    bool serviceEnabled;
    LocationPermission permission;

    // 위치 정보 서비스 활성화 확인
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    // 위치 정보 권한 확인
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return;
      }
    }

    // 위치 정보 받기
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low,
    );

    // 위치 정보 사용
    double latitude = position.latitude;
    double longitude = position.longitude;

    print('Latitude: $latitude, Longitude: $longitude');
  }

  void _fselecte1() {
    setState(() {
      _selecte1 = 1;
      _selecte2 = 0;
    });
  }

  void _fselecte2() {
    setState(() {
      _selecte1 = 0;
      _selecte2 = 1;
    });
  }

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
                      onTap: () {
                        _fselecte1();
                      },
                      child: Container(
                        width: 83.w,
                        height: 34.h,
                        decoration: BoxDecoration(
                          color: _selecte1 == 1
                              ? const Color(0xFFFFA902)
                              : const Color(0xFF1D1B20).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '내 위치',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: _selecte1 == 1
                                  ? Colors.white
                                  : const Color(0xFF1D1B20).withOpacity(0.38),
                            ),
                          ), //1D1B20
                        ),
                      ),
                    ),
                    SizedBox(width: 11.w),
                    GestureDetector(
                      onTap: () {
                        _fselecte2();
                      },
                      child: Container(
                        width: 70.w,
                        height: 34.h,
                        decoration: BoxDecoration(
                          color: _selecte2 == 1
                              ? const Color(0xFFFFA902)
                              : const Color(0xFF1D1B20).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '본가',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: _selecte2 == 1
                                  ? Colors.white
                                  : const Color(0xFF1D1B20).withOpacity(0.38),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _selecte1 == 1 ? screen1() : screen2()
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: getLocation,
          ),
        );
      },
    );
  }
}

Column screen1() {
  return const Column(
    children: [Text('screen1')],
  );
}

Column screen2() {
  return const Column(
    children: [Text('screen2')],
  );
}
