
<img  src="https://github.com/HM-Anwar/RideRevo/blob/main/screenshots/app_logo.png" alt="App Logo"  width="100" height="100" />


# RideRevo  
### A Bike Riding and Booking Application for Females only.

> Riderevo is a mobile application developed in Flutter. It is a user-friendly and secure platform designed to 
empower women by providing them with a convenient and safe means of booking 
bike rides. The application aims to promote gender equality and encourage more 
women to embrace biking as a mode of transportation. Through seamless ride 
booking, the application seeks to address the specific transportation needs and 
safety concerns faced by women. The application offers a user-friendly interface that 
allows women to easily navigate through various features, and select their desired 
pickup and drop-off locations, ensuring a hassle-free experience for users.



## Problem Statement and Objectives
### Safety and Security
Women face safety concerns and lack of secure transportation options, which hinders their mobility and confidence in commuting.
### Gender Equality
The existing transportation infrastructure often fails to consider the specific needs of female commuters, resulting in a lack of gender-sensitive facilities.
### Convenience and Efficiency
Traditional transportation systems may not always offer convenient and efficient options for female commuters.
### Promote Empowerment and Independence
The application aims to empower female riders by giving them the freedom to travel independently and confidently.


## Features

- **User Authentication**: Securely sign up, log in, and manage your user profile.
- **Ride Booking**: Easily book a ride, choose your destination, and view available drivers.
- **Real-time Tracking**: Track your ride in real-time on a map.
- **Rides History**: View your ride history.

## Installation

To run Riderevo locally, follow these steps:

1. **Clone the Repository**
2. **Navigate to the Project Directory**: `cd riderevo`
3. **Install Dependencies**: `flutter pub get`
4. **Firebase Config**
   - Create a Firebase project on the [Firebase Console]
   - Download the Firebase configuration file (google-services.json).
   - Enable Firebase Authentication
   - Enable Firebase Firestore (Cloud Firestore)
   - Enable Firebase Realtime Database.
   - Enable Firebase Storage and configure Firebase Storage in the code:
      - **Open the `lib/utils/constants.dart` file**: This file contains the important constants used in the app.
      - **Firebase Storage URL**:
      - Locate the `FIREBASE_STORAGE_URL` constant.
      - Replace `'YOUR_FIREBASE_STORAGE_URL'` with your actual Firebase Storage URL.
      <br>

   ```dart
   class Constants {
     static const String FIREBASE_STORAGE_URL = 'YOUR_FIREBASE_STORAGE_URL';
   }
   ```
      

5. **Configure Google Cloud Platform**
6. **Configure Google Maps API Key**:
     
   **STEP 1**
    - Open the `android/app/src/main/AndroidManifest.xml` file.
    - Find the `<meta-data>` tag inside the `<application>` element.
    - Replace `"YOUR_GOOGLE_MAPS_API_KEY"` with your actual Google Maps API key.
    <br>
   
   ```xml
   <meta-data
       android:name="com.google.android.geo.API_KEY"
       android:value="YOUR_GOOGLE_MAPS_API_KEY" />
   ```
   **STEP 2**
   - **Open the `lib/utils/constants.dart` file**: This file contains the important constants used in the app.
   - **Google Maps API Key**:
   - Locate the `GOOGLE_MAP_API_KEY` constant.
   - Replace `'YOUR_GOOGLE_MAPS_API_KEY'` with your actual Google Maps API key.
   <br>
   
   ```dart
   class Constants {
     static const String GOOGLE_MAP_API_KEY = 'YOUR_GOOGLE_MAPS_API_KEY';
   }
   ```
7. **Run the App**: `flutter run`

Make sure you have Flutter and Dart installed on your machine.


## Screenshots
<img src="https://github.com/HM-Anwar/RideRevo/blob/main/screenshots/authentication.png"/>
<img src="https://github.com/HM-Anwar/RideRevo/blob/main/screenshots/profile_completion.png"/>
<img src="https://github.com/HM-Anwar/RideRevo/blob/main/screenshots/user_home.png"/>
<img src="https://github.com/HM-Anwar/RideRevo/blob/main/screenshots/user_menu.png"/>
<img src="https://github.com/HM-Anwar/RideRevo/blob/main/screenshots/user_search.png"/>
<img src="https://github.com/HM-Anwar/RideRevo/blob/main/screenshots/ride_completed.png"/>
<img src="https://github.com/HM-Anwar/RideRevo/blob/main/screenshots/user_profile.png"/>
<img src="https://github.com/HM-Anwar/RideRevo/blob/main/screenshots/ride_history.png"/>
<img src="https://github.com/HM-Anwar/RideRevo/blob/main/screenshots/rider_home.png"/>
<img src="https://github.com/HM-Anwar/RideRevo/blob/main/screenshots/rider_ride.png"/>
<img src="https://github.com/HM-Anwar/RideRevo/blob/main/screenshots/rider_arrived.png"/>
<img src="https://github.com/HM-Anwar/RideRevo/blob/main/screenshots/rider_finished.png"/>
<img src="https://github.com/HM-Anwar/RideRevo/blob/main/screenshots/rider_completed.png"/>
<img src="https://github.com/HM-Anwar/RideRevo/blob/main/screenshots/rider_bookings.png"/>
<img src="https://github.com/HM-Anwar/RideRevo/blob/main/screenshots/rider_profile.png"/>


## Contributing

We welcome contributions from the community! If you'd like to contribute to Riderevo, please follow these guidelines:

1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Make your changes and commit them with meaningful messages.
4. Create a pull request to the `main` branch of this repository.

Please make sure to test your changes thoroughly before submitting a pull request.

## Issues

If you encounter any issues with Riderevo or have any feature requests, please open an issue on GitHub. We appreciate your feedback!


