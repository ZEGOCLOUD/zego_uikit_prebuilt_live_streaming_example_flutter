- - -
# Overview
- - -

**Live Streaming Kit** is a feature-rich livestream component, which enables you to build custom live streaming into your apps with only a few lines of code. And you can also customize various live streaming features by configuring parameters.


| Host | Audience |
| --- | --- |
|![host_3.gif](./../images/host_3.gif)|![audience_3](./../images/audience_3.gif)|



## When do you need the Live Streaming Kit

- Build apps faster and easier
  > When you want to prototype live streaming ASAP 
  
  > Consider speed or efficiency as the first priority. 

- Customize UI as needed
  > When you want to customize the UI based on your actual business needs
  
  > Don't want to waste time developing basic features

Live Streaming Kit helps you to **integrate within the shortest possible time**, and it includes the business logic with the UI, allowing you to **customize features accordingly**.

To finest-grained build a live stream app, you may try our [Live Streaming SDK](https://docs.zegocloud.com/article/14313) to make full customization.



## Embedded features

- Ready-to-use live streaming
- Customizable UI style
- Real-time interactive text chat
- Real-time audience capacity display
- Device management
- Extendable menu bar
- Co-hosting (make co-host & apply co-host)


## Recommended resources


* I want to get started to implement [a basic live stream](https://docs.zegocloud.com/article/14846) swiftly
* I want to get the [Sample Code](https://github.com/ZEGOCLOUD/zego_uikit_prebuilt_live_streaming_example_flutter)
* I want to get started to implement [a live stream with co-hosting](https://docs.zegocloud.com/article/14882)
* To [configure prebuilt UI](https://docs.zegocloud.com/article/14878) for a custom experience


- - -
# Quick start
- - -

Watch the video as belowed:

[![Watch the video](https://storage.zego.im/sdk-doc/Pics/ZegoUIKit/videos/How_to_build_live_streaming_using_Flutter.png)](https://www.youtube.com/watch?v=uVnanx2Q2lM)

## Integrate the SDK

### Add ZegoUIKitPrebuiltLiveStreaming as dependencies

Run the following code in your project's root directory: 

```dart
flutter pub add zego_uikit_prebuilt_live_streaming
```


### Import the SDK

Now in your Dart code, import the Live Streaming Kit SDK.

```dart
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming';
```


## Using the Live Streaming Kit


- Go to [ZEGOCLOUD Admin Console](https://console.zegocloud.com/), get the `appID` and `appSign` of your project.
- Specify the `userID` and `userName` for connecting the Live Streaming Kit service. 
- `liveID` represents the live streaming you want to start or watch (only supports single-host live streaming for now). 


<div class="mk-hint">

- `userID`, `userName` and `liveID` can only contain numbers, letters, and underlines (_). 
- Using the same `liveID` will enter the same live streaming.
</div>

<div class="mk-warning">

With the same `liveID`, only one user can enter the live stream as host. Other users need to enter the live stream as the audience.
</div>


```dart
class LivePage extends StatelessWidget {
  final String liveID;
  final bool isHost;

  const LivePage({Key? key, required this.liveID, this.isHost = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ZegoUIKitPrebuiltLiveStreaming(
        appID: yourAppID,// Fill in the appID that you get from ZEGOCLOUD Admin Console.
        appSign: yourAppSign,// Fill in the appSign that you get from ZEGOCLOUD Admin Console.
        userID: 'user_id',
        userName: 'user_name',
        liveID: liveID,
        config: isHost
            ? ZegoUIKitPrebuiltLiveStreamingConfig.host()
            : ZegoUIKitPrebuiltLiveStreamingConfig.audience(),
      ),
    );
  }
}
```

Then, you can start a live stream. And the audience can watch the live stream by entering the `liveID`.




## Config your project

- Android:

1. If your project is created with Flutter 2.x.x, you will need to open the `your_project/android/app/build.gradle` file, and modify the `compileSdkVersion` to **33**.


   ![compileSdkVersion](https://storage.zego.im/sdk-doc/Pics/ZegoUIKit/Flutter/compile_sdk_version.png)

2. Add app permissions.
Open the file `your_project/app/src/main/AndroidManifest.xml`, and add the following:

   ```xml
   <uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />
   <uses-permission android:name="android.permission.RECORD_AUDIO" />
   <uses-permission android:name="android.permission.INTERNET" />
   <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
   <uses-permission android:name="android.permission.CAMERA" />
   <uses-permission android:name="android.permission.BLUETOOTH" />
   <uses-permission android:name="android.permission.MODIFY_AUDIO_SETTINGS" />
   <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
   <uses-permission android:name="android.permission.READ_PHONE_STATE" />
   <uses-permission android:name="android.permission.WAKE_LOCK" />
   ```
    <img src="https://storage.zego.im/sdk-doc/Pics/ZegoUIKit/Flutter/live/permission_android.png" width=800>

3. Prevent code obfuscation.

To prevent obfuscation of the SDK public class names, do the following:

a. In your project's `your_project > android > app` folder, create a `proguard-rules.pro` file with the following content as shown below:

<pre style="background-color: #011627; border-radius: 8px; padding: 25px; color: white"><div>
-keep class **.zego.** { *; }
</div></pre>

b. Add the following config code to the `release` part of the `your_project/android/app/build.gradle` file.


<pre style="background-color: #011627; border-radius: 8px; padding: 25px; color: white"><div>
proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
</div></pre>

![android_class_confusion.png](https://storage.zego.im/sdk-doc/Pics/ZegoUIKit/Flutter/android_class_confusion.png)



- iOS:

1. Add app permissions.

a. open the `your_project/ios/Podfile` file, and add the following to the `post_install do |installer|` part:

```plist
# Start of the permission_handler configuration
target.build_configurations.each do |config|
  config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= [
    '$(inherited)',
    'PERMISSION_CAMERA=1',
    'PERMISSION_MICROPHONE=1',
  ]
end
# End of the permission_handler configuration
```

<img src="https://storage.zego.im/sdk-doc/Pics/ZegoUIKit/Flutter/live/permission_podfile.png" width=800>

b. open the `your_project/ios/Runner/Info.plist` file, and add the following to the `dict` part:

```plist
    <key>NSCameraUsageDescription</key>
    <string>We require camera access to connect to a live</string>
    <key>NSMicrophoneUsageDescription</key>
    <string>We require microphone access to connect to a live</string>
```

<img src="https://storage.zego.im/sdk-doc/Pics/ZegoUIKit/Flutter/live/permission_ios.png" width=800>



##  Run & Test

Now you can simply click the **Run** or **Debug** button to run and test your App on the device.
![run_flutter_project.jpg](https://storage.zego.im/sdk-doc/Pics/ZegoUIKit/Flutter/run_flutter_project.jpg)

## Related guide

[Custom prebuilt UI](https://docs.zegocloud.com/article/14878)

