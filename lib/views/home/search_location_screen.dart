import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_revo/controller/home_controller.dart';
import 'package:ride_revo/helper/route_helper.dart';
import 'package:ride_revo/views/widgets/main_appbar.dart';
import 'package:unicons/unicons.dart';
import '../../utils/decoration.dart';
import 'widgets/pick_current_location.dart';

class SearchLocationScreen extends StatelessWidget {
  const SearchLocationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offAllNamed(RouteHelper.getHomeRoute);
        return true;
      },
      child: GetBuilder<HomeController>(
        builder: (controller) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: MainAppBar(
              title: 'Search Location',
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 7),
                  TextField(
                    onChanged: controller.onChangedSearchLocation,
                    decoration: AppDecoration.locationFieldDecoration.copyWith(
                      prefixIconConstraints: const BoxConstraints(minWidth: 60),
                      prefixIcon: const Icon(
                        UniconsLine.search,
                        size: 25,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const PickCurrentLocation(),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        final prediction = controller.autoCompletePrediction?.predictions[index];
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 7),
                          onTap: () async {
                            await controller.setSelectedLocation(prediction!);
                            Get.offAllNamed(RouteHelper.getPickLocationRoute);
                          },
                          title: Text(prediction?.description ?? ''),
                        );
                      },
                      itemCount: controller.autoCompletePrediction?.predictions.length ?? 0,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
