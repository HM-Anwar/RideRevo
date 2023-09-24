import 'package:flutter/material.dart';
import 'package:ride_revo/utils/color_palette.dart';
import 'package:ride_revo/utils/typography.dart';
import 'package:ride_revo/views/widgets/primary_button.dart';

class ProfileButton extends StatelessWidget {
  const ProfileButton({
    Key? key,
    required this.icon,
    required this.text,
    required this.onPressed,
  }) : super(key: key);
  final IconData icon;
  final String text;
  final Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PrimaryButton(
          width: 68,
          height: 70,
          onPressed: onPressed,
          isCircleBorder: true,
          borderSide: const BorderSide(
            color: ColorPalette.black,
            width: 2,
          ),
          child: Icon(
            icon,
            size: 42,
          ),
        ),
        Text(
          text,
          style: Styles.poppinsTitleStyle,
        ),
      ],
    );
  }
}
