import 'package:flutter/material.dart';
import 'package:need_customer/theme/companycolors.dart';

class ExmCurve extends StatefulWidget {
  @override
  _ExmCurveState createState() => _ExmCurveState();
}

class _ExmCurveState extends State<ExmCurve> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomPaint(
        child: Container(
          height: 300,
          // decoration: BoxDecoration(color: CompanyColors.utama),
        ),
        painter: CurvePainter(),
      ),
    );
  }
}

class CurvePainter extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    Paint paint = Paint();

    path.lineTo(0, size.height * 0.75);
    path.quadraticBezierTo(size.width * 0.10, size.height * 0.70, size.width * 0.17, size.height * 0.90);
    path.quadraticBezierTo(size.width * 0.20, size.height, size.width * 0.25, size.height * 0.90);
    path.quadraticBezierTo(size.width * 0.40, size.height * 0.4, size.width * 0.50, size.height * 0.7);
    path.quadraticBezierTo(size.width * 0.60, size.height * 0.85, size.width * 0.65, size.height * 0.65);
    path.quadraticBezierTo(size.width * 0.70, size.height * 0.90, size.width, 0);
    path.close();

    paint.color = CompanyColors.utama;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return null;
  }

}