import 'dart:math' as math;

import 'package:flutter/material.dart';

class HomescreenPage extends StatefulWidget {
  const HomescreenPage({Key? key}) : super(key: key);

  @override
  State<HomescreenPage> createState() => _HomescreenPageState();
}

class _HomescreenPageState extends State<HomescreenPage> {
  // get the screen height
  double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;
  // get the screen width
  double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;

  Widget _buildMStripeBanner(BuildContext context) {
    final bannerHeight = screenHeight(context);
    final stripeWidth = screenWidth(context) * 0.365;
    final stripeHeight = bannerHeight * 1.55;
    // final stripeHeight = bannerHeight * 2;

    return SizedBox(
      height: bannerHeight,
      child: Center(
        child: ClipRect(
          child: SizedBox(
            width: stripeWidth * screenWidth(context) / stripeWidth, // Ensure the banner fills the width of the screen
            height: screenHeight(context),
            child: Stack(
              alignment: Alignment.center,
              children: [
                _buildStripe(
                  color: Colors.blue,
                  width: stripeWidth,
                  height: stripeHeight,
                  horizontalOffset: -stripeWidth,
                  degrees: 20,
                ),
                _buildStripe(
                  color: Colors.purple,
                  width: stripeWidth,
                  height: stripeHeight,
                  horizontalOffset: 0,
                  degrees: 20,
                ),
                _buildStripe(
                  color: Colors.red,
                  width: stripeWidth,
                  height: stripeHeight,
                  horizontalOffset: stripeWidth,
                  degrees: 20,
                ),
              ],
            ),
          ),// offset it to the left by x percentage
        ),
      ),
    );
  }

  Widget _buildStripe({
    required Color color,
    required double width,
    required double height,
    required double horizontalOffset,
    required double degrees,
  }) {

    Widget stripe = Container(
      width: width,
      height: height,
      color: color,
    );

    // offset the stripe 
    stripe = Transform.translate(
      offset: Offset(horizontalOffset, 0),
      child: stripe,
    );


    // then rotate it by N degrees
    stripe = Transform.rotate(
      angle: degrees * math.pi / 180,
      child: stripe,
    );

    return stripe;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFFECECEC),
        child: Column(
          children: [
            // move the banner to the left X amount of percentage
            _buildMStripeBanner(context)
        
          ],
        ),
      ),
    );
  }



}

