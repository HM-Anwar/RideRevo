import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ride_revo/controller/user_controller.dart';
import 'package:ride_revo/utils/color_palette.dart';
import 'package:ride_revo/utils/decoration.dart';
import 'package:ride_revo/utils/typography.dart';
import 'package:ride_revo/views/widgets/main_appbar.dart';
import 'package:ride_revo/views/widgets/primary_button.dart';
import 'package:ride_revo/utils/extensions.dart';

class EditRiderProfileScreen extends StatelessWidget {
  const EditRiderProfileScreen({Key? key}) : super(key: key);
  static final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MainAppBar(
        title: 'Edit Profile',
        leading: const Icon(
          Icons.edit,
          color: Colors.black,
        ),
      ),
      body: GetBuilder<UserController>(builder: (controller) {
        return ListView(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32),
                    const Text(
                      'Full Name',
                      style: Styles.titleStyle,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      initialValue: controller.rider!.name,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return '* Name cannot be empty';
                        }
                      },
                      onChanged: controller.setName,
                      decoration: AppDecoration.textFieldDecoration.copyWith(
                        prefixIcon: const Icon(
                          Icons.person,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Phone Number',
                      style: Styles.titleStyle,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      initialValue: controller.rider!.phoneNo,
                      onChanged: controller.setPhoneNo,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return '* Phone number cannot be empty';
                        }
                      },
                      decoration: AppDecoration.textFieldDecoration.copyWith(
                        prefixIcon: const Icon(
                          Icons.phone,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Bike Name',
                      style: Styles.titleStyle,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      initialValue: controller.rider!.bikeName,
                      onChanged: controller.setBikeName,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return '* Bike Name cannot be empty';
                        }
                      },
                      decoration: AppDecoration.textFieldDecoration.copyWith(
                        prefixIcon: const Icon(
                          Icons.motorcycle,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Bike Model',
                      style: Styles.titleStyle,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      initialValue: controller.rider!.bikeModel,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return '* Bike Model cannot be empty';
                        }
                      },
                      onChanged: controller.setBikeModel,
                      decoration: AppDecoration.textFieldDecoration.copyWith(
                        prefixIcon: const Icon(
                          Icons.motorcycle,
                        ),
                      ),
                    ),
                    const SizedBox(height: 42),
                    controller.buttonMode.loading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : PrimaryButton(
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                await controller.updateRiderDetails();
                                Get.back();
                              }
                            },
                            width: context.screenWidth,
                            height: 58,
                            borderRadius: BorderRadius.circular(12),
                            color: ColorPalette.primaryColor,
                            child: const Text(
                              'Update Profile',
                              style: Styles.poppinsButtonTextStyle,
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  String formatDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('dd MMM yyyy');
    final String formattedDateTime = formatter.format(dateTime);
    return formattedDateTime;
  }
}
