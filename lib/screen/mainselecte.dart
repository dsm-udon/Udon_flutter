import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Selecte extends StatefulWidget {
  const Selecte({Key? key}) : super(key: key);

  @override
  State<Selecte> createState() => _SelecteState();
}

int _selecte1 = 1;
int _selecte2 = 0;
int _selecte3 = 0;

class _SelecteState extends State<Selecte> {
  void _fselecte1() {
    setState(() {
      _selecte1 = 1;
      _selecte2 = 0;
      _selecte3 = 0;
    });
  }

  void _fselecte2() {
    setState(() {
      _selecte1 = 0;
      _selecte2 = 1;
      _selecte3 = 0;
    });
  }

  void _fselecte3() {
    setState(() {
      _selecte1 = 0;
      _selecte2 = 0;
      _selecte3 = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            _fselecte1();
          },
          child: Container(
            width: 70.w,
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
        SizedBox(width: 11.w),
        GestureDetector(
          onTap: () {
            _fselecte3();
          },
          child: Container(
            width: 70.w,
            height: 34.h,
            decoration: BoxDecoration(
              color: _selecte3 == 1
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
                  color: _selecte3 == 1
                      ? Colors.white
                      : const Color(0xFF1D1B20).withOpacity(0.38),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
