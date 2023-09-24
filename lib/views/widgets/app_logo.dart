import 'package:flutter/material.dart';
import 'package:ride_revo/utils/images.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 160,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.white,
          width: 1.5,
        ),
        shape: BoxShape.circle,
        image: const DecorationImage(
          image: AssetImage(
            Images.appLogo,
          ),
        ),
      ),
    );
  }
}
