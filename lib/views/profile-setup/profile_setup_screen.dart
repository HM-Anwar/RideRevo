import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ride_revo/controller/profile_setup_controller.dart';
import 'package:ride_revo/helper/route_helper.dart';
import 'package:ride_revo/repository/auth_repo.dart';
import 'package:ride_revo/utils/color_palette.dart';
import 'package:ride_revo/utils/decoration.dart';
import 'package:ride_revo/utils/enums.dart';
import 'package:ride_revo/utils/extensions.dart';
import 'package:ride_revo/utils/typography.dart';
import 'package:intl/intl.dart';
import 'package:ride_revo/views/widgets/primary_button.dart';

class ProfileSetupScreen extends StatelessWidget {
  const ProfileSetupScreen({Key? key}) : super(key: key);
  static final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileSetupController>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            'Fill Your Profile',
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
                      onTap: () async {
                        final DateTime? selectedDate = await showDatePicker(
                          context: context,
                          initialDate: controller.dateOfBirth ?? DateTime.now(),
                          firstDate: DateTime(1990),
                          lastDate: DateTime.now(),
                        );
                        if (selectedDate != null) {
                          controller.setDateOfBirth(selectedDate);
                          debugPrint(controller.dateOfBirth.toString());
                        }
                      },
                      readOnly: true,
                      keyboardAppearance: Brightness.dark,
                      controller: TextEditingController(
                        text: controller.dateOfBirth != null ? DateFormat.yMd().format(controller.dateOfBirth!) : null,
                      ),
                      decoration: AppDecoration.textFieldDecoration.copyWith(
                        hintText: 'Date of Birth',
                        suffixIcon: const Icon(
                          Icons.calendar_today,
                          color: ColorPalette.black,
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return '* Date of birth cannot be empty';
                        }
                      },
                    ),
                    const SizedBox(height: 27),
                    TextFormField(
                      initialValue: AuthRepo.getUser!.email,
                      keyboardAppearance: Brightness.dark,
                      enabled: false,
                      decoration: AppDecoration.textFieldDecoration.copyWith(
                        hintText: 'Email',
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
                                  Get.offAllNamed(RouteHelper.getHomeRoute);
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

  Stack profileImage(ProfileSetupController controller) {
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

  DecorationImage? getImage(ProfileSetupController controller) {
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
