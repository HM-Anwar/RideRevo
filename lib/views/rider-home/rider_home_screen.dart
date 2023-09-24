import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_revo/controller/rider_home_controller.dart';
import 'package:ride_revo/models/app_user.dart';
import 'package:ride_revo/utils/color_palette.dart';
import 'package:ride_revo/utils/extensions.dart';
import 'package:ride_revo/utils/images.dart';
import 'package:ride_revo/utils/typography.dart';
import 'package:ride_revo/views/widgets/main_appbar.dart';
import 'package:ride_revo/views/widgets/primary_button.dart';
import 'package:ride_revo/views/widgets/scroll_behavior.dart';

class RiderHomeScreen extends StatelessWidget {
  const RiderHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RiderHomeController>(builder: (controller) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: MainAppBar(
          title: 'Search for Rides',
        ),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: context.screenWidth * 0.06),
          child: Column(
            children: [
              controller.rides.isEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: context.screenHeight * 0.2),
                        Image.asset(Images.rideNotFoundGif),
                        Text(
                          controller.mode.loading ? 'Searching.....' : 'No rides found..',
                          style: Styles.titleStyle.copyWith(
                            color: ColorPalette.greyColor,
                          ),
                        ),
                        const SizedBox(height: 92),
                      ],
                    )
                  : Expanded(
                      child: ScrollConfiguration(
                        behavior: HideScrollBehavior(),
                        child: GridView.builder(
                          // shrinkWrap: true,
                          itemCount: controller.users.length,
                          itemBuilder: (context, index) {
                            return PrimaryButton(
                              onPressed: () {
                                final ride = controller.rides[index];
                                controller.onGetSelectedUser(ride);
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12),
                                    ),
                                  ),
                                  builder: (context) {
                                    return rideBottomSheet(context, index);
                                  },
                                );
                              },
                              child: imageBorder(
                                size: 9,
                                child: profileImage(controller.users[index]),
                              ),
                            );
                          },
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 9,
                            mainAxisSpacing: 7,
                          ),
                        ),
                      ),
                    ),
              SizedBox(height: context.screenHeight * 0.04),
              // const Spacer(),
              controller.mode.loading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: ColorPalette.primaryColor,
                      ),
                    )
                  : PrimaryButton(
                      onPressed: controller.onSearchRides,
                      width: context.screenWidth,
                      height: 57,
                      color: ColorPalette.primaryColor,
                      borderRadius: BorderRadius.circular(12),
                      child: const Text(
                        'Search Rides',
                        style: Styles.poppinsButtonTextStyle,
                      ),
                    ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      );
    });
  }

  Widget rideBottomSheet(BuildContext context, int index) {
    return GetBuilder<RiderHomeController>(builder: (controller) {
      return Container(
        margin: EdgeInsets.symmetric(
          horizontal: context.screenWidth * 0.06,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            ListTile(
              leading: profileImage(controller.selectedUser),
              title: Text(
                controller.selectedUser!.name.capitalizeFirst!,
                style: Styles.appBarStyle,
              ),
              subtitle: Row(
                children: [
                  Text(
                    '${controller.rides[index].estimateDistance} km',
                    style: Styles.titleStyle,
                  ),
                  // map route icon
                  const Icon(
                    Icons.map,
                    color: ColorPalette.primaryColor,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            controller.acceptButton.loading
                ? const Center(
                    child: CircularProgressIndicator(color: ColorPalette.primaryColor),
                  )
                : PrimaryButton(
                    onPressed: controller.onAcceptRide,
                    borderRadius: BorderRadius.circular(12),
                    color: ColorPalette.primaryColor,
                    width: context.screenWidth,
                    height: 57,
                    child: const Text(
                      'Accept Ride',
                      style: Styles.poppinsButtonTextStyle,
                    ),
                  ),
            const SizedBox(height: 24),
          ],
        ),
      );
    });
  }

  Widget profileImage(AppUser? user) {
    return CircleAvatar(
      radius: 30,
      backgroundColor: Colors.grey,
      backgroundImage: user?.imageUrl != null
          ? NetworkImage(
              user!.imageUrl!,
            )
          : null,
      child: user?.imageUrl == null
          ? const Icon(
              Icons.person,
              color: Colors.white,
              size: 40,
            )
          : const SizedBox(),
    );
  }

  Widget imageBorder({required double size, required Widget child}) {
    return Container(
      margin: EdgeInsets.all(size),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: ColorPalette.primaryColor,
          width: 2,
        ),
      ),
      child: child,
    );
  }
}
