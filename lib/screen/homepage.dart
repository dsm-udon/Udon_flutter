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
import 'package:udon_flutter/screen/avoid.dart';

Future<TestList> getList() async {
  var url = 'https://jsonplaceholder.typicode.com/albums'; //http
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
    bool serviceEnabled; //위도 경도
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
    _prefs = await SharedPreferences.getInstance();
    setState(() {
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
              SizedBox(height: 30.h),
              _selecte1 == 1 ? screen1() : screen2(),
              SizedBox(height: 20.h),
              Padding(
                padding: EdgeInsets.only(left: 16.w, bottom: 16.h),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Avoid(),
                      ),
                    );
                  },
                  child: Container(
                    width: 328.w,
                    height: 44.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color(0xFFDCDCDC),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(top: 7.w),
                      child: Text(
                        '대피 방법',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFF564D4D),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'NotoSansKR',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16.w, bottom: 16.h),
                child: GestureDetector(
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
              ),
            ],
          ),
        );
      },
    );
  }

  Expanded screen1() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(left: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '안양시 만안구',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'NotoSansKR',
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 15.w),
                  child: IconButton(
                    onPressed: getLocation,
                    icon: const Icon(Icons.refresh),
                  ),
                ),
              ],
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
          ],
        ),
      ),
    );
  }

  Expanded screen2() {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10.h),
                child: Text(
                  address,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'NotoSansKR',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 7.w),
                child: Text(
                  '지진',
                  style: TextStyle(
                    fontSize: 48.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'NotoSansKR',
                  ),
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
            ],
          ),
        ),
      ),
    );
  }
}
