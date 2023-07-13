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
  <a href="#installation">Installation</a> •
  <a href="#usage">Usage</a> •
  <a href="#api">API</a> •
  <a href="#contribute">Contribute</a> •
  <a href="https://github.com/kyoz/godot-local-notification/releases">Downloads</a> 
</p>

<p align="center">
  <img src="./demo.jpg" style="max-width: 580px; border-radius: 24px">
</p>

# About

This plugin help send Local Notification (Android/iOS). You can use it to send notifications to user at the time you want (No Internet need).

This plugin just handle Local Notification, it not support Remote Notification.

Was build using automation scripts combine with CI/CD to help faster the release progress and well as release hotfix which save some of our times.

Support Godot 3 & 4.

# Installation

## Android

Download the [android plugin](https://github.com/kyoz/godot-local-notification/releases) (match your Godot version), extract them to `your_project/android/plugins`

Enable `LocalNotification` plugin in your android export preset

*Note*: You must [use custom build](https://docs.godotengine.org/en/stable/tutorials/export/android_custom_build.html) for Android to use plugins.

## iOS

Download the [ios plugin](https://github.com/kyoz/godot-local-notification/releases) (match your Godot version), extract them to `ios/plugins`

Enable `LocalNotification` plugin in your ios export preset

# Usage

You will need to add an `autoload` script to use this plugin more easily.

Download [autoload file](./autoload) to your game (Choose correct Godot version). Add it to your project `autoload` list.

Then you can easily use it anywhere with:

```gdscript
LocalNotification.init()
LocalNotification.show()

# Godot 3
LocalNotification.connect("on_completed", self, "_on_completed")

# Godot 4
LocalNotification.on_completed.connect(_on_completed)
```

Why have to call `init()`. Well, if you don't want to call init, you can change `init()` to `_ready()` on the `autoload` file. But for my experience when using a lots of plugin, init all plugins on `_ready()` is not a good idea. So i let you choose whenever you init the plugin. When showing a loading scene...etc...

For more detail, see [examples](./example/)

# API

## Methods

```gdscript
void show() # sdfjo
```

## Signals

```gdscript
signal on_error(error_code) # request fail, return error_code
signal on_completed() # request and show completed
```

## Error Codes

> `ERROR_GOOGLE_PLAY_UNAVAILABLE`

Android only. Happen when there's no Google Play Services on the user phone. Rarely happen. Cause normally, they will install your app through Google Play.

> `ERROR_NO_ACTIVE_SCENE`

iOS only. Happen when the plugin can't find active scene. Make sure you calling `show()` method when the app are runing in foreground.

> `ERROR_UNKNOWN`

Is rarely happen too. 

# Contribute

I want to help contribute to Godot community so i create these plugins. I'v prepared almost everything to help the development and release progress faster and easier.

Only one command and you'll build, release this plugin. Read [DEVELOP.md](./DEVELOP.md) for more information.

If you found bug of the plugin, please open issues.

If you have time to fix bugs or improve the plugins. Please open PR, it's always welcome.

# License

MIT © [Kyoz](mailto:banminkyoz@gmail.com)