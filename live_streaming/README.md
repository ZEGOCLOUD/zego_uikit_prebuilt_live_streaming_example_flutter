# Quick start

- - -
## Integrate the SDK

### Add ZegoUIKitPrebuiltLiveStreaming as dependencies

Run the following code in your project root directory:

```dart
flutter pub get zego_uikit_prebuilt_live_streaming
```

This will add a line like this to your project's `pubspec.yaml` file (and Flutter will automatic run an implicit `flutter pub get`):

```dart
dependencies:
  zego_uikit_prebuilt_live_streaming: ^1.2.5 # Add this line
```

### Import the SDK

Now in your Dart code, import the prebuilt Video Call Kit SDK.

```dart
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming';
```


## Integrate the live streaming
> You can get the AppID and AppSign from [ZEGOCLOUD's Console](https://console.zegocloud.com).

> Users who use the same liveID can in the same live streaming. (ZegoUIKitPrebuiltLiveStreaming supports 1 host Live for now)

> you can customize UI by config properties

```dart
@override
Widget build(BuildContext context) {
   return SafeArea(
      child: ZegoUIKitPrebuiltLiveStreaming(
         appID: /*Your App ID*/,
         appSign: /*Your App Sign*/,
         userID: user_id, // userID should only contain numbers, English characters and  '_'
         userName: 'user_name',
         liveID: 'live_id',
         config: isHost
                 ? ZegoUIKitPrebuiltLiveStreamingConfig.host()
                 : ZegoUIKitPrebuiltLiveStreamingConfig.audience(),
      ),
   );
}
```

**Now, you can start a live stream, other people who enter the same '*live name*' can watch your live stream.**

## How to run

### 1. Config your project

#### Android

1. If your project was created with a version of flutter that is not the latest stable, you may need to manually modify compileSdkVersion in `your_project/android/app/build.gradle` to 33

   ![compileSdkVersion](https://storage.zego.im/sdk-doc/Pics/ZegoUIKit/Flutter/compile_sdk_version.png)
2. Need to add app permissions, Open the file `your_project/app/src/main/AndroidManifest.xml`, add the following code:

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

#### iOS

Need add app permissions, open ·your_project/ios/Runner/Info.plist·, add the following code inside the "dict" tag:

```plist
<key>NSCameraUsageDescription</key>
<string>We require camera access to connect to a live</string>
<key>NSMicrophoneUsageDescription</key>
<string>We require microphone access to connect to a live</string>
```
<img src="https://storage.zego.im/sdk-doc/Pics/ZegoUIKit/Flutter/live/permission_ios.png" width=800>

#### Turn off some classes's confusion

To prevent the ZEGO SDK public class names from being obfuscated, please complete the following steps:

1. Create `proguard-rules.pro` file under [your_project > android > app] with content as show below:
```
-keep class **.zego.** { *; }
```

2. Add the following config code to the release part of the `your_project/android/app/build.gradle` file.
```
proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
```

![image](https://storage.zego.im/sdk-doc/Pics/ZegoUIKit/Flutter/android_class_confusion.png)

### 2. Build & Run

Now you can simply click the "Run" or "Debug" button to build and run your App on your device.
![/Pics/ZegoUIKit/Flutter/run_flutter_project.jpg](https://storage.zego.im/sdk-doc/Pics/ZegoUIKit/Flutter/run_flutter_project.jpg)

## Related guide

[Custom prebuilt UI](!ZEGOUIKIT_Custom_prebuilt_UI)

## Resources

<div class="md-grid-list-box">
  <a href="https://github.com/ZEGOCLOUD/zego_uikit_prebuilt_live_streaming_example_flutter/tree/master/live_streaming" class="md-grid-item" target="_blank">
    <div class="grid-title">Sample code</div>
    <div class="grid-desc">Click here to get the complete sample code.</div>
  </a>
</div>
