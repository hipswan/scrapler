import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:scrapler/home.dart';
import 'package:scrapler/onboarding.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    log('In the material');
    return MaterialApp(
      title: 'Wavy image mask',
      theme: ThemeData(
        backgroundColor: Colors.pinkAccent,
        primarySwatch: Colors.blue,
      ),
      home: Onboarding5(),
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage>
//     with SingleTickerProviderStateMixin {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xff468966),
//       body: WavyHeaderImage(),
//     );
//   }
// }

// class WavyHeaderImage extends StatefulWidget {
//   @override
//   _WavyHeaderImageState createState() => _WavyHeaderImageState();
// }

// class _WavyHeaderImageState extends State<WavyHeaderImage> {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: ClipPath(
//         child: Neumorphic(
//           style: NeumorphicStyle(
//             shape: NeumorphicShape.concave,
//             boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
//             depth: 8,
//             lightSource: LightSource.topLeft,
//             color: Colors.grey,
//           ),
//           child: Container(
//             height: 500,
//             width: 200,
//             color: Color(0xfffff0a5),
//             child: Center(
//               child: Text('BoloTararara'),
//             ),
//           ),
//         ),
//         clipper: BottomWaveClipper(),
//       ),
//     );
//   }
// }

// class BottomWaveClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     var path = Path();

//     // Since the wave goes vertically lower than bottom left starting point,
//     // we'll have to make this point a little higher.
//     path.lineTo(0.0, size.height - 40);
//     final firstControlPoint = Offset(size.width / 2, size.height);
//     final firstEndPoint = Offset(size.width, size.height - 40);
//     path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
//         firstEndPoint.dx, firstEndPoint.dy);
//     path.lineTo(size.width, 0.0);
//     // TODO: The wavy clipping magic happens here, between the bottom left and bottom right points.

//     // The bottom right point also isn't at the same level as its left counterpart,
//     // so we'll adjust that one too.
//     // final firstControlPoint = Offset(size.width / 4, size.height);
//     // final firstEndPoint = Offset(size.width / 2.25, size.height - 30.0);
//     // path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
//     //     firstEndPoint.dx, firstEndPoint.dy);
//     // var secondControlPoint =
//     //     Offset(size.width - (size.width / 3.25), size.height - 65);
//     // var secondEndPoint = Offset(size.width, size.height - 40);
//     // path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
//     //     secondEndPoint.dx, secondEndPoint.dy);
//     // path.lineTo(size.width, size.height / 2);
//     // path.lineTo(size.width, 0.0);
//     path.close();
//     return path;
//   }

//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) => false;
// }
