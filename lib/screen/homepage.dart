import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kpostal/kpostal.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:udon_flutter/model.dart';
import 'package:udon_flutter/screen/shelter.dart';

Future<TestList> getList() async {
  //http
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

SharedPreferences? _prefs;
String address = '지역을 설정해 주세요';
bool myLoc = true;

String realhome = '';

class _HomePageState extends State<HomePage> {
  Future<TestList>? model;

  @override //model
  void initState() {
    super.initState();
    model = getList();
    getLocation();
    realhome = address.toString();
    _loadId();
  }

  void getLocation() async {
    //위도 경도
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low,
    );

    double latitude = position.latitude;
    double longitude = position.longitude;

    print('Latitude: $latitude, Longitude: $longitude');
  }

  _loadId() async {
    //_loadId함수(비동기)
    _prefs = await SharedPreferences
        .getInstance(); // 캐시에 저장되어있는 값을 불러온다.(불러 올때까지 대기)
    setState(() {
      // 캐시에 저장된 값을 반영하여 현재 상태를 설정한다.
      // SharedPreferences에 id, pw로 저장된 값을 읽어 필드에 저장. 없을 경우 0으로 대입
      address = (_prefs!.getString('realhome') ?? address);
    });
  }

  void _fselecte1() {
    //color
    setState(() {
      _selecte1 = 1;
      _selecte2 = 0;
    });
  }

  void _fselecte2() {
    //color
    setState(() {
      _selecte1 = 0;
      _selecte2 = 1;
    });
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
                    ),
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
        );
      },
    );
  }

  Padding screen1() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 48.h, 0.w, 0.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '안양시 만안구',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              fontFamily: 'NotoSansKR',
            ),
          ),
          Text(
            '지진',
            style: TextStyle(
              fontSize: 48.sp,
              fontWeight: FontWeight.bold,
              fontFamily: 'NotoSansKR',
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Container(
              alignment: Alignment.centerRight,
              child: Image.asset(
                "assets/img/지진.png",
                width: 164.w,
                height: 164.h,
              ),
            ),
          ),
          SizedBox(height: 122.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '행동 요령',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'NotoSansKR',
                ),
              ),
              IconButton(
                onPressed: getLocation,
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
          SizedBox(height: 75.h),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Shelter(),
                ),
              );
            },
            child: Container(
              width: 328.w,
              height: 44.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color(0xFFFFB320),
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 7.w),
                child: Text(
                  '대피소 정보',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'NotoSansKR',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding screen2() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 48.h, 0.w, 0.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            address,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              fontFamily: 'NotoSansKR',
            ),
          ),
          Text(
            '지진',
            style: TextStyle(
              fontSize: 48.sp,
              fontWeight: FontWeight.bold,
              fontFamily: 'NotoSansKR',
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Container(
              alignment: Alignment.centerRight,
              child: Image.asset(
                "assets/img/지진.png",
                width: 164.w,
                height: 164.h,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 57.h, left: 11.w), //left 27.w
            child: GestureDetector(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => KpostalView(
                      callback: (Kpostal result) {
                        setState(() {
                          _prefs!.setString('realhome', result.address);
                          address = result.address;
                        });
                      },
                    ),
                  ),
                );
              },
              child: Container(
                width: 305,
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: const Color(0xFFFFB320),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10.w, 12.h, 0.w, 0.h),
                  child: Text(
                    "도로명 주소 찾기",
                    style: TextStyle(fontSize: 15.sp),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            '행동 요령',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w500,
              fontFamily: 'NotoSansKR',
            ),
          ),
          SizedBox(height: 75.h),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Shelter(),
                ),
              );
            },
            child: Container(
              width: 328.w,
              height: 44.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color(0xFFFFB320),
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 7.w),
                child: Text(
                  '대피소 정보',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'NotoSansKR',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
