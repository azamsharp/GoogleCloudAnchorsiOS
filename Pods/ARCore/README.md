# ARCore SDK for iOS

This pod contains the ARCore SDK for iOS.

# Getting Started

*   *Cloud Anchors Quickstart*:
    https://developers.google.com/ar/develop/ios/cloud-anchors-quickstart-ios
*   *Reference*: https://developers.google.com/ar/reference/ios
*   *Code samples*: To try our sample app, use

    ```
    $ pod try ARCore
    ```

    and follow the instructions in the sample app's README.

# Installation

To integrate ARCore SDK for iOS into your Xcode project using CocoaPods, specify
it in your `Podfile`:

```
target 'YOUR_APPLICATION_TARGET_NAME_HERE'
platform :ios, '11.0'
pod 'ARCore'
```

Then, run the following command:

```
$ pod install
```

Before you can start using the API, you will need to register an API key in the
[Google Developer Console](https://console.developers.google.com/) for the
ARCore Cloud Anchor service.

# License and Terms of Service

By using the ARCore SDK for iOS you accept Google's Terms of Service and
Policies (https://developers.google.com/terms/).
