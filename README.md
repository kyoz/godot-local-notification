<h1 align="center">
  <br>
  <img src="./icon.png" alt="Godot Local Notification" width=512>
  <br>
  Godot Local Notification
  <br>
</h1>

<h4 align="center">Godot plugin to send Local Notification on Android/iOS. Support Godot 3 & 4</a>.</h4>

<p align="center">
  <a href="https://github.com/kyoz/godot-local-notification/releases">
    <img src="https://img.shields.io/github/v/tag/kyoz/godot-local-notification?label=Version&style=flat-square">
  </a>
  <span>&nbsp</span>
  <a href="https://github.com/kyoz/godot-local-notification/actions">
    <img src="https://img.shields.io/github/actions/workflow/status/kyoz/godot-local-notification/release.yml?label=Build&style=flat-square&color=00ad06">
  </a>
  <span>&nbsp</span>
  <a href="https://github.com/kyoz/godot-local-notification/releases">
    <img src="https://img.shields.io/github/downloads/kyoz/godot-local-notification/total?style=flat-square&label=Downloads&color=de3f00">
  </a>
  <span>&nbsp</span>
  <img src="https://img.shields.io/github/stars/kyoz/godot-local-notification?style=flat-square&color=c99e00">
  <span>&nbsp</span>
  <img src="https://img.shields.io/github/license/kyoz/godot-local-notification?style=flat-square&color=fc7b03">
</p>

<p align="center">
  <a href="#about">About</a> •
  <a href="#caution">Caution</a> •
  <a href="#installation">Installation</a> •
  <a href="#customize">Customize</a> •
  <a href="#usage">Usage</a> •
  <a href="#api">API</a> •
  <a href="#contribute">Contribute</a> •
  <a href="https://github.com/kyoz/godot-local-notification/releases">Downloads</a> 
</p>

<p align="center">
  <img src="./demo.jpg" style="max-width: 580px; border-radius: 24px">
</p>

# About

This plugin help send Local Notification (Android/iOS). You can use it to send notifications to user at the time you want, or send daily notification at the specific time you want.

This plugin just handle Local Notification, it not support Remote Notification.

Was build using automation scripts combine with CI/CD to help faster the release progress and well as release hotfix which save some of our times.

Support Godot 3 & 4.

# Caution

This plugin to support latest Android (13+) and iOS. But there is some thing you must know before using.

The notification time may delay a few seconds or even minutes. If the user turn on Battery Optimize mode on their phone, your notifications will delay longer or even not display. The reason for that is i'm trying to not using `unsafe` permissions (Android). Cause it's way to risky, can crash your apps/games and not worth it.

On iOS, the minimal `repeating_interval` is 60.

You shouldn't show notification when they using your app/game too, it's just annoying them. Schedule to send notifications at specific times like when energy is full, when the tree are mature or st like that...

When showing notifications, try to store their tags somewhere, in case you want to remove and schedule new set of notifications.

# Installation

## Android

Download the [android plugin](https://github.com/kyoz/godot-local-notification/releases) (match your Godot version), extract them to `your_project/android/plugins`

Enable `LocalNotification` plugin in your android export preset

*Note*: You must [use custom build](https://docs.godotengine.org/en/stable/tutorials/export/android_custom_build.html) for Android to use plugins.

## iOS

Download the [ios plugin](https://github.com/kyoz/godot-local-notification/releases) (match your Godot version), extract them to `ios/plugins`

Enable `LocalNotification` plugin in your ios export preset

# Customize

On Android, you can change the color of notification by adding `notification-color.xml` to your app/game's `android/build/res/values` folder with content like so:

```
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="notification_color">#000000</color>
</resources>
```

Default color are black (#000000)

You should also use [this](https://romannurik.github.io/AndroidAssetStudio/icons-notification.html) or [Image Asset Studio](https://developer.android.com/studio/write/create-app-icons) (in Android Studio) to generate your notification icons too, and put them in mipmap folders.

The name of notification icon must be `notification_icon.png`

```
android/build/res/mipmap*/notification_icon.png
```

On iOS, the notification icon will be the default App Icon so there's no need to do anything except design your beautiful icon.

# Usage

You will need to add an `autoload` script to use this plugin more easily.

Download [autoload file](./autoload) to your game (Choose correct Godot version). Add it to your project `autoload` list.

Then you can easily use it anywhere with:

```gdscript
LocalNotification.init()

LocalNotification.requestPermission()

# To ensure the request process is done, you can use the signal as you like,
# I prefer this solution
yield(LocalNotification, "on_permission_request_completed")

if LocalNotification.isPermissionGranted():
  LocalNotification.show(title, message, 30, 10)
```

Why have to call `init()`. Well, if you don't want to call init, you can change `init()` to `_ready()` on the `autoload` file. But for my experience when using a lots of plugin, init all plugins on `_ready()` is not a good idea. So i let you choose whenever you init the plugin. When showing a loading scene...etc...

For more detail, see [examples](./example/)

# API

## Methods

> `isPermissionGranted`() -> bool

Use to check current status of permission. return true if permission was granted, false if it is not granted or denied

> `requestPermission`() -> void

Use to request permission to show local notification. On Android <= 12, the permission is alway granted. But you should call it anyway, to have clean code base for all version, platforms.

> `openAppSetting`() -> void

Use to open app setting. When user denied one on iOS and twice on Android, the permission dialog will never appear again. So i make this as a handy method for user to jump to App Setting so they can re-active notification.

*WARNING*: After calling `requestPermission()` if `isPermissionGranted()` still return `false`. It's mean user has denied the permission. You can use this function to help user easily toggle notification on. But you should prompt a dialog or st like that to let user know, or choose to open App Setting or not. Just don't jump out of the app without any notify, they will confuse and may never go back to your app again :(

> `show`(title, message, interval, tag) -> void

Use to show a notification after `interval` seconds. The `interval` must be greater than 0. And on `iOS` the notification may not show if the app are running on foreground.

> `showRepeating`(title, message, interval, repeat_interval, tag) -> void

Just like `show()` function but the notification will keep repeat after `repeat_interval`.

> `showDaily`(title, message, at_hour, at_minute, tag) -> void

Show daily notification at your choosen hour and minute.

> `cancel`(tag) -> void

Cancel a notification with it tag. When showing notifications, you should store their tags somewhere, in case you want to cancel em and schedule new set of notifications.

## Signals

```gdscript
signal on_permission_request_completed() # emit when the permission request flow completed
```

# Contribute

I want to help contribute to Godot community so i create these plugins. I'v prepared almost everything to help the development and release progress faster and easier.

Only one command and you'll build, release this plugin. Read [DEVELOP.md](./DEVELOP.md) for more information.

If you found bug of the plugin, please open issues.

If you have time to fix bugs or improve the plugins. Please open PR, it's always welcome.

# License

MIT © [Kyoz](mailto:banminkyoz@gmail.com)