# jejard_desktop

## Project Description
This application was developed for a project that involves the development of a wireless, wearable system for monitoring movement in recovering stroke patients for 72 hours. This is one of two applications developed for the capstone project. Check out the other one at (https://github.com/alexishamrak/capstone-historical-app). 

This system provides doctors with a live visualization to help understand how the patient’s stroke has affected their mobility. The system integrates two small accelerometers worn on both wrists of the patient to continuously stream x-, y-, and z-data. Data is then transmitted to this application through AWS where it is output in a visual representation. It allows doctors to see a live silhouette that has color-changing arms to reflect the patient's movement as well as a graph containing raw accelerometer data. The thresholds for the silhouette have been hardcoded at the advice of doctors.  This live application will help doctors monitor their patients at any time and understand their recovery.


## How to run the desktop application

This app has been converted into an app package that is not included in the repository. To use this repository, you will need to:
* Install Flutter and Dart on your desired operating system
* Clone this repository, 
```
git clone https://github.com/alexishamrak/capstone-desktop.git
```
* Sign up and initialize AWS' IoT Core
    * Complete set up on server end of application 
* Inside the 'assets' folder, include a folder to store all your AWS certifications and keys
* Add a "keys.dart" file, where you will need to include the following information:

```
const String awsServerKey = '<pathToServerKey>';
const String clientId = '<nameOfClient>';
const String rootFile = '<pathToAWSrootFile>';
const String cert = '<pathToCertificationFile>';
const String pKey = '<pathToPrivateKeyFile>';
const String topicName = '<topicName>';
```
* To run the application, go to the 'main.dart' folder and run from there.

At the advice of Flutter, 

    For help getting started with Flutter development, view the
    [online documentation](https://docs.flutter.dev/), which offers tutorials,
    samples, guidance on mobile development, and a full API reference.
