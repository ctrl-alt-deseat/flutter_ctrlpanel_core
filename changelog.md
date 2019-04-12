## 0.3.0

- 💥 Use `CtrlpanelCore` library instead of `flutter_jsbridge`

  Migration Guide:

  Android support is no longer present, will be added at a later date.

  You now need to import the upstream library `JSBridge` and register the global hook. Make the following change to your `AppDelegate`:

  ```diff
  @@ -1,6 +1,6 @@
   import UIKit
   import Flutter
  -import flutter_jsbridge
  +import JSBridge

   @UIApplicationMain
   @objc class AppDelegate: FlutterAppDelegate {
  @@ -8,7 +8,7 @@ import flutter_jsbridge
       _ application: UIApplication,
       didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
     ) -> Bool {
  -    SwiftFlutterJsbridgePlugin.setGlobalUIHook(window: UIApplication.shared.windows.first!)
  +    JSBridge.setGlobalUIHook(window: UIApplication.shared.windows.first!)
       GeneratedPluginRegistrant.register(with: self)
       return super.application(application, didFinishLaunchingWithOptions: launchOptions)
     }
  ```

## 0.2.0

- 💥 Upgrade to JSBridge 0.2.x

  Migration Guide:

  See the [migration guide for JSBridge 0.2.x](https://github.com/LinusU/flutter_jsbridge/commit/c654237afe72edc2f76f6aba4b6650cb2c2a89b5)

## 0.1.0

- 🎉 Add initial implementation
