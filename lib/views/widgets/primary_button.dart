import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    Key? key,
    required this.onPressed,
    required this.child,
    this.width = 0,
    this.height = 0,
    this.color,
    this.borderRadius = BorderRadius.zero,
    this.borderSide,
    this.padding = EdgeInsets.zero,
    this.isCircleBorder = false,
    this.isHoverDisable = false,
  }) : super(key: key);
  final Function()? onPressed;
  final Widget child;
  final double width;
  final double height;
  final Color? color;
  final BorderRadiusGeometry borderRadius;
  final BorderSide? borderSide;
  final EdgeInsetsGeometry? padding;
  final bool isCircleBorder;
  final bool isHoverDisable;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      splashColor: isHoverDisable ? Colors.transparent : null,
      highlightColor: isHoverDisable ? Colors.transparent : null,
      hoverColor: isHoverDisable ? Colors.transparent : null,
      disabledColor: color?.withOpacity(0.4),
      onPressed: onPressed,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
      padding: padding,
      color: color,
      elevation: 0,
      shape: isCircleBorder
          ? CircleBorder(side: borderSide ?? BorderSide.none)
          : RoundedRectangleBorder(
              borderRadius: borderRadius,
              side: borderSide ?? BorderSide.none,
            ),
      height: height,
      minWidth: width,
      child: child,
    );
  }
}
