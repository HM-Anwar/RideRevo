import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ride_revo/utils/color_palette.dart';
import 'package:ride_revo/utils/enums.dart';
import 'package:ride_revo/utils/extensions.dart';
import 'package:ride_revo/utils/typography.dart';
import 'package:ride_revo/views/widgets/primary_button.dart';
import 'package:unicons/unicons.dart';
import 'package:widget_loading/widget_loading.dart';

class BookingCard extends StatelessWidget {
  const BookingCard({
    Key? key,
    required this.createdAt,
    required this.amount,
    required this.distance,
    required this.onPressed,
    required this.isLoading,
    required this.appMode,
    required this.boxColor,
  }) : super(key: key);
  final DateTime createdAt;
  final double amount;
  final double distance;
  final Function() onPressed;
  final bool isLoading;
  final AppMode appMode;
  final Color boxColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      margin: const EdgeInsets.symmetric(horizontal: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: ColorPalette.lightGreyColor, width: 1)),
      ),
      child: Center(
        child: ListTile(
          minLeadingWidth: 4,
          leading: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: boxColor.withOpacity(0.8),
              borderRadius: BorderRadius.circular(9),
            ),
            child: appMode.user
                ? const Icon(
                    Icons.motorcycle,
                    color: Colors.white,
                    size: 44,
                  )
                : const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 44,
                  ),
          ),
          title: SizedBox(
            height: 24,
            child: Row(
              children: [
                WiperLoading(
                  loading: isLoading,
                  wiperColor: ColorPalette.primaryColor.withOpacity(0.8),
                  child: PrimaryButton(
                    onPressed: onPressed,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    color: ColorPalette.primaryColor.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(9),
                    child: const Text(
                      'Show Location',
                      style: Styles.poppinsButtonTextStyle,
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Transform.translate(
                  offset: const Offset(0, -7),
                  child: Text(
                    '1.2 Km',
                    style: Styles.poppinsTitleStyle.copyWith(fontSize: 12),
                  ),
                )
              ],
            ),
          ),
          subtitle: Text(
            '${formatDateTime(createdAt)}\n${formatTime(createdAt)}',
            style: Styles.poppinsSubtitleStyle,
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                UniconsLine.receipt,
                size: 27,
              ),
              Text(
                'PKR ${amount.toStringAsFixed(0)}',
                style: Styles.titleStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String formatDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('dd MMM yyyy, EEEE');
    final String formattedDateTime = formatter.format(dateTime);
    return formattedDateTime;
  }

  String formatTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('h:mm a');
    final String formattedTime = formatter.format(dateTime);
    return formattedTime;
  }
}
