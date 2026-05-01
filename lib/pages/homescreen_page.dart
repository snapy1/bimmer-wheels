import 'dart:math' as math;

import 'package:flutter/material.dart';

class HomescreenPage extends StatefulWidget {
  const HomescreenPage({Key? key}) : super(key: key);

  @override
  State<HomescreenPage> createState() => _HomescreenPageState();
}

class _HomescreenPageState extends State<HomescreenPage> {
  // get the screen height
  double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;
  // get the screen width
  double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;

  Widget _buildMStripeBanner(BuildContext context) {
    final bannerHeight = screenHeight(context);
    final bannerWidthFraction = 0.6; // percentage of screen width
    final bannerWidth = screenWidth(context) ;
    final stripeWidth = bannerWidth * 0.4;
    final stripeHeight = bannerHeight * 3.0;
    final horizontalBannerOffset = -bannerWidth * 0.28;
    // final stripeHeight = bannerHeight * 2;

    return SizedBox(
      height: bannerHeight,
      child: Center(
        child: ClipRect(
          child: Transform.translate(
            offset: Offset(horizontalBannerOffset, 0),
            child: SizedBox(
              width: bannerWidth,
              height: bannerHeight,
              child: OverflowBox(
                minWidth: bannerWidth,
                maxWidth: bannerWidth,
                minHeight: stripeHeight,
                maxHeight: stripeHeight,
                alignment: Alignment.center,
                child: Stack(
                  clipBehavior: Clip.none,
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
              ),
            ),
          ),
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
    Widget stripe = Container(width: width, height: height, color: color);

    // offset the stripe
    stripe = Transform.translate(
      offset: Offset(horizontalOffset, 0),
      child: stripe,
    );

    // then rotate it by N degrees
    stripe = Transform.rotate(angle: degrees * math.pi / 180, child: stripe);

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
            _buildMStripeBanner(context),
          ],
        ),
      ),
    );
  }
}
