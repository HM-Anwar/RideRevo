import 'package:flutter/material.dart';
import 'package:ride_revo/utils/typography.dart';
import 'package:ride_revo/views/widgets/main_appbar.dart';
import 'package:ride_revo/views/widgets/scroll_behavior.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MainAppBar(
        title: 'Privacy Policy',
      ),
      body: ScrollConfiguration(
        behavior: HideScrollBehavior(),
        child: ListView(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '''
>>>> Personal Information We Collect 
We collect the following personal information from you:

- Name
- Email address
- Phone number
- Profile picture
- location data
- User preferences and settings

How We Use Your Information
We use your information to:

- Facilitate ride requests and matching
- Verify your identity and eligibility
- Communicate ride details and updates
- Provide support and resolve issues

>>>> Security Measures
- We take reasonable measures to protect your information from unauthorized access or disclosure.

>>>> Data Retention
- We retain your information as long as necessary for the purposes outlined in this policy or as required by law.

>>>> Your Choices and Rights
- You can access, update, or delete your information. You may also unsubscribe from marketing communications.

>>>> Changes to the Privacy Policy
- We may update this policy. Any changes will be effective upon posting the revised policy on our app.

>>>> Contact Us
- If you have any questions or concerns regarding this policy, please contact us at anwaar.siddiqi97@gmail.com.

By using rideRevo, you agree to this Privacy Policy and the processing of your information as described herein.
                    ''',
                    // textAlign: TextAlign.justify,
                    style: Styles.poppinsTitleStyle,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
