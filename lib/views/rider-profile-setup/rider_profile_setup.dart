import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ride_revo/controller/rider_profile_controller.dart';
import 'package:ride_revo/helper/route_helper.dart';
import 'package:ride_revo/repository/auth_repo.dart';
import 'package:ride_revo/utils/color_palette.dart';
import 'package:ride_revo/utils/decoration.dart';
import 'package:ride_revo/utils/enums.dart';
import 'package:ride_revo/utils/extensions.dart';
import 'package:ride_revo/utils/typography.dart';
import 'package:ride_revo/views/widgets/primary_button.dart';

class RiderProfileSetup extends StatelessWidget {
  const RiderProfileSetup({Key? key}) : super(key: key);
  static final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RiderProfileController>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            'Rider Profile Information',
            style: Styles.appBarStyle.copyWith(
              color: ColorPalette.black,
            ),
          ),
          toolbarHeight: 70,
        ),
        body: ListView(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 27),
                    profileImage(controller),
                    const SizedBox(height: 27),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return '* Name cannot be empty';
                        }
                      },
                      keyboardAppearance: Brightness.dark,
                      keyboardType: TextInputType.visiblePassword,
                      onChanged: controller.setName,
                      decoration: AppDecoration.textFieldDecoration.copyWith(
                        hintText: 'Full Name',
                      ),
                    ),
                    const SizedBox(height: 27),
                    TextFormField(
                      onChanged: controller.setBikeName,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return '* Bike Name cannot be empty';
                        }
                      },
                      keyboardAppearance: Brightness.dark,
                      decoration: AppDecoration.textFieldDecoration.copyWith(
                        hintText: 'Bike name (Unique)',
                      ),
                    ),
                    const SizedBox(height: 27),
                    TextFormField(
                      onChanged: controller.setBikeModel,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return '* Bike model cannot be empty';
                        }
                        return null;
                      },
                      keyboardAppearance: Brightness.dark,
                      decoration: AppDecoration.textFieldDecoration.copyWith(
                        hintText: 'Bike Model (CD-70 2019)',
                      ),
                    ),
                    const SizedBox(height: 27),
                    TextFormField(
                      onChanged: controller.setBikeRegNo,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return '* Bike Reg No cannot be empty';
                        }
                        return null;
                      },
                      keyboardAppearance: Brightness.dark,
                      decoration: AppDecoration.textFieldDecoration.copyWith(
                        hintText: 'Bike Reg No (ABC 100)',
                      ),
                    ),
                    const SizedBox(height: 27),
                    TextFormField(
                      keyboardAppearance: Brightness.dark,
                      keyboardType: TextInputType.phone,
                      onChanged: controller.setPhoneNo,
                      validator: (value) {
                        if (value!.length < 11) {
                          return '* Phone number must be 11 digits';
                        }
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      maxLength: 11,
                      decoration: AppDecoration.textFieldDecoration.copyWith(
                        hintText: 'Phone Number',
                      ),
                    ),
                    const SizedBox(height: 27),
                    controller.state.loading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : PrimaryButton(
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                final status = await controller.onContinuePressed();
                                if (status == ResponseStatus.success) {
                                  RouteHelper.checkAndAssignAuthRoute();
                                }
                              }
                            },
                            width: context.screenWidth,
                            height: 58,
                            borderRadius: BorderRadius.circular(12),
                            color: ColorPalette.primaryColor,
                            child: const Text(
                              'Continue',
                              style: Styles.poppinsButtonTextStyle,
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Stack profileImage(RiderProfileController controller) {
    return Stack(
      children: [
        Container(
          height: 150,
          width: 150,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: ColorPalette.greyColor,
            image: getImage(controller),
          ),
          child: (AuthRepo.getUser!.photoURL != null || controller.imageFile != null)
              ? const SizedBox()
              : const Icon(
                  Icons.person,
                  size: 100,
                  color: ColorPalette.lightGreyColor,
                ),
        ),
        Positioned(
          bottom: 0,
          child: CircleAvatar(
            radius: 18,
            backgroundColor: ColorPalette.primaryColor,
            child: IconButton(
              onPressed: controller.removeImageFile,
              icon: const Icon(
                Icons.close,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: CircleAvatar(
            radius: 18,
            backgroundColor: ColorPalette.primaryColor,
            child: IconButton(
              onPressed: controller.setImageFile,
              icon: const Icon(
                Icons.camera_alt,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  DecorationImage? getImage(RiderProfileController controller) {
    if (AuthRepo.getUser!.photoURL != null || controller.imageFile != null) {
      return DecorationImage(
        image: controller.imageFile != null
            ? FileImage(File(controller.imageFile!.path))
            : NetworkImage(
                AuthRepo.getUser!.photoURL!,
              ) as ImageProvider,
        fit: BoxFit.cover,
      );
    }
    return null;
  }
}
